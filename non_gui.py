import re
import tensorflow as tf
tf.set_random_seed(0)
import numpy as np

from main import preset_args, args_init
from EADQN import DeepQLearner
from Environment import Environment
from keras.backend.tensorflow_backend import set_session


class Agent(object):
    """docstring for Agent"""

    def __init__(self, args, sess):
        self.env_act = Environment(args, 'act')
        self.net_act = DeepQLearner(args, 'act', 'channels_last')
        self.env_arg = Environment(args, 'arg')
        self.net_arg = DeepQLearner(args, 'arg', 'channels_last')
        self.num_words = args.num_words
        self.context_len = 128
        self.stacked_embeddings = args.stacked_embeddings

    def predict(self, text):
        # e.g. text = ['Cook the rice the day before.', 'Use leftover rice.']
        self.env_act.init_predict_act_text(self.stacked_embeddings, text)
        sents = []  # dictionary for last sentence, this sentence and actions
        for i in range(len(self.env_act.current_text['sents'])):
            last_sent = self.env_act.current_text['sents'][i - 1] if i > 0 else []
            this_sent = self.env_act.current_text['sents'][i]

            sents.append({'last_sent': last_sent, 'this_sent': this_sent, 'acts': []})

        for i in range(self.num_words):
            state_act = self.env_act.getState()
            qvalues_act = self.net_act.predict(state_act)
            print(qvalues_act)
            action_act = np.argmax(qvalues_act[0])
            print(action_act)
            self.env_act.act_online(action_act, i)
            if action_act == 1:
                last_sent, this_sent = self.env_arg.init_predict_arg_text(self.stacked_embeddings, i, self.env_act.current_text)
                for j in range(self.context_len):
                    state_arg = self.env_arg.getState()
                    qvalues_arg = self.net_arg.predict(state_arg)
                    action_arg = np.argmax(qvalues_arg[0])
                    self.env_arg.act_online(action_arg, j)
                    if self.env_arg.terminal_flag:
                        break

                act_idx = i
                obj_idxs = []
                sent_words = self.env_arg.current_text['tokens']
                tmp_num = self.context_len if len(sent_words) >= self.context_len else len(sent_words)
                for j in range(tmp_num):
                    if self.env_arg.state[j, -1] == 2:
                        if j == len(sent_words) - 1:
                            j = -1
                        obj_idxs.append(j)
                if len(obj_idxs) == 0:
                    obj_idxs.append(-1)
                si, ai = self.env_act.current_text['word2sent'][i]
                ai += len(sents[si]['last_sent'])
                sents[si]['acts'].append({'act_idx': ai, 'obj_idxs': [obj_idxs, []],
                                          'act_type': 1, 'related_acts': []})
            if self.env_act.terminal_flag:
                break
        return sents


def EASDRL_init(args, sess):
    args.gui_mode = True
    args.fold_id = 0
    args.domain = 'cooking'
    args.replay_size = 1000 # was 1000, changing to 10000
    args.load_weights = True
    args = args_init(args)

    # ipdb.set_trace()
    agent = Agent(args, sess)

    if args.load_weights:
        print('Loading weights ...')
        filename = 'weights/%s_act_elmo.h5' % (args.domain)
        # filename = 'data/online_test/cooking/act/fold0.h5'
        agent.net_act.load_weights(filename)
        filename = 'weights/%s_arg_elmo.h5' % (args.domain)
        # filename = 'data/online_test/cooking/arg/fold0.h5'
        agent.net_arg.load_weights(filename)

    return agent


if __name__ == '__main__':
    args = preset_args()
    gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=args.gpu_fraction)
    set_session(tf.Session(config=tf.ConfigProto(gpu_options=gpu_options)))
    agent = EASDRL_init(args, sess='')  # for keras
    print('weights loaded ...')

    #run commandline program unlimited #TODO: have command line arguments for input and output files.
    input_file_path = 'data/online_test/13.txt'

    #input file
    current_sents = []
    raw_text = open(input_file_path, 'r').read() + ' '
    if not raw_text or len(raw_text.split()) < 2:
        print("raw text error")
    print(raw_text)
    raw_text = re.split(r'\n|\r', raw_text)  # for text which has not punctuation
    text = []
    for t in raw_text:
        t = re.sub(r'\(|\)|,|;|:', ' ', t)
        for s in re.split(r'\. |\? |\! ', t):
            if len(s) > 1:
                if s.isupper():  # all words are upper case
                    text.append(s[0] + s[1:].lower())
                else:
                    text.append(s)
    current_sents = agent.predict(text)


    #show results
    count_act = 0
    act2sent = {}
    sents = current_sents
    outfile = 'data/online_test/win2k_output.txt'
    f = open(outfile, "w")
    output = ""
    for i in range(len(sents)):
        words = sents[i]['last_sent'] + sents[i]['this_sent']
        output += '\nNO%d: ' % (i + 1)
        f.write('\nNO%d: ' % (i + 1))
        for j, w in enumerate(sents[i]['this_sent']):
            f.write('%s(%d) ' % (w, j + 1))
            output += '%s(%d) ' % (w, j + 1)
        f.write('\n')
        output += '\n'
        for k, act in enumerate(sents[i]['acts']):
            objs = []
            for oi in act['obj_idxs'][0] + act['obj_idxs'][1]:
                if oi >= 0:
                    objs.append(words[oi])
                else:
                    objs.append('UNK')
            act2sent[count_act] = [i, k]
            f.write('<%d>  %s (%s)    ' % (count_act + 1, words[act['act_idx']], ', '.join(objs)))
            output += '<%d>  %s (%s)    ' % (count_act + 1, words[act['act_idx']], ', '.join(objs))
            count_act += 1
        if len(sents[i]['acts']) > 0:
            f.write('\n')
            output += '\n'
    f.close()
    print(output)

