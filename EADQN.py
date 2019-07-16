import keras
import keras.layers as kl
from keras.layers import *
from keras.models import Model
import tensorflow as tf
tf.compat.v1.set_random_seed(0)
import time


class DeepQLearner:
    def __init__(self, args, agent_mode, data_format):

        print('Initializing the DQN...')
        self.word_dim = args.word_dim #50 word2vec
        self.tag_dim = args.tag_dim #repeat representation of RL action
        self.dropout = args.dropout #0.5
        self.optimizer = args.optimizer #adam
        self.dense_dim = args.dense_dim #256
        self.batch_size = args.batch_size #32
        self.gamma = args.gamma #discount rate
        self.learning_rate = args.learning_rate #0.001
        self.num_actions = args.num_actions #2
        self.num_filters = args.num_filters #32
        self.data_format = data_format #channels_last
        if agent_mode == 'act':
            self.num_words = args.num_words #500
            self.emb_dim = args.word_dim + args.tag_dim #Embedding dim = 100
            self.NAME = "action_DQN-{}".format(int(time.time()))
        elif agent_mode == 'arg':
            self.num_words = args.context_len #100
            self.emb_dim = args.word_dim + args.dis_dim + args.tag_dim #Embedding dim = 150

        # filter_width = self.emb_dim - 1  # filter width = 99 or 149 Why??
        filter_width = self.emb_dim
        n_filters = self.num_filters  # filter num = 32

        input = Input(shape=(self.num_words, self.emb_dim, 1))

        bi_gram = Conv2D(n_filters, (2, filter_width), activation='relu', kernel_initializer='glorot_normal')(input) #xavier_normal initializer = draws sample from truncated normal distribution centered on 0 with std dev
        # bi_gram = BatchNormalization()(bi_gram)
        bi_gram = MaxPooling2D((self.num_words - 1, 1), strides=(1, 1), padding='valid')(bi_gram)

        tri_gram = Conv2D(n_filters, (3, filter_width), activation='relu', kernel_initializer='glorot_normal')(input)
        # tri_gram = BatchNormalization()(tri_gram)
        tri_gram = MaxPooling2D((self.num_words - 2, 1), strides=(1, 1), padding='valid')(tri_gram)

        four_gram = Conv2D(n_filters, (4, filter_width), activation='relu', kernel_initializer='glorot_normal')(input)
        # four_gram = BatchNormalization()(four_gram)
        four_gram = MaxPooling2D((self.num_words - 3, 1), strides=(1, 1), padding='valid')(four_gram)

        five_gram = Conv2D(n_filters, (5, filter_width), activation='relu', kernel_initializer='glorot_normal')(input)
        # five_gram = BatchNormalization()(five_gram)
        five_gram = MaxPooling2D((self.num_words - 4, 1), strides=(1, 1), padding='valid')(five_gram)

        # concatenate and flatten
        flat = Flatten()(kl.concatenate([bi_gram, tri_gram, four_gram, five_gram], axis=2))

        fc = Dense(self.dense_dim, activation='relu', kernel_initializer='truncated_normal')(flat) # values more than two standard deviations from the mean are discarded and redrawn.
        output = Dense(self.num_actions, kernel_initializer='truncated_normal')(fc)

        self.model = Model(input, output)
        self.target_model = Model(input, output)


        #tensorboard
        # tensorboard = TensorBoard(log_dir="logs/{}".format(self.NAME))


        #compile the model
        opt = keras.optimizers.Adam(lr=self.learning_rate, beta_1=0.9, beta_2=0.999, epsilon=1e-08)


        self.model.compile(optimizer=opt, loss='mse')
        self.target_model.compile(optimizer=opt, loss='mse')
        print(self.model.summary())

    def update_target_network(self):
        self.target_model.set_weights(self.model.get_weights())

    def train(self, minibatch):
        # expand components of minibatchls

        prestates, actions, rewards, poststates, terminals = minibatch
        pre_tags = prestates[:, :, -1].astype('int32').reshape(self.batch_size, self.num_words,1)
        repeat_pre_tags = np.repeat(pre_tags, self.tag_dim, axis=-1)
        prestates = np.concatenate([prestates[:,:,:-1], repeat_pre_tags], axis=2)

        post_tags = poststates[:, :, -1].astype('int32').reshape(self.batch_size, self.num_words, 1)
        repeat_post_tags = np.repeat(post_tags, self.tag_dim, axis=-1)
        poststates = np.concatenate([poststates[:, :, :-1], repeat_post_tags], axis = 2)

        #channels_last
        post_input = poststates[:, :, :, np.newaxis]  # np.reshape(poststates, [-1, self.num_words, self.emb_dim, 1])
        pre_input = prestates[:, :, :, np.newaxis]  # np.reshape(prestates, [-1, self.num_words, self.emb_dim, 1])

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
        word_vec = current_state[:, :-1]
        tags = current_state[:, -1].astype('int32').reshape(self.num_words, 1)
        tags = np.repeat(tags, self.tag_dim, axis=-1)

        expand_state = np.concatenate([word_vec, tags], axis=1)
        if self.data_format == 'channels_last':
            current_state = expand_state[np.newaxis, :, :, np.newaxis]
        else:
            current_state = expand_state[np.newaxis, np.newaxis, :, :]
        qvalues = self.model.predict(current_state)
        return qvalues

    def save_weights(self, weight_dir):
        self.model.save_weights(weight_dir)
        print('Saved weights to %s ...' % weight_dir)

    def load_weights(self, weight_dir):
        self.model.load_weights(weight_dir, by_name=True)
        print('Loaded weights from %s ...' % weight_dir)
