# coding:utf-8
import numpy as np
from utils import load_pkl
from sklearn.model_selection import train_test_split
from flair.data import Sentence
from tqdm import tqdm
import nltk, re, pprint
from nltk.tokenize.simple import SpaceTokenizer
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')

class Environment:
    def __init__(self, args, agent_mode):
        # initializes environment variables and then reads sentences.

        print('Initializing the Environment...')
        self.domain = args.domain
        self.dis_dim = args.dis_dim  # 50
        self.tag_dim = args.tag_dim  # 50
        self.word_dim = args.word_dim  # 50
        self.num_words = args.num_words  # 500
        self.action_rate = args.action_rate  # 0.1
        self.use_act_rate = args.use_act_rate  # 1
        # self.use_act_att = args.use_act_att  # 0
        self.reward_base = args.reward_base  # 50.0
        self.ra = args.reward_assign  # [1,2,3]
        self.word2vec = args.word2vec
        self.terminal_flag = False
        self.train_epoch_end_flag = False
        self.valid_epoch_end_flag = False
        self.max_data_char_len = 0
        self.max_data_sent_len = 0
        self.agent_mode = agent_mode  # args.agent_mode
        self.context_len = args.context_len # 100
        self.stacked_embeddings = args.stacked_embeddings


        # read the sentences!!!
        if not args.gui_mode:
            if self.agent_mode == 'arg':

                indata = load_pkl('data/refined_%s_data.pkl' % self.domain)[-1]
                arg_sents = []

                for i in tqdm(range(len(indata))):
                    for j in range(len(indata[i])):
                        if len(indata[i][j]) == 0:
                            continue
                        # -1 obj_ind refer to UNK
                        # words = indata[i][j]['last_sent'] + indata[i][j]['this_sent'] + ['UNK'] # we don't need an unknown here.
                        words = indata[i][j]['last_sent'] + indata[i][j]['this_sent']
                        current_sent = indata[i][j]['this_sent']
                        sent_len = len(words) #here sent len is last_sent + this_sent.
                        act_inds = [a['act_idx'] for a in indata[i][j]['acts'] if a['act_idx'] < self.num_words] #list of action indexes less than self.num_words = 128
                        for k in range(len(indata[i][j]['acts'])):
                            act_ind = indata[i][j]['acts'][k]['act_idx'] # action index
                            obj_inds = indata[i][j]['acts'][k]['obj_idxs'] # object index list
                            arg_sent = {}

                            # set arg tags
                            arg_tags = np.ones(sent_len, dtype=np.int32) # tags

                            if len(obj_inds[1]) == 0:
                                arg_tags[obj_inds[0]] = 2  # essential objects
                            else:
                                arg_tags[obj_inds[0]] = 4  # exclusive objects
                                arg_tags[obj_inds[1]] = 4  # exclusive objects

                            # set distance
                            position = np.zeros(sent_len, dtype=np.int32)
                            position.fill(act_ind)
                            distance = np.abs(np.arange(sent_len) - position)


                            arg_sent['tokens'] = words
                            arg_sent['tags'] = arg_tags
                            arg_sent['act_ind'] = act_ind
                            arg_sent['distance'] = distance
                            arg_sent['act_inds'] = act_inds
                            arg_sent['obj_inds'] = obj_inds

                            # ipdb.set_trace()
                            sent_vec = []

                            if args.stacked_embeddings == 'word2vec':
                                for w in arg_sent['tokens']:
                                    if len(w) > self.max_data_char_len:
                                        self.max_data_char_len = len(w)
                                    if w in self.word2vec.vocab:
                                        sent_vec.append(self.word2vec[w])
                                    else:
                                        sent_vec.append(np.zeros(self.word_dim))
                            else:
                                # Stacked embeddings
                                line = ' '.join(words)
                                tokens2 = SpaceTokenizer().tokenize(line)
                                pos_list = nltk.pos_tag(tokens2)
                                pos_list_joined = []
                                for tup in pos_list:
                                    tup = '|'.join(tup[0:2])
                                    pos_list_joined.append(tup)
                                line = ' '.join(pos_list_joined)

                                sent = Sentence(line)
                                args.stacked_embeddings.embed(sent)
                                for token in sent:
                                    sent_vec.append(token.embedding.numpy())

                                for w in arg_sent['tokens']:
                                    if len(w) > self.max_data_char_len:
                                        self.max_data_char_len = len(w)

                            sent_vec = np.array(sent_vec)
                            pad_len = self.num_words - len(sent_vec)


                            if len(sent_vec) > self.max_data_sent_len:
                                self.max_data_sent_len = len(sent_vec)

                            distance = np.zeros([self.num_words, self.dis_dim])
                            act_vec = sent_vec[arg_sent['act_ind']]  # word vector of the input action

                            # TODO: Attention is not required for contextual word embeddings, so commented it out to save time. Try it out if time permits.
                            # attention = np.sum(sent_vec * act_vec, axis=1)  # attention between the input action and its context
                            # attention = np.exp(attention)
                            # attention /= sum(attention)

                            if pad_len > 0:
                                # doc_vec = np.concatenate((doc_vec, np.zeros([pad_len, self.word_dim])))  # doc_vec.shape = [5oo, 5o]
                                # act_text['tags'] = np.concatenate((np.array(act_text['tags']), np.ones(pad_len, dtype=np.int32)))  # [500]
                                sent_vec = np.concatenate((sent_vec, np.zeros([pad_len, self.word_dim]))) #
                                arg_sent['tags'] = np.concatenate((np.array(arg_sent['tags']), np.ones(pad_len, dtype=np.int32)))
                                # attention = np.concatenate((attention, np.zeros(pad_len)))
                                for d in range(len(arg_sent['distance'])):
                                    distance[d] = arg_sent['distance'][d]
                            else:
                                sent_vec = sent_vec[: self.num_words]
                                arg_sent['tokens'] = arg_sent['tokens'][: self.num_words]
                                arg_sent['tags'] = np.array(arg_sent['tags'])[: self.num_words]
                                # attention = attention[: self.num_words]
                                for d in range(self.num_words):
                                    distance[d] = arg_sent['distance'][d]

                            # TODO: Future work: Use attention
                            # if self.use_act_att:  # apply attention to word embedding
                            #     sent_vec = attention.reshape(-1, 1) * sent_vec

                            sent_vec = np.concatenate((sent_vec, distance), axis=1)


                            arg_sent['sent_vec'] = sent_vec
                            arg_sent['tags'].shape = (self.num_words, 1)
                            # self.create_matrix(arg_sent,words) #create_matrix function
                            arg_sents.append(arg_sent)
                '''
                Split into train and test first. 
                Split train into train and val then.
                '''
                self.train_data, self.test_data = train_test_split(arg_sents, test_size=0.2, random_state=1)
                self.train_data, self.validation_data = train_test_split(self.train_data, test_size=0.2, random_state=1)

                self.train_steps = len(self.train_data) * self.num_words
                self.validation_steps = len(self.validation_data) * self.num_words
                self.test_steps = len(self.test_data) * self.num_words

                self.num_train = len(self.train_data)
                self.num_validation = len(self.validation_data)
                self.num_test = len(self.test_data)

                print('\n\ntraining texts: %d\tvalidation texts: %d' % (len(self.train_data), len(self.validation_data)))
                print('max_data_sent_len: %d\tmax_data_char_len: %d' % (self.max_data_sent_len, self.max_data_char_len))
                print('self.train_steps: %d\tself.valid_steps: %d\n\n' % (self.train_steps, self.validation_steps))

                print('\n\ntest texts: %d\t self.test_steps:%d\n' % (len(self.test_data), self.test_steps))
            else: #actions
                # self.read_act_texts()

                # read action texts into input_data

                input_data = load_pkl('data/%s_labeled_text_data.pkl' % self.domain)


                # unroll the stuff inside and store it in a list called act_texts
                act_texts = []
                for i in range(len(input_data)): #until length of training examples (documents)
                    if len(input_data[i]['words']) == 0: #if there are no words in a document
                        continue
                    # act_text is a dictionary to store info.
                    act_text = {}
                    act_text['tokens'] = input_data[i]['words'] #tokens = individual words
                    act_text['sents'] = input_data[i]['sents'] #sents = sentences [['a ','cat ', 'runs.'], [ ], ...]
                    act_text['acts'] = input_data[i]['acts'] #acts = [{},{},{}, ..] where {} = 4 tuple containing keys: [act_idx, obj_idxs, act_type, related_acts]
                    act_text['sent_acts'] = input_data[i]['sent_acts'] #list of acts in a sentence for every sentence.
                    act_text['word2sent'] = input_data[i]['word2sent'] # {0:0, 1:0, 2:0, .... 38:2....} Mapping of word_index to sentence_index
                    act_text['tags'] = np.ones(len(input_data[i]['words']), dtype=np.int32) #same length as number of words in a document.
                    act_text['act2related'] = {} #related actions

                    #for all action 4 tuples
                    for acts in input_data[i]['acts']:
                        act_text['act2related'][acts['act_idx']] = acts['related_acts'] # act_text['act2related'] = {act_idx: []} where [] is list of related actions
                        act_text['tags'][acts['act_idx']] = acts['act_type'] + 1  # TODO: 2, 3, 4? - why? act_text['tags'] = [2,3,4,2,2,3,3,4,4,...] where index of array is action_index

                    # self.create_matrix(act_text)
                    # Creating matrix
                    doc_vec = []

                    if args.stacked_embeddings != 'word2vec':
                        # doing Flair embeddings
                        for sent in tqdm(act_text['sents']):
                            line = ' '.join(sent)
                            tokens2 = SpaceTokenizer().tokenize(line)
                            pos_list = nltk.pos_tag(tokens2)
                            pos_list_joined = []
                            for tup in pos_list:
                                tup = '|'.join(tup[0:2])
                                pos_list_joined.append(tup)
                            line = ' '.join(pos_list_joined)
                            print(line)
                            sentence = Sentence(line)
                            args.stacked_embeddings.embed(sentence)
                            for token in sentence:
                                # print(token.embedding.shape)  # 4196

                                doc_vec.append(token.embedding.numpy())


                        #initialize word2vec or zeroes
                        for word in act_text['tokens']:
                            if len(word) > self.max_data_char_len:
                                self.max_data_char_len = len(word) #max_data_char_len shows longest word.
                            # if word in self.word2vec.vocab:
                            #     doc_vec.append(self.word2vec[word])
                            # else:
                            #     doc_vec.append(np.zeros(self.word_dim))

                    elif args.stacked_embeddings == 'word2vec':
                        # initialize word2vec or zeroes
                        for word in act_text['tokens']:
                            if len(word) > self.max_data_char_len:
                                self.max_data_char_len = len(word)  # max_data_char_len shows longest word.
                            if word in self.word2vec.vocab:
                                doc_vec.append(self.word2vec[word])
                            else:
                                doc_vec.append(np.zeros(self.word_dim))



                    doc_vec = np.array(doc_vec)
                    pad_len = self.num_words - len(doc_vec)
                    if len(doc_vec) > self.max_data_sent_len:
                        self.max_data_sent_len = len(doc_vec) #max_data_sent_len is length of longest document vector..

                    # print(doc_vec.shape)

                    if pad_len > 0: #if not negative.
                        doc_vec = np.concatenate((doc_vec, np.zeros([pad_len, self.word_dim]))) # doc_vec.shape = [5oo, 5o]
                        act_text['tags'] = np.concatenate((np.array(act_text['tags']), np.ones(pad_len, dtype=np.int32))) # [500]
                    else: #pad_len is negative
                        doc_vec = doc_vec[: self.num_words] #pick first 500
                        act_text['tokens'] = act_text['tokens'][: self.num_words] #also in tokens, first 500
                        act_text['tags'] = np.array(act_text['tags'])[: self.num_words] #also in tags, first 500

                    act_text['sent_vec'] = doc_vec  # set sentence vec to 500,50 doc_vec
                    act_text['tags'].shape = (self.num_words, 1)  # redefine shape to 500,1


                    act_texts.append(act_text) #keep collecting documents in act_texts


                '''
                Split into train and test first. 
                Split train into train and val then.
                '''
                # seed makes sure dataset is always split in the same way randomly
                self.train_data, self.test_data = train_test_split(act_texts, test_size=0.2, random_state=1)
                self.train_data, self.validation_data = train_test_split(self.train_data, test_size=0.2, random_state=1)

                self.train_steps = len(self.train_data) * self.num_words # length of train data * 500
                self.validation_steps = len(self.validation_data) * self.num_words #length of validation data * 500 -- Why a step includes multiplication with num_words?  because each training and val example contains 500 words.
                self.test_steps = len(self.test_data) * self.num_words

                self.num_train = len(self.train_data)
                self.num_validation = len(self.validation_data)
                self.num_test = len(self.test_data)

                print('\n\ntraining texts: %d\tvalidation texts: %d' % (len(self.train_data), len(self.validation_data)))
                print('max_data_sent_len: %d\tmax_data_char_len: %d' % (self.max_data_sent_len, self.max_data_char_len)) #sent len means doc len
                print('self.train_steps: %d\tself.valid_steps: %d\n\n' % (self.train_steps, self.validation_steps))

                print('\n\ntest texts: %d\t self.test_steps:%d\n' % (len(self.test_data), self.test_steps))

            args.train_steps = self.train_steps
            args.valid_steps = self.validation_steps  # validation steps
            args.test_steps = self.test_steps


    def restart(self, train_flag, init=False, test_flag=False):
        if train_flag:
            if init:
                self.train_text_ind = -1
                self.train_epoch_end_flag = False
            self.train_text_ind += 1
            if self.train_text_ind >= len(self.train_data):
                self.train_epoch_end_flag = True
                print('\n\n-----train_epoch_end_flag = True-----\n\n')
                return
            self.current_text = self.train_data[self.train_text_ind % self.num_train]
            print('\ntrain_text_ind: %d of %d' % (self.train_text_ind, len(self.train_data)))
        elif test_flag:
            print("Testing unseen data")
            if init:
                self.test_text_ind = -1
                self.test_epoch_end_flag = False
            self.test_text_ind += 1
            if self.test_text_ind >= len(self.test_data):
                self.valid_epoch_end_flag = True
                print('\n\n-----test_epoch_end_flag = True-----\n\n')
                return
            self.current_text = self.test_data[self.test_text_ind]
            print('\ntest_text_ind: %d of %d' % (self.test_text_ind, len(self.test_data)))

        else:
            if init:
                self.valid_text_ind = -1
                self.valid_epoch_end_flag = False
            self.valid_text_ind += 1
            if self.valid_text_ind >= len(self.validation_data):
                self.valid_epoch_end_flag = True
                print('\n\n-----valid_epoch_end_flag = True-----\n\n')
                return
            self.current_text = self.validation_data[self.valid_text_ind]
            print('\nvalid_text_ind: %d of %d' % (self.valid_text_ind, len(self.validation_data)))

        self.text_vec = np.concatenate((self.current_text['sent_vec'], self.current_text['tags']), axis=1)
        self.state = self.text_vec.copy()
        self.state[:, -1] = 0
        self.terminal_flag = False

    def act(self, action, word_ind):
        '''
        Performs action and returns reward
        even num refers to tagging action, odd num refer to non-action
        '''
        self.state[word_ind, -1] = action + 1
        # t_a_count = 0  #amount of tagged actions
        t_a_count = sum(self.state[: word_ind + 1, -1]) - (word_ind + 1)
        t_a_rate = float(t_a_count) / self.num_words

        label = self.text_vec[word_ind, -1]
        self.real_action_flag = False
        if self.agent_mode == 'arg':
            # text_vec is labelled data
            if label >= 2:
                self.real_action_flag = True
            if label == 2:
                if action == 1:
                    reward = self.ra[1] * self.reward_base
                else:
                    reward = -self.ra[1] * self.reward_base
            elif label == 4:
                right_flag = True
                if word_ind in self.current_text['obj_inds'][0]:
                    exc_objs = self.current_text['obj_inds'][1]
                else:
                    exc_objs = self.current_text['obj_inds'][0]
                for oi in exc_objs:  # exclusive objs
                    if self.state[oi, -1] == 2:
                        right_flag = False
                        break
                if action == 1 and right_flag:
                    reward = self.ra[2] * self.reward_base
                elif action == 2 and not right_flag:
                    reward = self.ra[2] * self.reward_base
                elif action == 2 and word_ind != self.current_text['obj_inds'][1][-1]:
                    reward = self.ra[2] * self.reward_base
                else:
                    reward = -self.ra[2] * self.reward_base
            else:  # if label == 1: # non_action
                if action == 0:
                    reward = self.ra[0] * self.reward_base
                else:
                    reward = -self.ra[0] * self.reward_base

        else:  # self.agent_mode == 'act'
            if label >= 2:
                self.real_action_flag = True
            if label == 2:  # required action
                if action == 1:  # extracted as action
                    reward = self.ra[1] * self.reward_base
                else:  # filtered out
                    reward = -self.ra[1] * self.reward_base
            elif label == 3:  # optional action
                if action == 1:
                    reward = self.ra[0] * self.reward_base
                else:
                    reward = 0.0
            elif label == 4:  # exclusive action
                # ipdb.set_trace()
                assert word_ind in self.current_text['act2related']
                exclusive_act_inds = self.current_text['act2related'][word_ind]
                exclusive_flag = False
                not_biggest_flag = False
                for ind in exclusive_act_inds:
                    if self.state[ind, -1] == 2:  # extracted as action
                        exclusive_flag = True
                    if ind > word_ind:
                        not_biggest_flag = True
                if action == 1 and not exclusive_flag:
                    # extract current word and no former exclusive action was extracted
                    reward = self.ra[2] * self.reward_base
                elif action == 0 and exclusive_flag:
                    # filtered out current word because one former exclusive action was extracted
                    reward = self.ra[2] * self.reward_base
                elif action == 0 and not_biggest_flag:
                    # filtered out current word and at least one exclusive action left
                    reward = self.ra[2] * self.reward_base
                else:
                    reward = -self.ra[2] * self.reward_base
            else:  # if label == 1: # non_action
                if action == 0:
                    reward = self.ra[0] * self.reward_base
                else:
                    reward = -self.ra[0] * self.reward_base

        if self.use_act_rate and reward != 0:
            if t_a_rate <= self.action_rate and reward > 0:
                reward += 5.0 * np.square(t_a_rate) * self.reward_base
            else:
                reward -= 5.0 * np.square(t_a_rate) * self.reward_base
        # all words of current text are tagged, break
        if word_ind + 1 >= len(self.current_text['tokens']):
            self.terminal_flag = True

        return reward

    def getState(self):
        '''
        Gets current text state
        '''
        return self.state

    def isTerminal(self):
        '''
        Returns if tag_actions is done
        if all the words of a text have been tagged, then terminate
        '''
        return self.terminal_flag

