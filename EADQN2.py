import ipdb
import keras
import numpy as np
import tensorflow as tf
import keras.layers as kl
from keras.backend.tensorflow_backend import set_session
from keras.layers import *
from keras.models import Model
from keras.layers.normalization import BatchNormalization


class DeepQLearner:
    def __init__(self, args, agent_mode, data_format):
        print('Initializing the DQN...')
        self.word_dim = args.word_dim
        self.tag_dim = args.tag_dim
        self.dropout = args.dropout
        self.optimizer = args.optimizer
        self.dense_dim = args.dense_dim
        self.batch_size = args.batch_size
        self.gamma = args.gamma
        self.learning_rate = args.learning_rate
        self.num_actions = args.num_actions
        self.num_filters = args.num_filters
        self.data_format = data_format
        self.agent_mode = agent_mode
        if agent_mode == 'act':
            self.num_words = args.num_words
            self.emb_dim = args.word_dim
            self.tag_dim = args.tag_dim
            self.dis_dim = 0
        elif agent_mode == 'arg':
            self.num_words = args.context_len
            self.emb_dim = args.word_dim
            self.dis_dim = args.dis_dim
            self.tag_dim = args.tag_dim
        self.contextual_embedding = args.contextual_embedding
        self.build_dqn()

    def build_dqn(self):

        fw = self.emb_dim   # filter width
        fn = self.num_filters  # filter num
        inputs = Input(shape=(self.num_words, self.emb_dim, 1)) # this is embedding now.
        tag_inputs = Input(shape=(self.num_words, self.tag_dim, 1))

        # distance convolutions
        if self.agent_mode == 'arg':
            dis_inputs = Input(shape=(self.num_words, self.dis_dim, 1))
            bi_d = Conv2D(fn, (2, self.dis_dim), padding='valid', kernel_initializer='glorot_normal')(dis_inputs)
            bi_d = Activation(activation='relu')(bi_d)
            bi_d = MaxPooling2D((self.num_words - 1, 1), strides=(1, 1), padding='valid')(bi_d)

            tri_d = Conv2D(fn, (3, self.dis_dim), padding='valid', kernel_initializer='glorot_normal')(dis_inputs)
            tri_d = Activation(activation='relu')(tri_d)
            tri_d = MaxPooling2D((self.num_words - 2, 1), strides=(1, 1), padding='valid')(tri_d)

            four_d = Conv2D(fn, (4, self.dis_dim), padding='valid', kernel_initializer='glorot_normal')(dis_inputs)
            four_d = Activation(activation='relu')(four_d)
            four_d = MaxPooling2D((self.num_words - 3, 1), strides=(1, 1), padding='valid')(four_d)

            five_d = Conv2D(fn, (5, self.dis_dim), padding='valid', kernel_initializer='glorot_normal')(dis_inputs)
            five_d = Activation(activation='relu')(five_d)
            five_d = MaxPooling2D((self.num_words - 4, 1), strides=(1, 1), padding='valid')(five_d)
            concat_d = kl.concatenate([bi_d, tri_d, four_d, five_d], axis=2)

        # embedding convolutions
        bi_gram = Conv2D(fn, (2, fw), padding='valid', kernel_initializer='glorot_normal')(inputs)
        # bi_gram = BatchNormalization()(bi_gram)
        bi_gram = Activation(activation='relu')(bi_gram)
        bi_gram = MaxPooling2D((self.num_words - 1, 1), strides=(1, 1), padding='valid')(bi_gram)

        tri_gram = Conv2D(fn, (3, fw), padding='valid', kernel_initializer='glorot_normal')(inputs)
        # tri_gram = BatchNormalization()(tri_gram)
        tri_gram = Activation(activation='relu')(tri_gram)
        tri_gram = MaxPooling2D((self.num_words - 2, 1), strides=(1, 1), padding='valid')(tri_gram)

        four_gram = Conv2D(fn, (4, fw), padding='valid', kernel_initializer='glorot_normal')(inputs)
        # four_gram = BatchNormalization()(four_gram)
        four_gram = Activation(activation='relu')(four_gram)
        four_gram = MaxPooling2D((self.num_words - 3, 1), strides=(1, 1), padding='valid')(four_gram)

        five_gram = Conv2D(fn, (5, fw), padding='valid', kernel_initializer='glorot_normal')(inputs)
        # five_gram = BatchNormalization()(five_gram)
        five_gram = Activation(activation='relu')(five_gram)
        five_gram = MaxPooling2D((self.num_words - 4, 1), strides=(1, 1), padding='valid')(five_gram)


        # tag convolutions
        bi_t = Conv2D(fn, (2, self.tag_dim), padding='valid', kernel_initializer='glorot_normal')(tag_inputs)
        bi_t = Activation(activation='relu')(bi_t)
        bi_t = MaxPooling2D((self.num_words - 1, 1), strides=(1, 1), padding='valid')(bi_t)

        tri_t = Conv2D(fn, (3, self.tag_dim), padding='valid', kernel_initializer='glorot_normal')(tag_inputs)
        tri_t = Activation(activation='relu')(tri_t)
        tri_t = MaxPooling2D((self.num_words - 2, 1), strides=(1, 1), padding='valid')(tri_t)

        four_t = Conv2D(fn, (4, self.tag_dim), padding='valid', kernel_initializer='glorot_normal')(tag_inputs)
        four_t = Activation(activation='relu')(four_t)
        four_t = MaxPooling2D((self.num_words - 3, 1), strides=(1, 1), padding='valid')(four_t)

        five_t = Conv2D(fn, (5, self.tag_dim), padding='valid', kernel_initializer='glorot_normal')(tag_inputs)
        five_t = Activation(activation='relu')(five_t)
        five_t = MaxPooling2D((self.num_words - 4, 1), strides=(1, 1), padding='valid')(five_t)

        concat_t = kl.concatenate([bi_t,tri_t,four_t, five_t], axis=2)



        # concates.shape = [None, 1, 8, 32]
        concat = kl.concatenate([bi_gram, tri_gram, four_gram, five_gram], axis=2)
        concat = kl.concatenate([concat, concat_t], axis=2, name="concat_act")
        if self.agent_mode =='arg':
            concat = kl.concatenate([concat, concat_d], axis=2, name="concat_arg")
        print(concat.shape)
        flat = Flatten()(concat)
        print(flat.shape)
        full_con = Dense(self.dense_dim, activation='relu', kernel_initializer='truncated_normal')(flat)
        out = Dense(self.num_actions, kernel_initializer='truncated_normal')(full_con)

        if self.agent_mode == 'act':
            self.model = Model([inputs, tag_inputs], out)
            self.target_model = Model([inputs, tag_inputs], out)

        if self.agent_mode == 'arg':
            self.model = Model([inputs, dis_inputs, tag_inputs], out)
            self.target_model = Model([inputs, dis_inputs, tag_inputs], out)
        self.compile_model()

    def compile_model(self):
        if self.optimizer == 'sgd':
            opt = keras.optimizers.SGD(lr=self.learning_rate, momentum=0.9, decay=0.9, nesterov=True)
        elif self.optimizer == 'adam':
            opt = keras.optimizers.Adam(lr=self.learning_rate, beta_1=0.9, beta_2=0.999, epsilon=1e-08)
        elif self.optimizer == 'nadam':
            opt = keras.optimizers.Nadam(lr=self.learning_rate, beta_1=0.9, beta_2=0.999, epsilon=1e-08,
                                         schedule_decay=0.004)
        elif self.optimizer == 'adadelta':
            opt = keras.optimizers.Adadelta(lr=self.learning_rate, rho=0.95, epsilon=1e-08, decay=0.0)
        else:
            opt = keras.optimizers.RMSprop(lr=self.learning_rate, rho=0.9, epsilon=1e-06)

        self.model.compile(optimizer=opt, loss='mse')
        self.target_model.compile(optimizer=opt, loss='mse')
        print(self.model.summary())

    def update_target_network(self):
        self.target_model.set_weights(self.model.get_weights())

    def train(self, minibatch):
        # expand components of minibatch
        prestates, actions, rewards, poststates, terminals = minibatch

        pre_tags = prestates[:, :, -1].astype('int32').reshape(self.batch_size, self.num_words, 1)
        repeat_pre_tags = np.repeat(pre_tags, self.tag_dim, axis=-1)
        prestates = np.concatenate([prestates[:, :, :-1], repeat_pre_tags], axis=2)

        post_tags = poststates[:, :, -1].astype('int32').reshape(self.batch_size, self.num_words, 1)
        repeat_post_tags = np.repeat(post_tags, self.tag_dim, axis=-1)
        poststates = np.concatenate([poststates[:, :, :-1], repeat_post_tags], axis=2)

        post_input = poststates[:, :, :,np.newaxis]  # np.reshape(poststates, [-1, self.num_words, self.emb_dim, 1])
        pre_input = prestates[:, :, :, np.newaxis]  # np.reshape(prestates, [-1, self.num_words, self.emb_dim, 1])


        # separate input streams
        if self.agent_mode == 'act':
            post_input = [post_input[:, :, :-1, :], post_input[:, :, -1, :].reshape(self.batch_size,self.num_words,self.tag_dim,1)]
            pre_input = [pre_input[:, :, :-1, :], pre_input[:, :, -1, :].reshape(self.batch_size,self.num_words,self.tag_dim,1)]
        elif self.agent_mode == 'arg':
            post_input = [post_input[:, :, :-2, :], post_input[:, :, -2, :].reshape(self.batch_size,self.num_words,self.dis_dim,1), post_input[:, :, -1, :].reshape(self.batch_size,self.num_words,self.tag_dim,1)]
            pre_input = [pre_input[:, :, :-2, :], pre_input[:, :, -2, :].reshape(self.batch_size,self.num_words,self.dis_dim,1), pre_input[:, :, -1, :].reshape(self.batch_size,self.num_words,self.tag_dim,1)]



        postq = self.target_model.predict_on_batch(post_input)
        targets = self.model.predict_on_batch(pre_input)
        # calculate max Q-value for each poststate
        maxpostq = np.max(postq, axis=1)

        # update Q-value targets for actions taken
        for i, action in enumerate(actions):
            if terminals[i]:
                targets[i, action] = float(rewards[i])
            else:
                targets[i, action] = float(rewards[i]) + self.gamma * maxpostq[i]

        return self.model.train_on_batch(pre_input, targets)

    def predict(self, current_state):

        # word_vec = current_state[:, :-2]
        # tags = current_state[:, -1].astype('int32').reshape(self.num_words, 1)
        # if self.agent_mode == 'arg':
        #     dis = current_state[:, -2].astype('int32').reshape(self.num_words, 1)
        # # tags = np.repeat(tags, self.tag_dim, axis=-1)
        #
        # expand_state = np.concatenate([word_vec, tags], axis=1)

        # if self.data_format == 'channels_last':
        # state_input = expand_state[np.newaxis, :, :, np.newaxis]

        state_input = current_state[np.newaxis, :, :, np.newaxis]
        # else:
        #     state_input = expand_state[np.newaxis, np.newaxis, :, :]
        if self.agent_mode == 'act':
            qvalues = self.model.predict_on_batch([state_input[:, :, :-1, :], state_input[:, :, -1, :].reshape(1,self.num_words,self.tag_dim,1)])
        elif self.agent_mode == 'arg':
            qvalues = self.model.predict_on_batch([state_input[:, :, :-2, :], state_input[:, :, -2, :].reshape(1, self.num_words, self.dis_dim, 1), state_input[:, :, -1, :].reshape(1, self.num_words,self.tag_dim,1)])
        return qvalues

    def save_weights(self, weight_dir):
        self.model.save_weights(weight_dir)
        print('Saved weights to %s ...' % weight_dir)

    def load_weights(self, weight_dir):
        self.model.load_weights(weight_dir)
        print('Loaded weights from %s ...' % weight_dir)

