# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.4.2
#   kernelspec:
#     display_name: .contextual_drl
#     language: python
#     name: .contextual_drl
# ---

# # Input Preprocessing

# ## Give instructions of your domain in natural language. It could be a transcript, domain process manual or wikihow style instructions.

# +
# paste your input as unicode text here.

instructions = u'''CURIOSITY MARS MISSION TRANSCRIPT

The last stage of the launch vehicle gives the spacecraft a final push and spins it up for our eight-and-a-half month cruise to the red planet.

10 minutes before hitting the atmosphere the cruise stage separates and final preparations for entry begin.

Hitting the atmosphere at about 13000 miles per hour, the spacecraft begins to slow down. While slowing down, the spacecraft uses thrusters to help steer toward the landing target.

We throw off weights to rebalance the spacecraft, so that it’s lined for parachute deploy. After slowing to about Mach 2, or about 1000 miles per hour, we deploy the parachute to slow down even further.

Once we are below the speed of sound, the heat shield separates and the spacecraft looks for the ground with the landing radar.

Once we reach an altitude of about 1 mile, the spacecraft drops out of the back-shell at about 200 miles an hour. It then fires up the landing engine to slow it down even further.

Once we’ve descended to about 60 feet above the ground, and going only about 2 miles per hour, the rover separates from the descent stage. As the rover is lowered, the wheels deploy in preparation for landing.

Once the rover is safely on the ground, and touchdown has been detected, the descent stage cuts the rover loose. It flies away leaving Curiosity safe on the surface of Mars.

One of the first things Curiosity does after landing is to deploy the mast, which supports many cameras and instruments. Curiosity shoots a laser at an interesting target. This helps us quickly understand the kind and

composition of that target from a distance of up to 30 feet.

If the target is worth a closer look, the rover can drive up and inspect the target with instruments and tools at the end of its arm.

The drill on the arm allows us to grab some of that rock and deliver it to the laboratory instruments inside the body of the rover.

Those instruments can tell us even more about the mineral composition, getting us closer to understanding whether life could have existed on Mars.

Curiosity will be exploring the red planet for at least 2 years and there’s no telling what we will discover.
'''
# -

# remove empty lines from input instructions -- this is important for BERT which looks at previous and forward sentences.
valid_instructions = ''
lines = instructions.split("\n")
non_empty_lines = [line for line in lines if line.strip() != ""]
for line in non_empty_lines:
      valid_instructions += line + u"\n"
print(valid_instructions)

# ## Remove pronoun coreferences

# +
import spacy
import neuralcoref


nlp = spacy.load('en_core_web_sm')
neuralcoref.add_to_pipe(nlp)

doc1 = nlp(valid_instructions)
coref_resolved_instructions =  doc1._.coref_resolved

print(coref_resolved_instructions)
# -

# ## write the file into proper directory to be run by main script

fname = 'nasa_curiosity.txt'
main_file_name = 'main_ceasdrl.py'

# +
# replace input filename in the main file
import re

# Read in the file
with open(main_file_name, 'r') as file :
    filedata = file.read()

# Replace the target string
filedata = re.sub(r'input_filename = .*txt', "input_filename = '"+ fname, filedata)

# Write the file out again
with open(main_file_name, 'w') as file:
    file.write(filedata)

# +
# Writing the instructions file into directory
# Writing the file
text_file = open("./data/process_manuals/" + fname, "w")
text_file.write(coref_resolved_instructions)
text_file.close()

# Reading the file
text_file = open("./data/process_manuals/" + fname, "r")
print(text_file.read())
text_file.close()
# -


# # Extract action sequence by running c-EASDRL

# don't forget to switch the dataset between cooking and wikihow
# !python -W ignore main_ceasdrl.py

# # Learn the domain model in PDDL using iLOCM
#
# **interactive-LOCM**
# This code combines LOCM1 and LOCM2 algorithms and is last part of the pipeline that I use in my thesis to generate PDDL models from instructional texts.
#
# - Step 0: Preprocess: Lemmatize, Coref resolve, action override rename and replacing empty parameters.
# - Step 1: Find classes and make transition graphs.
# - Step 2: Get transistion sets from LOCM2 algorithm
# - Step 3: Create FSMs
# - Step 4: Perform Zero Analysis and add new FSM if necessary.
# - Step 5: Create and test hypothesis for state parameters
# - Step 6: Create and merge state parameters
# - Step 7: Remove parameter flaws
# - Step 8: Extract static preconditions
# - Step 9: Form action schemas

from collections import defaultdict
import itertools
import os
from tabulate import tabulate
from pprint import pprint
import matplotlib.pyplot as plt
# %matplotlib inline
import networkx as nx
import pandas as pd
pd.options.display.max_columns = 100
from IPython.display import display, Markdown
from ipycytoscape import *
import string

input_file_name = "locm_data/"+fname
domain_name = input_file_name.split('/')[-1].split('.')[0] #domain name is the name of the file

print(domain_name)


# ## Read input file

# +
def read_file(input_file_name):
    '''
    Read the input data and return list of action sequences.
    Each sequence is a list of action-argumentlist tuples.
    '''
    file = open(input_file_name, 'r')
    sequences = []
    for line in file:
        
        actions = []
        arguments = []
        if line and not line.isspace() and len(line)>1:
            sequence = line.rstrip("\n\r").lstrip("\n\r").lower() 
            action_defs = sequence.split("),")

            for action_def in action_defs:
                action = action_def.split('(')[0].strip(")\n\r").strip()
                argument = action_def.split('(')[1].strip(")\n\r")
                actions.append(action.translate(str.maketrans('', '', string.punctuation)))
                argument_list = argument.split(',')
                argument_list = [x.strip() for x in argument_list]
                #argument_list.insert(0,'zero')
                arguments.append(argument_list)
                
            
            actarg_tuples = zip(actions,arguments)
            sequences.append(list(actarg_tuples))
    return sequences

def print_sequences(sequences):
    for seq in sequences:
        for index,action in enumerate(seq):
            print(str(index) + ": " + str(action))
        print()


# -

sequences = read_file(input_file_name)
print_sequences(sequences)


print(len(sequences))

# ## Normalize action sequences by lemmatization of extracted actions and arguments

# +
# normalize the words by lemmatization
# ps = PorterStemmer()

import nltk
from nltk.stem import WordNetLemmatizer
wordnet_lemmatizer = WordNetLemmatizer()

new_sequences = []

for seq in sequences:
    acts = []
    arg_lists = []
    for index,action in enumerate(seq):
        act = wordnet_lemmatizer.lemmatize(action[0],pos='v')
        acts.append(act)
        arg_list = [wordnet_lemmatizer.lemmatize(arg, pos='n') for arg in action[1]]
        arg_lists.append(arg_list)
    act_arg_tups = zip(acts,arg_lists)
    new_sequences.append(list(act_arg_tups))


print_sequences(new_sequences)
sequences = new_sequences
# -

# ## Rename actions with same name but different arguments by appending a counter to them

# +
# since action always have one argument, consider '' as an implicit one argument. Not renaming such actions.
# renaming 1 or more clashing action prototypes 


all_tuples_in_all_seqs = []
for seq in sequences:
    for index,action in enumerate(seq):
        all_tuples_in_all_seqs.append((action[0],len(action[1])))
        
all_act_len_set = set(all_tuples_in_all_seqs) # set of all actions with their arglist lens


from collections import defaultdict
d = defaultdict(list)

