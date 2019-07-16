# coding:utf-8
import os
import time
import pickle
import numpy as np
import matplotlib.pyplot as plt

plt.switch_backend('agg')  # do not require GUI


def str2bool(v):
    return v.lower() in ("yes", "true", "t", "1")


def plot_results(results, domain, filename):
    print('\nSave results to %s' % filename)
    fontsize = 20
    if isinstance(results, list):
        plt.figure()
        plt.plot(range(len(results)), results, label='loss')
        plt.title('domain: %s' % domain)
        plt.xlabel('episodes', fontsize=fontsize)
        plt.legend(loc='best', fontsize=fontsize)
        plt.xticks(fontsize=fontsize)
        plt.yticks(fontsize=fontsize)
        plt.savefig(filename, format='pdf')
        print('Success\n')

    else:
        plt.figure(figsize=(16, 20))  # , dpi=300
        plt.subplot(311)
        x = range(len(results['rec']))
        plt.plot(x, results['rec'], label='rec')
        plt.plot(x, results['pre'], label='pre')
        plt.plot(x, results['f1'], label='f1')
        plt.title('domain: %s' % domain, fontsize=fontsize)
        plt.xlabel('episodes', fontsize=fontsize)
        plt.legend(loc='best', fontsize=fontsize)
        plt.xticks(fontsize=fontsize)
        plt.yticks(fontsize=fontsize)

        plt.subplot(312)
        plt.plot(range(len(results['rw'])), results['rw'], label='reward')
        plt.xlabel('episodes', fontsize=fontsize)
        plt.legend(loc='best', fontsize=fontsize)
        plt.xticks(fontsize=fontsize)
        plt.yticks(fontsize=fontsize)

        if 'loss' in results:
            plt.subplot(313)
            plt.plot(range(len(results['loss'])), results['loss'], label='loss')
            plt.xlabel('episodes', fontsize=fontsize)
            plt.legend(loc='best', fontsize=fontsize)
            plt.xticks(fontsize=fontsize)
            plt.yticks(fontsize=fontsize)

        plt.subplots_adjust(wspace=0.5, hspace=0.5)
        plt.savefig(filename, format='pdf')
        print('Success\n')


def ten_fold_split_ind(num_data, fname, k, random=True):
    """
    Split data for 10-fold-cross-validation
    Split randomly or sequentially
    Return the indices of split data
    """
    print('Getting tenfold indices ...')
    if os.path.exists(fname):
        with open(fname, 'rb') as f:
            print('Loading tenfold indices from %s\n' % fname)
            indices = pickle.load(f, encoding='bytes')
            return indices
    n = num_data / k
    indices = []

    if random:
        tmp_inds = np.arange(num_data)
        np.random.shuffle(tmp_inds)
        for i in range(k):
            if i == k - 1:
                indices.append(tmp_inds[i * n:])
            else:
                indices.append(tmp_inds[i * n: (i + 1) * n])
    else:
        for i in range(k):
            indices.append(range(i * n, (i + 1) * n))

    with open(fname, 'wb') as f:
        pickle.dump(indices, f)
    return indices


# takes in indices and returns all the folds. Each fold contains training and validation data.
def index2data(indices, data):
    print('Spliting data according to indices ...')
    folds = {'train': [], 'valid': []}
    if type(data) == dict:
        keys = data.keys()
        print('data.keys: {}'.format(keys))
        num_data = len(data[keys[0]])
        for i in range(len(indices)):
            valid_data = {}
            train_data = {}
            for k in keys:
                valid_data[k] = []
                train_data[k] = []
            for ind in range(num_data):
                for k in keys:
                    if ind in indices[i]:
                        valid_data[k].append(data[k][ind])
                    else:
                        train_data[k].append(data[k][ind])
            folds['train'].append(train_data)
            folds['valid'].append(valid_data)
    else:
        num_data = len(data)
        for i in range(len(indices)):
            valid_data = []
            train_data = []
            for ind in range(num_data):
                if ind in indices[i]:
                    valid_data.append(data[ind])
                else:
                    train_data.append(data[ind])
            folds['train'].append(train_data)
            folds['valid'].append(valid_data)

    return folds


def timeit(f):
    def timed(*args, **kwargs):
        start_time = time.time()
        result = f(*args, **kwargs)
        end_time = time.time()

        print("   [-] %s : %2.5f sec" % (f.__name__, end_time - start_time))
        return result

    return timed


def get_time():
    return time.strftime("%Y-%m-%d_%H:%M:%S", time.gmtime())


def save_pkl(obj, path):
    with open(path, 'wb') as f:
        pickle.dump(obj, f)


def load_pkl(path):
    with open(path, 'rb') as f:
        obj = pickle.load(f, encoding='bytes')
        return obj
