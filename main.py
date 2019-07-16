# coding:utf-8
import time
import argparse
import tensorflow as tf
tf.compat.v1.set_random_seed(0)
from utils import get_time, plot_results
from Agent import Agent
from EADQN import DeepQLearner
from Environment import Environment
from ReplayMemory import ReplayMemory
from gensim.models import KeyedVectors
from tqdm import tqdm
from keras.backend import set_image_data_format
from keras.backend.tensorflow_backend import set_session
from flair.embeddings import WordEmbeddings, FlairEmbeddings, StackedEmbeddings, ELMoEmbeddings, BertEmbeddings, BPEmb, CharacterEmbeddings


def preset_args():
    parser = argparse.ArgumentParser()

    envarg = parser.add_argument_group('Environment')
    envarg.add_argument("--domain", type=str, default='cooking', help="")
    envarg.add_argument("--contextual_embedding", type=str, default='elmo', help="")
    envarg.add_argument("--model_dim", type=str, default=50, help="word2vec dimension")  # word2vec 50.
    envarg.add_argument("--num_words", type=int, default=512, help="number of words to consider for act model is 512. Arg model is 128") # 100 if arguments.
    envarg.add_argument("--word_dim", type=int, default=868, help="dim of word embedding")
    envarg.add_argument("--tag_dim", type=int, default=868, help="")
    envarg.add_argument("--dis_dim", type=int, default=868, help="")
    envarg.add_argument("--reward_assign", type=list, default=[1, 2, 3], help='')
    envarg.add_argument("--reward_base", type=float, default=50.0, help="")
    envarg.add_argument("--object_rate", type=float, default=0.07, help='')
    envarg.add_argument("--action_rate", type=float, default=0.10, help="")
    envarg.add_argument("--use_act_rate", type=int, default=1, help='')

    memarg = parser.add_argument_group('Replay memory')
    memarg.add_argument("--positive_rate", type=float, default=0.9, help="")
    memarg.add_argument("--priority", type=int, default=1, help="")
    memarg.add_argument("--save_replay", type=int, default=0, help="")
    memarg.add_argument("--load_replay", type=int, default=0, help="")
    memarg.add_argument("--replay_size", type=int, default=50000, help="")
    memarg.add_argument("--save_replay_size", type=int, default=1000, help="")
    memarg.add_argument("--save_replay_name", type=str, default='data/saved_replay_memory.pkl', help="")

    netarg = parser.add_argument_group('Deep Q-learning network')
    netarg.add_argument("--batch_size", type=int, default=32, help="")
    netarg.add_argument("--num_filters", type=int, default=32, help="")
    netarg.add_argument("--dense_dim", type=int, default=256, help="")
    netarg.add_argument("--num_actions", type=int, default=2, help="")
    netarg.add_argument("--optimizer", type=str, default='adam', help="")
    netarg.add_argument("--learning_rate", type=float, default=0.001, help="")
    netarg.add_argument("--dropout", type=float, default=0.5, help="")
    netarg.add_argument("--gamma", type=float, default=0.9, help="")

    antarg = parser.add_argument_group('Agent')
    antarg.add_argument("--exploration_rate_start", type=float, default=1, help="")
    antarg.add_argument("--exploration_rate_end", type=float, default=0.1, help="")
    antarg.add_argument("--exploration_rate_test", type=float, default=0.0, help="")
    antarg.add_argument("--exploration_decay_steps", type=int, default=1000, help="")
    antarg.add_argument("--train_frequency", type=int, default=1, help="")
    antarg.add_argument("--train_repeat", type=int, default=1, help="")
    antarg.add_argument("--target_steps", type=int, default=5, help="")
    antarg.add_argument("--random_play", type=int, default=0, help="")
    antarg.add_argument("--display_training_result", type=int, default=1, help='')
    antarg.add_argument("--filter_act_ind", type=int, default=1, help='')

    mainarg = parser.add_argument_group('Main loop')
    mainarg.add_argument("--gui_mode", type=bool, default=False, help='')
    mainarg.add_argument("--epochs", type=int, default=1, help="")
    mainarg.add_argument("--start_epoch", type=int, default=0, help="")
    mainarg.add_argument("--stop_epoch_gap", type=int, default=5, help="")
    mainarg.add_argument("--train_episodes", type=int, default=50, help="")
    mainarg.add_argument("--load_weights", type=bool, default=False, help="")
    mainarg.add_argument("--save_weights", type=bool, default=True, help="")
    mainarg.add_argument("--agent_mode", type=str, default='act', help='action dqn or argument dqn')


    return parser.parse_args()