for k, v in all_act_len_set:
    d[k].append(v) #dictionary of list of lens for each key

# keys with list len > 1 have clashing action names
clashing_action_tuples = []     
for k,v in d.items():
    if len(d[k]) > 1:
        for index,val in enumerate(d[k]):
            if index > 0:
                clashing_action_tuples.append((k,val,index))
                

# replace all clashing action tuples in original sequences


for clashing_tup in clashing_action_tuples:
    for i, seq in enumerate(sequences):
        for j, actarg_tup in enumerate(seq):
            if (clashing_tup[0] == actarg_tup[0]) and clashing_tup[1] == len(actarg_tup[1]):
                sequences[i][j] = (sequences[i][j][0]+str(clashing_tup[2]), sequences[i][j][1])
                

# replace all '' parameters with '#'
for i, seq in enumerate(sequences):
    for j, actarg_tup in enumerate(seq):
        sequences[i][j] = (sequences[i][j][0], ['#' if x=='' else x for x in sequences[i][j][1]])
# -

print_sequences(sequences)

# ## Step 1.1: Find classes 

# +
transitions = set() # A transition is denoted by action_name + argument position
arguments = set()
actions = set()
for seq in sequences:
    for actarg_tuple in seq:
        actions.add(actarg_tuple[0])
        for j, arg in enumerate(actarg_tuple[1]):
            transitions.add(actarg_tuple[0]+"."+str(j))
            arguments.add(arg)

print("\nActions")
print(actions)
# print("\nTransitions")
# print(transitions)
print("\nArguments/Objects")
print(arguments)


# -

def get_actarg_dictionary(sequences):
    d = defaultdict(list)
    for seq in sequences:
        for actarg_tuple in seq:
            d[actarg_tuple[0]].append(actarg_tuple[1])
    return d
d = get_actarg_dictionary(sequences)


# +
# class util functions.
def get_classes(d):
    # TODO incorporate word similarity in get classes.
    c = defaultdict(set)
    for k,v in d.items():
        for arg_list in v:
            for i,object in enumerate(arg_list):
                c[k,i].add(object)

    sets = c.values()
    classes = []
    # remove duplicate classes
    for s in sets:
        if s not in classes:
            classes.append(s)

    # now do pairwise intersections of all values. If intersection, combine them; then return the final sets.
    classes_copy = list(classes)
    while True:
        combinations = list(itertools.combinations(classes_copy,2))
        intersections_count = 0
        for combination in combinations:
            if combination[0].intersection(combination[1]):
                intersections_count +=1

                if combination[0] in classes_copy:
                    classes_copy.remove(combination[0])
                if combination[1] in classes_copy:
                    classes_copy.remove(combination[1])
                classes_copy.append(combination[0].union(combination[1]))

        if intersections_count==0:
            # print("no intersections left")
            break

    return classes_copy

# TODO: Can use better approach here. NER might help.
def get_class_names(classes):
    # Name the class to first object found ignoring the digits in it
    class_names = []
    for c in classes:
        for object in c:
#             object = ''.join([i for i in object if not i.isdigit()])
            class_names.append(object)
            break
    return class_names

def get_class_index(arg,classes):
    for class_index, c in enumerate(classes):
        if arg in c:
            return class_index #it is like breaking out of the loop
    print("Error:class index not found") #this statement is only executed if class index is not returned.


# +
classes = get_classes(d) #sorts of object
print("\nSorts/Classes")
print(classes)

class_names = get_class_names(classes)
print("\nExtracted class names")
print(class_names)
# -
# ## USER INPUT 1: Enter Correct Class names
# Editing the extracted class names to more readable object classes will make the final PDDL model more readable.

# +
############ (Optional) User Input ############
# Give user an option to change class names.
# class_names[0] = 'rocket'

#tyre
# class_names[0] = 'Jack'
# class_names[1] = 'Boot'
# class_names[2] = 'Wheel'
# class_names[3] = 'Hub'
# class_names[4] = 'Wrench'
# class_names[5] = 'Nut'

#driverlog
class_names[0] = 'Driver'
class_names[1] = 'Truck'
class_names[2] = 'Package'
class_names[3] = 'Location'

# #blocksworld
# class_names[0] = 'Block'
# class_names[1] = 'Gripper'


print("\nRenamed class names")
print(class_names)
# -


#  **Assumptions of LOCM2**
# - Each object of a same class undergoes similar kind of transition.
# - Objects of same class in a same action undergo similar kind of transition.

# +
# change transitions to be more meaningful by incorporating class_names.
full_transitions = set()
for seq in sequences:
    for actarg_tuple in seq:
        actions.add(actarg_tuple[0])
        for j, arg in enumerate(actarg_tuple[1]):
            full_transitions.add(actarg_tuple[0]+"."+class_names[get_class_index(arg,classes)]+'.'+str(j))
            arguments.add(arg)

print("\nActions")
print(actions)
print("\nTransitions")
print(full_transitions)
print("\nArguments/Objects")
print(arguments)
# -

print("\nNumber of Actions: {},\nNumber of unique transitions: {},\nNumber of unique objects (arguments): {},\nNumber of classes/sorts: {}".format(len(actions), len(transitions), len(arguments), len(classes)))


# ## Building Transition graphs

# ### Utils

# +
def empty_directory(folder):
    for the_file in os.listdir(folder):
        file_path = os.path.join(folder, the_file)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
            # elif os.path.isdir(file_path): shutil.rmtree(file_path)
        except Exception as e:
            print(e)

def findsubsets(S,m):
    return set(itertools.combinations(S, m))

def print_table(matrix):
    display(tabulate(matrix, headers='keys', tablefmt='html'))
    
def printmd(string):
    display(Markdown(string))


# -
# ### Save graphs in graphml format (used in cytoscape)

def save(graphs, domain_name):
    adjacency_matrix_list = [] # list of adjacency matrices per class
    
    for index, G in enumerate(graphs):
        nx.write_graphml(G, "output/"+ domain_name + "/" +  class_names[index] + ".graphml")
        df = nx.to_pandas_adjacency(G, nodelist=G.nodes(), dtype=int)
        adjacency_matrix_list.append(df)
#         print_table(df)
    return adjacency_matrix_list


def plot_cytographs(graphs, domain_name, aml):
    cytoscapeobs = []
    for index, G in enumerate(graphs):
            cytoscapeobj = CytoscapeWidget()
            cytoscapeobj.graph.add_graph_from_networkx(G)
            edge_list = list()
            for source, target, data in G.edges(data=True):
                edge_instance = Edge()
                edge_instance.data['source'] = source
                edge_instance.data['target'] = target
                for k, v in data.items():
                    cyto_attrs = ['group', 'removed', 'selected', 'selectable',
                        'locked', 'grabbed', 'grabbable', 'classes', 'position', 'data']
                    if k in cyto_attrs:
                        setattr(edge_instance, k, v)
                    else:
                        edge_instance.data[k] = v
                    edge_list.append(edge_instance)
            cytoscapeobj.graph.edges = edge_list
#             cytoscapeobj.graph.add_graph_from_df(aml[index],aml[index].columns.tolist())
            cytoscapeobs.append(cytoscapeobj)
