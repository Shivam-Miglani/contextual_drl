# coding:utf-8
import pickle
import numpy as np
import os


class ReplayMemory:
    def __init__(self, args, agent_mode):
        print('Initializing ReplayMemory...')
        self.size = args.replay_size
        if agent_mode == 'act':
            self.word_dim = args.word_dim
            self.num_words = args.num_words #500
        elif agent_mode == 'arg':
            self.word_dim = args.word_dim + args.dis_dim #100
            self.num_words = 128 #100

        self.actions = np.zeros(self.size, dtype=np.uint8) #replay size = 50000
        self.rewards = np.zeros(self.size, dtype=np.float16)
        self.states = np.zeros([self.size, self.num_words, self.word_dim + 1], dtype=np.float16) #50000,500/100,51/101 (1 is for storing tag_index)
        self.terminals = np.zeros(self.size, dtype=np.bool)
        self.priority = args.priority #priority = 1 by default
        self.positive_rate = args.positive_rate #0.9
        self.batch_size = args.batch_size #32
        self.count = 0 #amount of memory filled
        self.current = 0 #current index which is being filled

        if args.load_replay: #0 by default
            self.load(args.save_replay_name) #save_replay_name = 'data/saved_replay_memory.pkl'

    def reset(self):
        print('Reset the replay memory')
        self.actions *= 0
        self.rewards *= 0.0
        self.states *= 0.0
        self.terminals *= False
        self.count = 0
        self.current = 0

    def add(self, action, reward, state, terminal):
        #add info in memory
        self.actions[self.current] = action #self.current starts from zero and fills the whole buffer before going 0 again.
        self.rewards[self.current] = reward
        self.states[self.current] = state
        self.terminals[self.current] = terminal
        self.count = max(self.count, self.current + 1)
        self.current = (self.current + 1) % self.size

    def getMinibatch(self):
        """
        Memory must include poststate, prestate and history
        Sample random indexes or with priority
        """
        prestates = np.zeros([self.batch_size, self.num_words, self.word_dim + 1]) #32, 500, 51 or 32,100,101
        poststates = np.zeros([self.batch_size, self.num_words, self.word_dim + 1]) #32, 500, 51 or 32,100,101
        pos_amount=-1 # I added this
        if self.priority:
            pos_amount = int(self.positive_rate * self.batch_size) #0.9*32= 28 #positive amount of samples needed!

        indexes = [] #list of randomly chosen indexes.
        count_pos = 0 #count of positive samples in a minibatch
        count_neg = 0 #count of negative samples in a minibatch
        count_circle = 0
        max_circles = 10 * self.batch_size  # max times for choosing positive samples or nagative samples = 320
        while len(indexes) < self.batch_size:
            # find random index
            while True:
                # sample one index (ignore states wraping over)
                index = np.random.randint(1, self.count - 1) #self.count tells amount of memory filled
                # NB! poststate (last state) can be terminal state!
                if self.terminals[index - 1]: #if previous state's terminals is true?
                    continue
                # use prioritized replay trick
                if self.priority:
                    if count_circle < max_circles:
                        # if num_pos is already enough but current ind is also positive sample, continue
                        if (count_pos >= pos_amount) and (self.rewards[index] > 0):
                            count_circle += 1
                            continue
                        # elif num_neg is already enough but current ind is also negative sample, continue
                        elif (count_neg >= self.batch_size - pos_amount) and (self.rewards[index] < 0):
                            count_circle += 1
                            continue
                    if self.rewards[index] > 0:
                        count_pos += 1
                    else:
                        count_neg += 1
                break

            prestates[len(indexes)] = self.states[index - 1] #prestate[0-31] = self.states[index-1] (state before index) 500,51
            indexes.append(index)
        # copy actions, rewards and terminals with direct slicing
        actions = self.actions[indexes]
        rewards = self.rewards[indexes]
        terminals = self.terminals[indexes]
        poststates = self.states[indexes] #states now. 500,51
        return prestates, actions, rewards, poststates, terminals

    def save(self, fname, size):
        if size > self.size:
            size = self.size
        databag = {}
        databag['actions'] = self.actions[: size]
        databag['rewards'] = self.rewards[: size]
        databag['states'] = self.states[: size]
        databag['terminals'] = self.terminals[: size]
        with open(fname, 'wb') as f:
            print('Try to save replay memory ...')
            pickle.dump(databag, f)
            print('Replay memory is successfully saved as %s' % fname)

    def load(self, fname):
        if not os.path.exists(fname):
            print("%s doesn't exist!" % fname)
            return
        with open(fname, 'rb') as f:
            print('Loading replay memory from %s ...' % fname)
            databag = pickle.load(f)
            size = len(databag['states'])
            self.states[: size] = databag['states']
            self.actions[: size] = databag['actions']
            self.rewards[: size] = databag['rewards']
            self.terminals[: size] = databag['terminals']
            self.count = size
            self.current = size