# ==================================== GUI MODE functions/Driver Mode functions
    def init_predict_act_text(self, raw_text):
        text = {'tokens': [], 'sents': [], 'word2sent': {}}
        for s in raw_text:
            words = s.split()
            if len(words) > 0:
                for i in range(len(words)): # for word 0 to word n-1
                    text['word2sent'][i + len(text['tokens'])] = [len(text['sents']), i]
                text['tokens'].extend(words)
                text['sents'].append(words)

        sent_vec = np.zeros([self.num_words, self.word_dim + 1])  # 512 x (968 + 1) ------ 1 for tag

        if self.stacked_embeddings == 'word2vec':
            for i, w in enumerate(text['tokens']):
                if i >= self.num_words:
                    break
                if w in self.word2vec.vocab:
                    sent_vec[i][: self.word_dim] = self.word2vec[w]

        else:
            word_count = 0
            for sent in tqdm(text['sents']):
                line = ' '.join(sent)
                sentence = Sentence(line)
                self.stacked_embeddings.embed(sentence)
                for token in sentence:
                    print(token)
                    # print(token.embedding.shape)  # 868 for elmo
                    sent_vec[word_count][:self.word_dim] = token.embedding.numpy()
                    word_count += 1

        self.state = sent_vec
        self.terminal_flag = False
        self.current_text = text

    def init_predict_arg_text(self, act_idx, text):
        '''used in gui mode'''
        self.terminal_flag = False
        sents = text['sents']
        word2sent = text['word2sent']
        sent_idx = word2sent[act_idx][0]
        word_ids = []
        this_sent = sents[sent_idx]
        if sent_idx > 0:  # use the former sentence and current one
            last_sent = sents[sent_idx - 1]
            for k, v in word2sent.items():
                if v[0] == sent_idx or v[0] == sent_idx - 1:
                    word_ids.append(k)
        else:
            last_sent = []
            for k, v in word2sent.items():
                if v[0] == sent_idx:
                    word_ids.append(k)
        words = last_sent + this_sent #+ ['UNK']
        end_idx = max(word_ids)  # the last index of words of these two sents
        start_idx = min(word_ids)
        sent_len = len(words)

        position = np.zeros(sent_len, dtype=np.int32)
        position.fill(act_idx - start_idx)
        distance = np.abs(np.arange(sent_len) - position)
        # sent_vec = np.zeros([self.context_len, self.word_dim + self.dis_dim + self.tag_dim])
        sent_vec = np.zeros([self.context_len, self.word_dim + self.dis_dim + 1])  # 100x101

        if self.stacked_embeddings == 'word2vec':
            for i, w in enumerate(words):
                if i >= self.context_len:
                    break
                if w in self.word2vec.vocab:
                    sent_vec[i][: self.word_dim] = self.word2vec[w]
                sent_vec[i][self.word_dim: self.word_dim + self.dis_dim] = distance[i]
        else:

            for i, w in enumerate(words):
                if i >= self.context_len:
                    break
                # if w in self.word2vec.vocab:
                #     sent_vec[i][: self.word_dim] = self.word2vec[w]
                # sent_vec[i][self.word_dim: self.word_dim + self.dis_dim] = distance[i]

            #stacked embeddings
            full_sent = ' '.join(words)
            full_sent = Sentence(full_sent)
            self.stacked_embeddings.embed(full_sent)

            for i, token in enumerate(full_sent):
                sent_vec[i][:self.word_dim] = token.embedding.numpy()
                sent_vec[i][self.word_dim: self.word_dim + self.dis_dim] = distance[i]
        self.state = sent_vec
        self.current_text = {'tokens': words, 'word2sent': word2sent, 'distance': distance}
        return last_sent, this_sent




    def act_online(self, action, word_ind):
        '''used in gui mode'''
        self.state[word_ind, -1] = action + 1
        # print(self.state[word_ind, self.word_dim: self.word_dim + self.dis_dim]) #distance
        # self.state[word_ind, -self.tag_dim:] = action + 1 #from 868 from last to end change it
        # print(self.state.shape)
        if word_ind + 1 >= len(self.current_text['tokens']):
            self.terminal_flag = True