#             print(cytoscapeobj)
            printmd('## class **'+class_names[index]+'**')
            print_table(aml[index])
    #         print("Nodes:{}".format(G.nodes()))
    #         print("Edges:{}".format(G.edges()))
            cytoscapeobj.set_style([{
                            'width':400,
                            'height':400,

                            'selector': 'node',
                            'style': {
                                'label': 'data(id)',
                                'font-family': 'helvetica',
                                'font-size': '8px',
                                'background-color': '#11479e',
                                'height':'10px',
                                'width':'10px',


                                }

                            },
                            {
                            'selector': 'node:parent',
                            'css': {
                                'background-opacity': 0.333,
                                'background-color': '#bbb'
                                }
                            },
                            {
                            'selector': '$node > node',
                            'css': {
                                'padding-top': '10px',
                                'padding-left': '10px',
                                'padding-bottom': '10px',
                                'padding-right': '10px',
                                'text-valign': 'top',
                                'text-halign': 'center',
                                'background-color': '#bbb'
                              }
                            },
                           {
                                'selector': 'edge',

                                'style': {
                                    'label':'data(weight)',
                                    'width': 1,
                                    'line-color': '#9dbaea',
                                    'target-arrow-shape': 'triangle',
                                    'target-arrow-color': '#9dbaea',
                                    'arrow-scale': 0.5,
                                    'curve-style': 'bezier',
                                    'font-family': 'helvetica',
                                    'font-size': '8px',
                                    'text-valign': 'top',
                                    'text-halign':'center'
                                }
                            },
                            ])
            cytoscapeobj.max_zoom = 4.0
            cytoscapeobj.min_zoom = 0.5
            display(cytoscapeobj)
    return cytoscapeobs


# #### Build transitions graphs and call save function

def build_and_save_transition_graphs(classes, domain_name, class_names):
    # There should be a graph for each class of objects.
    graphs = []
    # Initialize all graphs empty
    for sort in classes:
        graphs.append(nx.DiGraph())

    consecutive_transition_lists = [] #list of consecutive transitions per object instance per sequence.

    for m, arg in enumerate(arguments):  # for all arguments (objects found in sequences)
        for n, seq in enumerate(sequences):  # for all sequences
            consecutive_transition_list = list()  # consecutive transition list for a sequence and an object (arg)
            for i, actarg_tuple in enumerate(seq):
                for j, arg_prime in enumerate(actarg_tuple[1]):  # for all arguments in actarg tuples
                    if arg == arg_prime:  # if argument matches arg
                        node = actarg_tuple[0] + "." +  str(j)
                        # node = actarg_tuple[0] +  "." + class_names[get_class_index(arg,classes)] + "." +  str(j)  # name the node of graph which represents a transition
                        consecutive_transition_list.append(node)  # add node to the cons_transition for sequence and argument

                        # for each class append the nodes to the graph of that class
                        class_index = get_class_index(arg_prime, classes)  # get index of class to which the object belongs to
                        graphs[class_index].add_node(node)  # add node to the graph of that class

            consecutive_transition_lists.append([n, arg, consecutive_transition_list])

    # print(consecutive_transition_lists)
    # for all consecutive transitions add edges to the appropriate graphs.
    for cons_trans_list in consecutive_transition_lists:
        # print(cons_trans_list)
        seq_no = cons_trans_list[0]  # get sequence number
        arg = cons_trans_list[1]  # get argument
        class_index = get_class_index(arg, classes)  # get index of class
        # add directed edges to graph of that class
        for i in range(0, len(cons_trans_list[2]) - 1):
                if graphs[class_index].has_edge(cons_trans_list[2][i], cons_trans_list[2][i + 1]):
                    graphs[class_index][cons_trans_list[2][i]][cons_trans_list[2][i + 1]]['weight'] += 1
                else:
                    graphs[class_index].add_edge(cons_trans_list[2][i], cons_trans_list[2][i + 1], weight=1)


    
    # make directory if doesn't exist
    dirName = "output/"+ domain_name
    if not os.path.exists(dirName):
        os.makedirs(dirName)
        print("Directory ", dirName, " Created ")
    else:
        print("Directory ", dirName, " already exists")
    empty_directory(dirName)
     
    # save all the graphs
    adjacency_matrix_list = save(graphs, domain_name) # list of adjacency matrices per class
    
    # plot cytoscape interactive graphs
    cytoscapeobs = plot_cytographs(graphs,domain_name, adjacency_matrix_list)
    
    return adjacency_matrix_list, graphs, cytoscapeobsdef build_and_save_transition_graphs(classes, domain_name, class_names):
    # There should be a graph for each class of objects.
    graphs = []
    # Initialize all graphs empty
    for sort in classes:
        graphs.append(nx.DiGraph())

    consecutive_transition_lists = [] #list of consecutive transitions per object instance per sequence.

    for m, arg in enumerate(arguments):  # for all arguments (objects found in sequences)
        for n, seq in enumerate(sequences):  # for all sequences
            consecutive_transition_list = list()  # consecutive transition list for a sequence and an object (arg)
            for i, actarg_tuple in enumerate(seq):
                for j, arg_prime in enumerate(actarg_tuple[1]):  # for all arguments in actarg tuples
                    if arg == arg_prime:  # if argument matches arg
                        node = actarg_tuple[0] + "." +  str(j)
                        # node = actarg_tuple[0] +  "." + class_names[get_class_index(arg,classes)] + "." +  str(j)  # name the node of graph which represents a transition
                        consecutive_transition_list.append(node)  # add node to the cons_transition for sequence and argument

                        # for each class append the nodes to the graph of that class
                        class_index = get_class_index(arg_prime, classes)  # get index of class to which the object belongs to
                        graphs[class_index].add_node(node)  # add node to the graph of that class

            consecutive_transition_lists.append([n, arg, consecutive_transition_list])

    # print(consecutive_transition_lists)
    # for all consecutive transitions add edges to the appropriate graphs.
    for cons_trans_list in consecutive_transition_lists:
        # print(cons_trans_list)
        seq_no = cons_trans_list[0]  # get sequence number
        arg = cons_trans_list[1]  # get argument
        class_index = get_class_index(arg, classes)  # get index of class
        # add directed edges to graph of that class
        for i in range(0, len(cons_trans_list[2]) - 1):
                if graphs[class_index].has_edge(cons_trans_list[2][i], cons_trans_list[2][i + 1]):
                    graphs[class_index][cons_trans_list[2][i]][cons_trans_list[2][i + 1]]['weight'] += 1
                else:
                    graphs[class_index].add_edge(cons_trans_list[2][i], cons_trans_list[2][i + 1], weight=1)


    
    # make directory if doesn't exist
    dirName = "output/"+ domain_name
    if not os.path.exists(dirName):
        os.makedirs(dirName)
        print("Directory ", dirName, " Created ")
    else:
        print("Directory ", dirName, " already exists")
    empty_directory(dirName)
     
    # save all the graphs
    adjacency_matrix_list = save(graphs, domain_name) # list of adjacency matrices per class
    
    # plot cytoscape interactive graphs
    cytoscapeobs = plot_cytographs(graphs,domain_name, adjacency_matrix_list)
    
    return adjacency_matrix_list, graphs, cytoscapeobs

# ##### Transition Graphs

#### Build weighted directed graphs for transitions.
printmd("## "+ domain_name.upper())
adjacency_matrix_list, graphs, cytoscapeobjs = build_and_save_transition_graphs(classes, domain_name, class_names)

# ## USER INPUT 2: Edit transition graphs
# For meaningful LOCM models, here one can edit the transition graphs to make them accurate. However, in the paper we don't do that in order to estimate what kind of models are learned automatically from natural language data.