def args_init(args):
    # initialize word2vec
    args.word2vec = KeyedVectors.load_word2vec_format('data/mymodel-new-5-%d' % args.model_dim, binary=True)

    # initialize contextual embedding dimensions
    if args.contextual_embedding == 'word2vec': #TODO: need code changes to make this work. For now use Feng's EASDRL for word2vec results.
        args.word_dim = args.tag_dim = args.dis_dim = 50
    elif args.contextual_embedding == 'elmo': #glove + elmo
        args.word_dim = args.tag_dim = args.dis_dim = 868
        ## stacked embeddings
        # create a StackedEmbedding object that combines glove and forward/backward flair embeddings
        args.stacked_embeddings = StackedEmbeddings([
            WordEmbeddings('glove'),
            ELMoEmbeddings('small')
        ])

    elif args.contextual_embedding == 'bert': #glove + bert
        args.word_dim = args.tag_dim = args.dis_dim = 3172
        args.stacked_embeddings = StackedEmbeddings([
            WordEmbeddings('glove'),
            BertEmbeddings('bert-base-uncased')
        ])
        args.batch_size = 8

    elif args.contextual_embedding == 'flair': #glove + flair-forward + flair-backward
        args.word_dim = args.tag_dim = args.dis_dim = 4196
        args.stacked_embeddings = StackedEmbeddings([
            WordEmbeddings('glove'),
            FlairEmbeddings('news-forward', chars_per_chunk=128),
            FlairEmbeddings('news-backward', chars_per_chunk=128)
        ])
        args.batch_size = 8

    elif args.contextual_embedding == 'glove': # not tested
        args.word_dim = args.tag_dim = args.dis_dim = 100
        args.stacked_embeddings = StackedEmbeddings([
            WordEmbeddings('glove'),
        ])

    # weights loaded, set exploration rate to minimum
    if args.load_weights:  # 1 to 0.1. decayed to minimum.
        args.exploration_rate_start = args.exploration_rate_end

    # agent mode arguments, set number of words to 100
    if args.agent_mode == 'arg':
        args.num_words = 128

    args.result_dir = 'results/%s_%s_%s' % (args.domain, args.agent_mode, args.contextual_embedding)

    return args

