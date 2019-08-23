import os
from collections import defaultdict

def read_file(file_path):
    '''

    :param file_path:
    :return: sequences object which contains list of plans and within each plan there is list of tuples of (action,list(arguments)).
    '''
    file = open(file_path, 'r')
    sequences = []
    actions = []
    arguments = []
    for line in file:
        sequence = line.rstrip("\n\r").lstrip("\n\r").lower()

        action_defs = sequence.split("),")
        for action_def in action_defs:
            action = action_def.split('(')[0].strip(" )\n\r")
            argument = action_def.split('(')[1].strip(" )\n\r")
            actions.append(action)
            argument_list = argument.split(', ')
            arguments.append(argument_list)

        actarg_tuple = zip(actions, arguments)
        sequences.append(list(actarg_tuple))

    # print(sequences)
    return sequences

def print_sequences(sequences):
    for seq in sequences:
        print(seq)

def class_formation(seq):
    d = defaultdict(list)

    for k, v in seq:
        if v not in d[k]:
            d[k].append(v)

    # for k,v in d.items():
    print(d)




def locm():
    pass



if __name__ == "__main__":
    sequences = read_file('../locm_data/tyre.txt')
    # print_sequences(sequences)

    #initialize transition set and objectstate set as empty
    transition_set = set()
    state_set = set()
    objects = set()



    #for a sequence fill up state and transition sets.
    # for sequence in sequences:
    #     for actarg_tuple in sequence:
    #         for j,arg in enumerate(actarg_tuple[1]):
    #             state_set.add('start('+ actarg_tuple[0] + "." + str(j))
    #             state_set.add('end('+ actarg_tuple[0] + "." + str(j))
    #             transition_set.add(actarg_tuple[0] + "." + str(j))

    class_formation(sequences[0])