# Option 1. **You can add or delete nodes/edges in transition graphs by following methods like add_node, delete_edges shown in the following library.**
# https://github.com/QuantStack/ipycytoscape/blob/master/ipycytoscape/cytoscape.py
#
# Option 2. **Alternatively you can use the saved .graphml file. Open it up in Cytoscape, edit it within the GUI and load that graph into the graphs list.**

# ## Step 2: Get Transition Sets from LOCM2
#
# **Algorithm**: LOCM2
#
# **Input** : 
# - T_all = set of observed transitions for a sort/class
# - H : Set of holes - each hole is a set of two transitions.
# - P : Set of pairs <t1,t2> i.e. consecutive transitions.
# - E : Set of example sequences of actions.
#
# **Output**:
# - S : Set of transition sets.
# ### Finding holes
# Holes are transitions that LOCM1 will assume to be true due to the flaw of overgeneralizing

# +
adjacency_matrix_list_with_holes = get_adjacency_matrix_with_holes(adjacency_matrix_list)

# Printing FSM matrices with and without holes
for index,adjacency_matrix in enumerate(adjacency_matrix_list):
    printmd("\n#### " + class_names[index] )
    print_table(adjacency_matrix)

    printmd("\n#### HOLES: " + class_names[index])
    print_table(adjacency_matrix_list_with_holes[index])

# +
adjacency_matrix_list_with_holes = get_adjacency_matrix_with_holes(adjacency_matrix_list)

# Printing FSM matrices with and without holes
for index,adjacency_matrix in enumerate(adjacency_matrix_list):
    print("\n==========" + class_names[index] + "==========")
    print(adjacency_matrix)
    print(tabulate(adjacency_matrix, headers='keys', tablefmt='github'))

    print("\n===== HOLES: " + class_names[index] + "==========")
    print(tabulate(adjacency_matrix_list_with_holes[index], headers='keys', tablefmt='github'))


# +
# Create list of set of holes per class (H)
holes_per_class = []

for index,df in enumerate(adjacency_matrix_list_with_holes):
    holes = set()
    for i in range(df.shape[0]):
        for j in range(df.shape[1]):
            if df.iloc[i,j] == 'hole':
                holes.add(frozenset({df.index[i] , df.columns[j]}))
    holes_per_class.append(holes)
for i, hole in enumerate(holes_per_class):
    print("#holes in class " + class_names[i]+":" + str(len(hole)))
#     for h in hole:
#         print(list(h))
# -

# #### T_all - Set of observed transitions for a class.

# List of transitions per class (T_all). It is just a set of transitions that occur for a class.
transitions_per_class = []
for index, df in enumerate(adjacency_matrix_list_with_holes):
    transitions_per_class.append(df.columns.values)
# for i, transition in enumerate(transitions_per_class):
#     print('{}:{}'.format(class_names[i], transition))

# #### P - set of pairs <t1,t2> (consecutive transitions)

def get_consecutive_transitions_per_class(adjacency_matrix_list_with_holes):
    consecutive_transitions_per_class = []
    for index, df in enumerate(adjacency_matrix_list_with_holes):
        consecutive_transitions = set()  # for a class
        for i in range(df.shape[0]):
            for j in range(df.shape[1]):
                if df.iloc[i, j] != 'hole':
                    if df.iloc[i, j] > 0:
#                         print("(" + df.index[i] + "," + df.columns[j] + ")")
                        consecutive_transitions.add((df.index[i], df.columns[j]))
        consecutive_transitions_per_class.append(consecutive_transitions)
    return consecutive_transitions_per_class


#  Create list of consecutive transitions per class (P). If value is not null, ordered pair i,j would be consecutive transitions per class
consecutive_transitions_per_class = get_consecutive_transitions_per_class(adjacency_matrix_list_with_holes)
# printmd("###  Consecutive transitions per class")
# for i, transition in enumerate(consecutive_transitions_per_class):
#     printmd("#### "+class_names[i]+":")
#     for x in list(transition):
#         print(x)
# #     print('{}:{}'.format(class_names[i], transition))
#     print()

# ### Check Well Formed

# +
def check_well_formed(subset_df):
    # got the adjacency matrix subset
    df = subset_df.copy()
    well_formed_flag = True
    
    
    if (df == 0).all(axis=None): # all elements are zero
        well_formed_flag = False
        
    # for particular adjacency matrix's copy, loop over all pairs of rows
    for i in range(0, df.shape[0]-1):
        for j in range(i + 1, df.shape[0]):
            print(i,j)
            idx1, idx2 = i, j
            row1, row2 = df.iloc[idx1, :], df.iloc[idx2, :]  # we have now all pairs of rows

            common_values_flag = False  # for each two rows we have a common_values_flag

            # if there is a common value between two rows, turn common value flag to true
            for col in range(row1.shape[0]):
                if row1.iloc[col] > 0 and row2.iloc[col] > 0:
                    common_values_flag = True
                    break
          
            if common_values_flag:
                for col in range(row1.shape[0]): # check for holes if common value
                    if row1.iloc[col] > 0 and row2.iloc[col] == 0:
                        well_formed_flag = False
                    elif row1.iloc[col] == 0 and row2.iloc[col] > 0:
                        well_formed_flag = False
    
    if not well_formed_flag:
        return False
    elif well_formed_flag:
        return True
     
                    
    
# -

# ### Check Valid Transitions

def check_valid(subset_df,consecutive_transitions_per_class):
    
    # Note: Essentially we check validity against P instead of E. 
    # In the paper of LOCM2, it isn't mentioned how to check against E.
    
    # Reasoning: If we check against all consecutive transitions per class, 
    # we essentially check against all example sequences.
    # check the candidate set which is well-formed (subset df against all consecutive transitions)

    # got the adjacency matrix subset
    df = subset_df.copy()

    # for particular adjacency matrix's copy, loop over all pairs of rows
    for i in range(df.shape[0]):
        for j in range(df.shape[0]):
            if df.iloc[i,j] > 0:
                valid_val_flag = False
                ordered_pair = (df.index[i], df.columns[j])
                for ct_list in consecutive_transitions_per_class:
                    for ct in ct_list:
                        if ordered_pair == ct:
                            valid_val_flag=True
                # if after all iteration ordered pair is not found, mark the subset as invalid.
                if not valid_val_flag:
                    return False
                
    # return True if all ordered pairs found.
    return True


# ### LOCM2 transition sets