def main(args):
    print('Current time is: %s' % get_time())
    print('Starting at main...')
    result = {'rec': [], 'pre': [], 'f1': [], 'rw': []}

    start = time.time()

    config = tf.compat.v1.ConfigProto()
    config.gpu_options.allow_growth = True
    set_session(tf.Session(config=config)) # global Keras session

    env_act = Environment(args, args.agent_mode)
    net_act = DeepQLearner(args, args.agent_mode, 'channels_last')
    mem_act = ReplayMemory(args, args.agent_mode)
    agent = Agent(env_act, mem_act, net_act, args)  # agent takes in environment, memory, model and agent_mode

    # loop over epochs
    epoch_result = {'rec': [0.0], 'pre': [0.0], 'f1': [0.0], 'rw': [0.0]}
    training_result = {'rec': [], 'pre': [], 'f1': [], 'loss': [], 'rw': []}
    test_result = {'rec': [], 'pre': [], 'f1': [], 'loss': [], 'rw': []}
    log_epoch = 0
    with open("%s.txt" % (args.result_dir), 'w') as outfile:
        print('\n Arguments:')
        outfile.write('\n Arguments:\n')
        for k, v in sorted(args.__dict__.items(), key=lambda x: x[0]):
            print('{}: {}'.format(k, v))
            outfile.write('{}: {}\n'.format(k, v))
        print('\n')
        outfile.write('\n')

        # if we are loading weights, we don't need to train [no exploration is required. We have exploration rate start = end = 0.1], just test on test set.
        if args.load_weights:
            print('Loading weights ...')
            filename = 'weights/%s_%s_%s.h5' % (args.domain, args.agent_mode, args.contextual_embedding)
            net_act.load_weights(filename)
            #accuracy on test set
            with open("%s.txt" % (args.result_dir + 'testset'), 'w') as outfile:
                rec, pre, f1, rw = agent.test(args.test_steps, outfile)
                outfile.write('\n\n Test f1 value: {}, recall : {}, precision : {}, reward: {} \n'.format(f1, rec,pre,rw ))
                print('\n\n Test f1 value: {}, recall : {}, precision : {}, reward: {} \n'.format(f1, rec,pre,rw ))

        # do training
        if not args.load_weights:
            for epoch in tqdm(range(args.start_epoch, args.start_epoch + args.epochs)):
                num_test = -1
                env_act.train_epoch_end_flag = False
                while not env_act.train_epoch_end_flag: #unless all documents are covered
                    # training
                    num_test += 1
                    restart_init = False if num_test > 0 else True
                    tmp_result = agent.train(args.train_steps, args.train_episodes, restart_init) #Train episodes = 50 , max episodes.
                    for k in training_result:
                        training_result[k].extend(tmp_result[k])

                    rec, pre, f1, rw = agent.test(args.valid_steps, outfile) # not testing; actually validation

                    if f1 > max(epoch_result['f1']):
                        if args.save_weights:
                            filename = 'weights/%s_%s_%s.h5' % (args.domain, args.agent_mode, args.contextual_embedding)
                            net_act.save_weights(filename)

                        epoch_result['f1'].append(f1)
                        epoch_result['rec'].append(rec)
                        epoch_result['pre'].append(pre)
                        epoch_result['rw'].append(rw)
                        log_epoch = epoch
                        outfile.write('\n\n Best f1 value: {}  best epoch: {}\n'.format(epoch_result, log_epoch))
                        print('\n\n Best f1 value: {}  best epoch: {}\n'.format(epoch_result, log_epoch))

                # if no improvement after args.stop_epoch_gap, break
                # EARLY STOPPING
                if epoch - log_epoch >= args.stop_epoch_gap:
                    outfile.write('\n\nBest f1 value: {}  best epoch: {}\n'.format(epoch_result, log_epoch))
                    print('\nepoch: %d  result_dir: %s' % (epoch, args.result_dir))
                    print('-----Early stopping, no improvement after %d epochs-----\n' % args.stop_epoch_gap)
                    break

            # if args.save_replay: #0 by default
            #     mem_act.save(args.save_replay_name, args.save_replay_size)

            filename = '%s_training_process.pdf' % (args.result_dir)
            plot_results(epoch_result, args.domain, filename)
            outfile.write('\n\n training process:\n{}\n\n'.format(epoch_result))

            best_ind = epoch_result['f1'].index(max(epoch_result['f1']))
            for k in epoch_result:
                result[k].append(epoch_result[k][best_ind])
                outfile.write('{}: {}\n'.format(k, result[k]))
                print(('{}: {}\n'.format(k, result[k])))
            avg_f1 = sum(result['f1']) / len(result['f1'])
            avg_rw = sum(result['rw']) / len(result['rw'])
            outfile.write('\nAvg f1: {}  Avg reward: {}\n'.format(avg_f1, avg_rw))
            print('\nAvg f1: {}  Avg reward: {}\n'.format(avg_f1, avg_rw))

            tf.compat.v1.reset_default_graph()
        end = time.time()
        print('Total time cost: %ds' % (end - start))
        print('Current time is: %s\n' % get_time())

if __name__ == '__main__':
    args = args_init(preset_args())
    set_image_data_format('channels_last')
    main(args)

