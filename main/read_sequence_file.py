from collections import defaultdict

#TODO: read file names for input and output from command line arguments
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
        actarg_tuple = []
        actions = []
        arguments = []
        sequence = []
        if line and not line.isspace() and len(line)>1:
            sequence = line.rstrip("\n\r").lstrip("\n\r").lower()
            action_defs = sequence.split("),")
            for action_def in action_defs:
                action = action_def.split('(')[0].strip(")\n\r").strip()
                argument = action_def.split('(')[1].strip(")\n\r")
                actions.append(action.strip())
                argument_list = argument.split(',')
                argument_list = [x.strip() for x in argument_list]
                arguments.append(argument_list)

            actarg_tuple = zip(actions, arguments)
            sequences.append(list(actarg_tuple))

    # print(sequences)
    return sequences

def get_actarg_dictionary(sequences):
    d = defaultdict(list)
    for seq in sequences:
        for actarg_tuple in seq:
            d[actarg_tuple[0]].append(actarg_tuple[1])
    # for k,v in d.items():
    #     print("{} - {}".format(k,v))
    return d