# +
def locm2_get_transition_sets_per_class(holes_per_class, transitions_per_class, consecutive_transitions_per_class):
    """LOCM 2 Algorithm in the original LOCM2 paper"""
    
    # contains Solution Set S for each class.
    transition_sets_per_class = []

    # for each hole for a class/sort
    for index, holes in enumerate(holes_per_class):
        class_name = class_names[index]
        printmd("### "+  class_name)
        
        # S
        transition_set_list = [] #transition_sets_of_a_class, # intially it's empty
        
        if len(holes)==0:
            print("no holes") # S will contain just T_all
        
        if len(holes) > 0: # if there are any holes for a class
            print(str(len(holes)) + " holes")
            for ind, hole in enumerate(holes):
                printmd("#### Hole " + str(ind + 1) + ": " + str(set(hole)))
                is_hole_already_covered_flag = False
                if len(transition_set_list)>0:
                    for s_prime in transition_set_list:
                        if hole.issubset(s_prime):
                            printmd("Hole "+ str(set(hole)) + " is already covered.")
                            is_hole_already_covered_flag = True
                            break
                     
                # discover a set which includes hole and is well-formed and valid against test data.
                # if hole is not covered, do BFS with sets of increasing sizes starting with s=hole
                if not is_hole_already_covered_flag: 
                    h = hole.copy()
                    candidate_sets = []
                    # all subsets of T_all starting from hole's len +1 to T_all-1.
                    for i in range(len(h)+1,len(transitions_per_class[index])): 
                        subsets = findsubsets(transitions_per_class[index],i) # all subsets of length i

                        for s in subsets:
                            if h.issubset(s): # if  is subset of s
                                candidate_sets.append(set(s))
                        
                        s_well_formed_and_valid = False
                        for s in candidate_sets:
                            if len(s)>=i:
                                printmd("Checking candidate set *" + str(s) + "* of class **" + class_name + "** for well formedness and Validity")
                                subset_df = adjacency_matrix_list[index].loc[list(s),list(s)]
                                print_table(subset_df)

                                # checking for well-formedness
                                well_formed_flag = False
                                well_formed_flag = check_well_formed(subset_df)
                                if not well_formed_flag:
                                    print("This subset is NOT well-formed")
                                    
                                elif well_formed_flag:
                                    print("This subset is well-formed.")
                                    # if well-formed validate across the data E
                                    # to remove inappropriate dead-ends
                                    valid_against_data_flag = False
                                    valid_against_data_flag = check_valid(subset_df, consecutive_transitions_per_class)
                                    if not valid_against_data_flag:
                                        print("This subset is well-formed but invalid against example data")

                                    if valid_against_data_flag:
                                        print("This subset is valid.")
                                        print("Adding this subset " + str(s) +" to the locm2 transition set.")
                                        if s not in transition_set_list: # do not allow copies.
                                            transition_set_list.append(s)
                                        
                                        print("Hole that is covered now:")
                                        print(list(h))
                                        s_well_formed_and_valid = True
                                        break 
                        if s_well_formed_and_valid:
                                break
                                        
                                        

        print(transition_set_list)                                    
        #step 7 : remove redundant sets S - {s1}
        ts_copy = transition_set_list.copy()
        for i in range(len(ts_copy)):
            for j in range(len(ts_copy)):
                if ts_copy[i] < ts_copy[j]: #if subset
                    if ts_copy[i] in transition_set_list:
                        transition_set_list.remove(ts_copy[i])
                elif ts_copy[i] > ts_copy[j]:
                    if ts_copy[j] in transition_set_list:
                        transition_set_list.remove(ts_copy[j])
        print("\nRemoved redundancy transition set list")
        print(transition_set_list)

        #step-8: include all-transitions machine, even if it is not well-formed.
        transition_set_list.append(set(transitions_per_class[index])) #fallback
        printmd("#### Final transition set list")
        print(transition_set_list)
        transition_sets_per_class.append(transition_set_list)
        

    return transition_sets_per_class


############    LOCM2 #################
####    Input ready for LOCM2, Starting LOCM2 algorithm now
####    Step 8:  selecting transition sets (TS) [Main LOCM2 Algorithm]
printmd("### Getting transitions sets for each class using LOCM2")
transition_sets_per_class = locm2_get_transition_sets_per_class(holes_per_class, transitions_per_class, consecutive_transitions_per_class)


# -

# ## Step 3: Algorithm For Induction of State Machines
#
# - Input: Action training sequence of length N
# - Output: Transition Set TS, Object states OS.
#
# We already have transition set TS per class.

def plot_cytographs_fsm(graph, domain_name):
    cytoscapeobj = CytoscapeWidget()
    cytoscapeobj.graph.add_graph_from_networkx(graph)
    edge_list = list()
    for source, target, data in graph.edges(data=True):
        edge_instance = Edge()
        edge_instance.data['source'] = source
        edge_instance.data['target'] = target
        for k, v in data.items():
            cyto_attrs = ['group', 'removed', 'selected', 'selectable',
                'locked', 'grabbed', 'grabbable', 'classes', 'position', 'data']
            if k in cyto_attrs:
                setattr(edge_instance, k, v)
            else:
                edge_instance.data[k] = v
            edge_list.append(edge_instance)

    cytoscapeobj.graph.edges = edge_list
#     print("Nodes:{}".format(graph.nodes()))
#     print("Edges:{}".format(graph.edges()))
    cytoscapeobj.set_style([{
                    'width':400,
                    'height':500,

                    'selector': 'node',
                    'style': {
                        'label': 'data(id)',
                        'font-family': 'helvetica',
                        'font-size': '8px',
                        'background-color': '#11479e',
                        'height':'10px',
                        'width':'10px',


                        }

                    },
                    {
                    'selector': 'node:parent',
                    'css': {
                        'background-opacity': 0.333,
                        'background-color': '#bbb'
                        }
                    },
                    {
                    'selector': '$node > node',
                    'css': {
                        'padding-top': '10px',
                        'padding-left': '10px',
                        'padding-bottom': '10px',
                        'padding-right': '10px',
                        'text-valign': 'top',
                        'text-halign': 'center',
                        'background-color': '#bbb'
                      }
                    },
                   {
                        'selector': 'edge',

                        'style': {
                            'label':'data(weight)',
                            'width': 1,
                            'line-color': '#9dbaea',
                            'target-arrow-shape': 'triangle',
                            'target-arrow-color': '#9dbaea',
                            'arrow-scale': 0.5,
                            'curve-style': 'bezier',
                            'font-family': 'helvetica',
                            'font-size': '8px',
                            'text-valign': 'top',
                            'text-halign':'center'
                        }
                    },
                    ])
    cytoscapeobj.max_zoom = 2.0
    cytoscapeobj.min_zoom = 0.5
    display(cytoscapeobj)

# #### First make start(t) and end(t) as state for each transition in FSM.

# +
state_machines_overall_list = []

for index, ts_class in enumerate(transition_sets_per_class):
    fsms_per_class = []
    printmd("### "+ class_names[index])
    num_fsms = len(ts_class)
    print("Number of FSMS:" + str(num_fsms))
    
    for fsm_no, ts in enumerate(ts_class):
        fsm_graph = nx.DiGraph()
        
        printmd("#### FSM " + str(fsm_no))
        for t in ts:
            source = "s(" + str(t) + ")"
            target = "e(" + str(t) + ")"
            fsm_graph.add_edge(source,target,weight=t)
        
       
        t_df = adjacency_matrix_list[index].loc[list(ts), list(ts)] #transition df for this fsm
        print_table(t_df)
        
        
        # merge end(t1) = start(t2) from transition df
        
        edge_t_list = [] # edge transition list
        for i in range(t_df.shape[0]):
            for j in range(t_df.shape[1]):
                
                if t_df.iloc[i, j] != 'hole':
                    if t_df.iloc[i, j] > 0:
                        for node in fsm_graph.nodes():
                            if "e("+t_df.index[i]+")" in node:
                                merge_node1 = node
                            if "s("+t_df.index[j]+")" in node:
                                merge_node2 = node
                        
                        
                        

                        fsm_graph = nx.contracted_nodes(fsm_graph, merge_node1, merge_node2 , self_loops=True)

                        if merge_node1 != merge_node2:
                            mapping = {merge_node1: merge_node1 + "|" + merge_node2} 
                            fsm_graph = nx.relabel_nodes(fsm_graph, mapping)

        # we need to complete the list of transitions 
        # that can happen on self-loop nodes 
        # as these have been overwritten (as graph is not MultiDiGraph)
        
        sl_state_list = list(nx.nodes_with_selfloops(fsm_graph)) # self looping states.
        # if state is self-looping
        t_list = []
        if len(sl_state_list)>0: 
            # if s(T1) and e(T1) are there for same node, this T1 can self-loop occur.
            for s in sl_state_list:
                for sub_s in s.split('|'):
                    if sub_s[0] == 'e':
                        if ('s' + sub_s[1:]) in s.split('|'):
                            t_list.append(sub_s[2:-1])
                fsm_graph[s][s]['weight'] = '|'.join(t_list)
        
        

               
        plot_cytographs_fsm(fsm_graph,domain_name)
        df = nx.to_pandas_adjacency(fsm_graph, nodelist=fsm_graph.nodes(), weight = 1)
        print_table(df)
        fsms_per_class.append(fsm_graph)
    state_machines_overall_list.append(fsms_per_class)
# -

# ## USER INPUT 3: Rename States. 
#
#
# As states are shown in terms of end and start of transitions, user can rename them for easy readability later on.
#
# If states are renamed, certain hardcoded aspects of code won't work. It is advisable to create a  separate state dictionary and use it after step 9: (formation of PDDL model) to replace states in PDDL code.
#
#
# This also makes it easier to specify problem statements.

# ### Automatic creation: rename states as integers 0, 1, 2 .. etc. for each fsm.

# +
# An Automatic state dictionary is added here where states are 
# renamed as 0, 1, 2 etc. for a specific FSM

state_mappings_class = []
state_machines_overall_list_2 = []
for index, fsm_graphs in enumerate(state_machines_overall_list):
    state_mappings_fsm = []
    fsms_per_class_2 = []
    printmd("### "+ class_names[index])
    num_fsms = len(fsm_graphs)
    print("Number of FSMS:" + str(num_fsms))
    
    for fsm_no, G in enumerate(fsm_graphs):
        
        state_mapping = {k: v for v, k in enumerate(G.nodes())}
        G_copy = nx.relabel_nodes(G, state_mapping)
        
        plot_cytographs_fsm(G, domain_name)
        plot_cytographs_fsm(G_copy, domain_name)
        printmd("Fsm "+ str(fsm_no))
        fsms_per_class_2.append(G_copy)
        state_mappings_fsm.append(state_mapping)
        
    state_machines_overall_list_2.append(fsms_per_class_2)
    state_mappings_class.append(state_mappings_fsm)
    

# -

# ### Looking at the graph, User can specify states here

# +
# User can specify states here.
# assign your states in state dictionary called state_mapping
# e.g. state_mapping['e(removewheek.2)|s(putonwheel.2)'] = 'jack_free_to_use'
# -

# ## Step 5: Induction of parameterized state machines
# Create and test hypothesis for state parameters

# + [markdown] code_folding=[]
# ### Form Hyp for HS (Hypothesis set)

# +
HS_list = []
ct_list = []

# for transition set of each class
for index, ts_class in enumerate(transition_sets_per_class):
    printmd("### "+ class_names[index])
    
    ct_per_class = []
    HS_per_class = []
    
    # for transition set of each fsm in a class
    for fsm_no, ts in enumerate(ts_class):
        printmd("#### FSM: " + str(fsm_no) + " Hypothesis Set")
        
        # transition matrix for the ts
        t_df = adjacency_matrix_list[index].loc[list(ts), list(ts)]
        ct_in_fsm = set()  # find consecutive transition set for a state machine in a class.
        for i in range(t_df.shape[0]):
            for j in range(t_df.shape[1]):
                if t_df.iloc[i, j] != 'hole':
                    if t_df.iloc[i, j] > 0:
                        ct_in_fsm.add((t_df.index[i], t_df.columns[j]))
        
        ct_per_class.append(ct_in_fsm)
        
        # add to hypothesis set
        HS = set()
        
        # for each pair B.k and C.l in TS s.t. e(B.k) = S = s(C.l)
        for ct in ct_in_fsm:
            B = ct[0].split('.')[0] # action name of T1
            k = int(ct[0].split('.')[1]) # argument index of T1
            
            C = ct[1].split('.')[0] # action name of T2
            l = int(ct[1].split('.')[1]) # argument index of T2
            
            
            
            
            # When both actions B and C contain another argument of the same sort G' in position k' and l' respectively, 
            # we hypothesise that there may be a relation between sorts G and G'.
            for seq in sequences:
                for actarg_tuple in seq:
                    arglist1 = []
                    arglist2 = []
                    if actarg_tuple[0] == B: #if action name is same as B
                        arglist1 = actarg_tuple[1].copy()
#                         arglist1.remove(actarg_tuple[1][k]) # remove k from arglist
                        for actarg_tuple_prime in seq: #loop through seq again.
                            if actarg_tuple_prime[0] == C:
                                arglist2 = actarg_tuple_prime[1].copy()
#                                 arglist2.remove(actarg_tuple_prime[1][l]) # remove l from arglist
                                

                        # for arg lists of actions B and C, if class is same add a hypothesis set.
                        for i in range(len(arglist1)): # if len is 0, we don't go in
                            for j in range(len(arglist2)):
                                class1 = get_class_index(arglist1[i], classes)
                                class2 = get_class_index(arglist2[j], classes)
                                if class1 == class2: # if object at same position have same classes
                                    # add hypothesis to hypothesis set.
                                    if (k!=i) and (l!=j):
                                        HS.add((frozenset({"e("+B+"."+ str(k)+")", "s("+C+"."+str(l)+")"}),B,k,i,C,l,j,class_names[index],class_names[class1]))
        print(str(len(HS))+ " hypothesis created")
#         for h in HS:
#             print(h)
        
        HS_per_class.append(HS)
    HS_list.append(HS_per_class)
    ct_list.append(ct_per_class)
# -

# ### Test hyp against E

HS_list_retained = []
for index, HS_class in enumerate(HS_list):
    printmd("### "+ class_names[index])
    HS_per_class_retained = []


    for fsm_no, HS in enumerate(HS_class):
        printmd("#### FSM: " + str(fsm_no) + " Hypothesis Set")

        count=0
        HS_copy = HS.copy()
        HS_copy2 = HS.copy()

        
        # for each object O occuring in Ou
        for O in arguments:
            #   for each pair of transitions Ap.m and Aq.n consecutive for O in seq
            ct = []
            for seq in sequences:
                for actarg_tuple in seq:
                    act = actarg_tuple[0]
                    for j, arg in enumerate(actarg_tuple[1]):
                        if arg == O:
                            ct.append((act + '.' + str(j), actarg_tuple[1]))


            for i in range(len(ct)-1):
                A_p = ct[i][0].split('.')[0]
                m = int(ct[i][0].split('.')[1])
                A_q = ct[i+1][0].split('.')[0]
                n = int(ct[i+1][0].split('.')[1]) 

                # for each hypothesis H s.t. A_p = B, m = k, A_q = C, n = l

                for H in HS_copy2:
                    if A_p == H[1] and m == H[2] and A_q == H[4] and n == H[5]:
                        k_prime = H[3]
                        l_prime = H[6]

                        # if O_p,k_prime = Q_q,l_prime
                        if ct[i][1][k_prime] != ct[i+1][1][l_prime]:
                            if H in HS_copy:
                                HS_copy.remove(H)
                                count += 1

        print(str(len(HS_copy))+ " hypothesis retained")
        # state machine
#         if len(HS_copy)>0:
#             plot_cytographs_fsm(state_machines_overall_list[index][fsm_no],domain_name)
#         for H in HS_copy:
#             print(H)
        HS_per_class_retained.append(HS_copy)
    HS_list_retained.append(HS_per_class_retained)

# ## Step 6: Creation and merging of state parameters

# +
# Each hypothesis refers to an incoming and outgoing transition 
# through a particular state of an FSM
# and matching associated transitions can be considered
# to set and read parameters of a state.
# Since there maybe multiple transitions through a give state,
# it is possible for the same parameter to have multiple
# pairwise occurences.

print("Step 6: creating and merging state params")
param_bindings_list_overall = []
for classindex, HS_per_class in enumerate(HS_list_retained):
    param_bind_per_class = []
    
    
    for fsm_no, HS_per_fsm in enumerate(HS_per_class):
        param_binding_list = []
        
        # fsm in consideration
        G = state_machines_overall_list[classindex][fsm_no]
        state_list = G.nodes()
        
        # creation
        for index,h in enumerate(HS_per_fsm):
            param_binding_list.append((h,"v"+str(index)))
        
        merge_pl = [] # parameter to merge list
        if len(param_binding_list)>1:
            # merging
            pairs = findsubsets(param_binding_list, 2)
            for pair in pairs:
                h_1 = pair[0][0]
                h_2 = pair[1][0]
                
                
                # equate states
                state_eq_flag = False
                for s_index, state in enumerate(state_list):
                    # if both hyp states appear in single state in fsm
                    if list(h_1[0])[0] in state:
                        if list(h_1[0])[0] in state:
                            state_eq_flag =True
                            
                
                if ((state_eq_flag and h_1[1] == h_2[1] and h_1[2] == h_2[2] and h_1[3] == h_2[3]) or (state_eq_flag and h_1[4] == h_2[4] and h_1[5] == h_2[5] and h_1[6] == h_2[6])):
                    merge_pl.append(list([pair[0][1], pair[1][1]]))
          
        
       
        #inner lists to sets (to list of sets)
        l=[set(x) for x in merge_pl]

        #cartesian product merging elements if some element in common
        for a,b in itertools.product(l,l):
            if a.intersection( b ):
                a.update(b)
                b.update(a)

        #back to list of lists
        l = sorted( [sorted(list(x)) for x in l])

        #remove dups
        merge_pl = list(l for l,_ in itertools.groupby(l))
        
        # sort
        for pos, l in enumerate(merge_pl):
            merge_pl[pos] = sorted(l, key = lambda x: int(x[1:]))
        
        print(merge_pl) # equal params appear in a list in this list.
          
            
        for z,pb in enumerate(param_binding_list):
            for l in merge_pl:
                if pb[1] in l:
                    # update pb
                    param_binding_list[z] = (param_binding_list[z][0], l[0])
        

                
        
        param_bind_per_class.append(param_binding_list)
        print(class_names[classindex])
        
        # set of params per class
        param = set()
        for pb in param_binding_list:
#             print(pb)
            param.add(pb[1])
            
        # num of params per class
        printmd("No. of params earlier:" + str(len(param_binding_list)))
        printmd("No. of params after merging:" + str(len(param)))
            
        
        
        
        
    param_bindings_list_overall.append(param_bind_per_class)


# -


# ## Step 7: Remove Parameter Flaws

# +
# Removing State Params.
# Flaw occurs Object can reach state S with param P having an inderminate value.
# There is transition s.t. end(B.k) = S. 
# but there is no h = <S,B,k,k',C,l,l',G,G') and <h,P> is in bindings.

para_bind_overall_fault_removed  = []
for classindex, fsm_per_class in enumerate(state_machines_overall_list):
    print(class_names[classindex])
    pb_per_class_fault_removed = []

    for fsm_no, G in enumerate(fsm_per_class):
        
        pb_per_fsm_fault_removed = []
        # G is fsm in consideration
        faulty_pb = []
        for state in G.nodes():
            inedges = G.in_edges(state, data=True)
            
            for ie in inedges:
                tr = ie[2]['weight']
                t_list = tr.split('|')
                for t in t_list:
                    B = t.split('.')[0]
                    k = t.split('.')[1]
                    S = 'e(' + t + ')'
                    flaw = True
                    for pb in param_bindings_list_overall[classindex][fsm_no]:
                        H = pb[0]
                        v = pb[1]
                        if (S in set(H[0])) and (B==H[1]) and (int(k)==H[2]) :
                            # this pb is okay
                            flaw=False
#                     print(flaw)
                    if flaw:
                        for pb in param_bindings_list_overall[classindex][fsm_no]:
                            H = pb[0]
                            H_states = list(H[0])
                            for h_state in H_states:
                                if h_state in state:
                                    if pb not in faulty_pb:
                                        faulty_pb.append(pb) # no duplicates
        
        for pb in param_bindings_list_overall[classindex][fsm_no]:
            if pb not in faulty_pb:
                pb_per_fsm_fault_removed.append(pb)
        
                                
                        
                        
        print(str(len(pb_per_fsm_fault_removed)) + "/" + str(len(param_bindings_list_overall[classindex][fsm_no])) + " param retained")
        for pb in pb_per_fsm_fault_removed:
            print(pb)

                
        
        pb_per_class_fault_removed.append(pb_per_fsm_fault_removed)
    para_bind_overall_fault_removed.append(pb_per_class_fault_removed)
# -

# ## Step 8: (TODO) Static Preconditions via LOP
# As further enhancement, one can add step 8: Extraction of static preconditions from the LOCM paper.
# However, LOP algorithm is better version of that step.
#
# Insert [LOP](https://www.aaai.org/ocs/index.php/ICAPS/ICAPS15/paper/viewFile/10621/10401) here for finding static preconditions

# ## Step 9:  Formation of PDDL Schema

# +
# get action schema
print(";;********************Learned PDDL domain******************")
output_file = "output/"+ domain_name + "/" +  domain_name + ".pddl"
write_file = open(output_file, 'w')
write_line = "(define"
write_line += "  (domain "+ domain_name+")\n"
write_line += "  (:requirements :typing)\n"
write_line += "  (:types"
for class_name in class_names:
    write_line += " " + class_name
write_line += ")\n"
write_line += "  (:predicates\n"

# one predicate to represent each object state

predicates = []
for class_index, pb_per_class in enumerate(para_bind_overall_fault_removed):
    for fsm_no, pbs_per_fsm in enumerate(pb_per_class):
        for state_index, state in enumerate(state_machines_overall_list[class_index][fsm_no].nodes()):
            
            state_set = set(state.split('|'))
            predicate = ""
       
            write_line += "    (" + class_names[class_index] + "_fsm" + str(fsm_no) + "_" +  state
            predicate += "    (" + class_names[class_index] + "_fsm" + str(fsm_no) + "_" + state
            for pb in pbs_per_fsm:
                    if set(pb[0][0]) <= state_set:
                        if " ?"+pb[1] + " - " + str(pb[0][8]) not in predicate:
                            write_line += " ?"+pb[1] + " - " + str(pb[0][8])
                            predicate += " ?"+pb[1] + " - " + str(pb[0][8])
    
            write_line += ")\n"
            predicate += ")"
            predicates.append(predicate)
write_line += "  )\n"
            
for action_index, action in enumerate(actions):
    write_line += "\n"
    write_line += "  (:action"
    write_line += "  " + action + " "
    write_line += "  :parameters"
    write_line += "  ("
    arg_already_written_flag = False
    params_per_action = []
    args_per_action = []
    for seq in sequences:
        for actarg_tuple in seq:
            if not arg_already_written_flag:
                if actarg_tuple[0] == action:
                    arglist = []
                    for arg in actarg_tuple[1]:
                        write_line += "?"+arg + " - " + class_names[get_class_index(arg,classes)] + " "
                        arglist.append(arg)
                    args_per_action.append(arglist)
                    params_per_action.append(actarg_tuple[1])
                    arg_already_written_flag = True
    write_line += ")\n"


    # need to use FSMS to get preconditions and effects.
    # Start-state = precondition. End state= Effect
    preconditions = []
    effects = []
    for arglist in params_per_action:
        for arg in arglist:
            current_class_index = get_class_index(arg, classes)
            for fsm_no, G in enumerate(state_machines_overall_list[current_class_index]):
#                
                for start, end, weight in G.edges(data='weight'):
                    _actions = weight.split('|')
                    for _action in _actions:
                        
                        if _action.split('.')[0] == action:
                            for predicate in predicates:
                                pred = predicate.split()[0].lstrip("(")
                                clss = pred.split('_')[0]
                                fsm = pred.split('_')[1]
                                state = set(pred.split('_')[2].replace('))',')').split('|'))



                                if clss == class_names[current_class_index]:
                                    if fsm == "fsm" + str(fsm_no):

                                        if state == set(start.split('|')):

                                            if predicate not in preconditions:
                                                preconditions.append(predicate)

                                        if state == set(end.split('|')):
                                            if predicate not in effects:
                                                effects.append(predicate)
                            break
                                        
    
                

    write_line += "   :precondition"
    write_line += "   (and\n"
    for precondition in preconditions:
        # precondition = precondition.replace(?)
        write_line += "    "+precondition+"\n"
    write_line += "   )\n"
    write_line += "   :effect"
    write_line += "   (and\n"
    for effect in effects:
        write_line += "    " + effect + "\n"
    write_line += "  )"

    write_line += ")\n"

write_line += ")\n" #domain ending bracket


print(write_line)

write_file.write(write_line)
write_file.close()


# -


# ### Validating PDDL -- Fixing Syntax by replacing predicates with state dictionary values
# This is required because PDDL syntax doesn't support extra paranthesis () which occur in states (transitions occuring in states as 'start(t1)' or  'end(t1)')

# +
# get action schema
print(";;********************Learned PDDL domain******************")
output_file = "output/"+ domain_name + "/" +  domain_name + ".pddl"
write_file = open(output_file, 'w')
write_line = "(define"
write_line += "  (domain "+ domain_name+")\n"
write_line += "  (:requirements :typing)\n"
write_line += "  (:types"
for class_name in class_names:
    write_line += " " + class_name
write_line += ")\n"
write_line += "  (:predicates\n"

# one predicate to represent each object state

predicates = []
for class_index, pb_per_class in enumerate(para_bind_overall_fault_removed):
    for fsm_no, pbs_per_fsm in enumerate(pb_per_class):
        state_mapping = state_mappings_class[class_index][fsm_no]
        
        for state_index, state in enumerate(state_machines_overall_list[class_index][fsm_no].nodes()):
            
            state_set = set(state.split('|'))
            predicate = ""
       
            write_line += "    (" + class_names[class_index] + "_fsm" + str(fsm_no) + "_state" +  str(state_mapping[state])
            predicate += "    (" + class_names[class_index] + "_fsm" + str(fsm_no) + "_state" + str(state_mapping[state])
            for pb in pbs_per_fsm:
                    if set(pb[0][0]) <= state_set:
                        if " ?"+pb[1] + " - " + str(pb[0][8]) not in predicate:
                            write_line += " ?"+pb[1] + " - " + str(pb[0][8])
                            predicate += " ?"+pb[1] + " - " + str(pb[0][8])
    
            write_line += ")\n"
            predicate += ")"
            predicates.append(predicate)
write_line += "  )\n"
            
for action_index, action in enumerate(actions):
    write_line += "  (:action"
    write_line += "  " + action + " "
    write_line += "  :parameters"
    write_line += "  ("
    arg_already_written_flag = False
    params_per_action = []
    args_per_action = []
    for seq in sequences:
        for actarg_tuple in seq:
            if not arg_already_written_flag:
                if actarg_tuple[0] == action:
                    arglist = []
                    for arg in actarg_tuple[1]:
                        write_line += "?"+arg + " - " + class_names[get_class_index(arg,classes)] + " "
                        arglist.append(arg)
                    args_per_action.append(arglist)
                    params_per_action.append(actarg_tuple[1])
                    arg_already_written_flag = True
    write_line += ")\n"


    # need to use FSMS to get preconditions and effects.
    # Start-state = precondition. End state= Effect
    preconditions = []
    effects = []
    for arglist in params_per_action:
        for arg in arglist:
            current_class_index = get_class_index(arg, classes)
            for fsm_no, G in enumerate(state_machines_overall_list[current_class_index]):
                G_int = state_machines_overall_list_2[current_class_index][fsm_no]
                state_mapping = state_mappings_class[current_class_index][fsm_no]
                for start, end, weight in G_int.edges(data='weight'):
                    _actions = weight.split('|')
                    for _action in _actions:
                        if _action.split('.')[0] == action:
                            for predicate in predicates:
                                pred = predicate.split()[0].lstrip("(")
                                clss = pred.split('_')[0]
                                fsm = pred.split('_')[1]
                                state_ind = pred.split('_')[2].rstrip(")")[-1]

                                if clss == class_names[current_class_index]:
                                    if fsm == "fsm" + str(fsm_no):
                                        if int(state_ind) == int(start):
                                            if predicate not in preconditions:
                                                preconditions.append(predicate)
                                                
                                        if int(state_ind) == int(end):
                                            if predicate not in effects:
                                                effects.append(predicate)
                            break
                            

                

    write_line += "   :precondition"
    write_line += "   (and\n"
    for precondition in preconditions:
        write_line += "    "+precondition+"\n"
    write_line += "   )\n"
    write_line += "   :effect"
    write_line += "   (and\n"
    for effect in effects:
        write_line += "    " + effect + "\n"
    write_line += "  )"

    write_line += ")\n\n"

write_line += ")\n" #domain ending bracket


print(write_line)

write_file.write(write_line)
write_file.close()
# -

# ### State Mapping: What are these states?

# +
# To see what these states are, look at the following graphs

for index, fsm_graphs in enumerate(state_machines_overall_list):
    printmd("## Class " + str(index))
    printmd("### "+ class_names[index])
    print("Number of FSMS:" + str(num_fsms))
    
    for fsm_no, G in enumerate(fsm_graphs):  
        printmd("Fsm "+ str(fsm_no))
        plot_cytographs_fsm(state_machines_overall_list_2[index][fsm_no], domain_name)
        plot_cytographs_fsm(G, domain_name)
# -

# ### State Mappings: Text format

for index, sm_fsm in enumerate(state_mappings_class):
    printmd("## Class " + str(index))
    printmd("### "+ class_names[index])

    
    for fsm_no, mapping in enumerate(sm_fsm):
        printmd("Fsm "+ str(fsm_no))
        pprint(mapping)

# # NER 

# finding entities using spacy
import spacy
from spacy import displacy
import en_core_web_sm
nlp = spacy.load('en_core_web_sm')
doc = nlp(coref_resolved_instructions)

displacy.render(nlp(str(doc)), jupyter=True, style='ent', options = {'ents':['QUANTITY', 'TIME', 'LOC', 'DATE']})


