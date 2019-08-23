import networkx as nx
import pandas as pd
pd.options.display.max_columns = 100
from main.locm2_utils import *
from main.read_sequence_file import*
from main.classes_utils import *

def build_and_save_fsms(classes, domain_name, class_names):
    # There should be a graph for each class of objects.
    graphs = []  # number of graphs = number of sorts.
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
                        node = actarg_tuple[0] + "." + str(j)  # name the node of graph which represents a transition
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


    # plot and save all the graphs
    adjacency_matrix_list = [] # list of adjacency matrices per class

    for index, G in enumerate(graphs):
        # TODO: Can use cycoscape or gephi for changes in Finite State Machines (due to errors in data extracted).
        nx.write_graphml(G, "output/"+ domain_name + "/" +  class_names[index] + ".graphml")

        # nx.draw(G, arrow_style='fancy', with_labels=True)
        # labels = nx.get_edge_attributes(G, 'weight')
        # pos = nx.spring_layout(G)
        # nx.draw_networkx_edge_labels(G, pos, edge_labels=labels)
        # plt.show()
        # print(G.nodes(), G.edges())

        # TODO: save dataframes in cache and reload them.
        # A = nx.to_numpy_matrix(G, nodelist=G.nodes())
        df = nx.to_pandas_adjacency(G, nodelist=G.nodes(), dtype=int)

        adjacency_matrix_list.append(df)

    return adjacency_matrix_list

def get_adjacency_matrix_with_holes(adjacency_matrix_list):
    adjacency_matrix_list_with_holes = []
    for index,adjacency_matrix in enumerate(adjacency_matrix_list):
        # print("\n ROWS ===========")
        df = adjacency_matrix.copy()
        df1 = adjacency_matrix.copy()

        # for particular adjacency matrix's copy, loop over all pairs of rows
        for i in range(df.shape[0] - 1):
            for j in range(i+1, df.shape[0]):
                idx1, idx2 = i, j
                row1, row2 = df.iloc[idx1,:], df.iloc[idx2, :] #we have now all pairs of rows

                common_values_flag = False #for each two rows we have a common_values_flag

                # if there is a common value between two rows, turn common value flag to true
                for col in range(row1.shape[0]):
                    if row1.iloc[col] > 0 and row2.iloc[col] > 0:
                        common_values_flag = True
                        break

                # now if two rows have common values, we need to check for holes.
                if common_values_flag:
                    for col in range(row1.shape[0]):
                        if row1.iloc[col] > 0 and row2.iloc[col] == 0:
                            df1.iloc[idx2,col] = 'hole'
                        elif row1.iloc[col] == 0 and row2.iloc[col] > 0:
                            df1.iloc[idx1, col] = 'hole'

        adjacency_matrix_list_with_holes.append(df1)
    return adjacency_matrix_list_with_holes

def check_well_formed(subset_df):
    # got the adjacency matrix subset
    df = subset_df.copy()

    # for particular adjacency matrix's copy, loop over all pairs of rows
    for i in range(df.shape[0] - 1):
        for j in range(i + 1, df.shape[0]):
            idx1, idx2 = i, j
            row1, row2 = df.iloc[idx1, :], df.iloc[idx2, :]  # we have now all pairs of rows

            common_values_flag = False  # for each two rows we have a common_values_flag

            # if there is a common value between two rows, turn common value flag to true
            for col in range(row1.shape[0]):
                if row1.iloc[col] > 0 and row2.iloc[col] > 0:
                    common_values_flag = True
                    break

            # now if two rows have common values, we need to check for holes.
            if common_values_flag:
                for col in range(row1.shape[0]):
                    if row1.iloc[col] > 0 and row2.iloc[col] == 0:
                        return False
                    elif row1.iloc[col] == 0 and row2.iloc[col] > 0:
                        return False
    return True

def check_valid(subset_df,consecutive_transitions_per_class):

    # Reasoning: If we check against all consecutive transitions of all classes, we essentially checked against all example sequences.
    # You check the candidate set which is well-formed (subset df against all consecutive transitions)

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
    return True

def get_consecutive_transitions_per_class(adjacency_matrix_list_with_holes):
    consecutive_transitions_per_class = []
    for index, df in enumerate(adjacency_matrix_list_with_holes):
        consecutive_transitions = set()  # for a class
        for i in range(df.shape[0]):
            for j in range(df.shape[1]):
                if df.iloc[i, j] != 'hole':
                    if df.iloc[i, j] > 0:
                        # print("(" + df.index[i] + "," + df.columns[j] + ")")
                        consecutive_transitions.add((df.index[i], df.columns[j]))
        consecutive_transitions_per_class.append(consecutive_transitions)
    return consecutive_transitions_per_class

def locm2_get_transition_sets_per_class(holes_per_class, transitions_per_class, consecutive_transitions_per_class):
    """ LOCM 2 Algorithm"""
    transition_sets_per_class = []

    # for each hole in a class of objects.
    for index, holes in enumerate(holes_per_class):
        class_name = class_names[index]
        print("***************")
        print(class_name)
        print("Number of holes: "+ str(len(holes))) # if number of holes == 0 then class is well-formed i.e. shouldn't change.
        print(holes)
        print("Transitions of the class (T_all):")
        print(transitions_per_class[index])
        print("Number of values: " + str(len(consecutive_transitions_per_class[index])))
        print("Transition Pairs per class (P):")
        print(consecutive_transitions_per_class[index])
        print()

        transition_set_list = [] #transition_sets_of_a_class, # intially its empty
        print("\n===========CHECKING CANDIDATE SETS OF CLASS " + class_name + " FOR WELL_FORMEDNESS AND VALIDITY========")
        if len(holes) > 0: # if there are any holes for a class
            for hole in holes:
                is_hole_already_covered_flag = False
                if len(transition_set_list)>0:
                    for s_prime in transition_set_list:
                        if hole.issubset(s_prime):
                            is_hole_already_covered_flag = True
                            break
                # discover a set which includes hole and is well-formed and valid against test data.
                if not is_hole_already_covered_flag: # if not covered, do BFS with sets of increasing sizes starting with s=hole
                    s = hole.copy()
                    candidate_sets = []
                    for i in range(len(s)+1,len(transitions_per_class[index])): # all subsets of T_all starting from hole's len +1
                        subsets = findsubsets(transitions_per_class[index],i)

                        # append the subsets which are subset of
                        for candidate_set in subsets:
                            if s.issubset(candidate_set):
                                candidate_sets.append(set(candidate_set))

                        # print("\n===========CHECKING CANDIDATE SETS FOR WELL_FORMEDNESS AND VALIDITY========")
                        for candidate_set in candidate_sets:
                            # print(candidate_set)
                            subset_df = adjacency_matrix_list[index].loc[list(candidate_set),list(candidate_set)]
                            # print_table(subset_df)

                            # checking for well-formedness
                            well_formed_flag = check_well_formed(subset_df)
                            if not well_formed_flag:
                                # print("This subset is NOT well-formed")
                                pass

                            # if well-formed validate across the data to remove inappropriate dead-ends
                            # additional check
                            valid_against_data_flag = False
                            if well_formed_flag:
                                # print_table(subset_df)
                                # print("This subset is well-formed")

                                # validate against all consecutive transitions per class (P)
                                # This checks all sequences consecutive transitions. So, it is validating against (E)
                                valid_against_data_flag = check_valid(subset_df, consecutive_transitions_per_class)
                                if not valid_against_data_flag:
                                    print("Invalid against data")

                            if valid_against_data_flag:
                                print("Adding this subset as well-formed and valid.")
                                print_table(subset_df)
                                print(candidate_set)
                                if candidate_set not in transition_set_list: # do not allow copies.
                                    transition_set_list.append(candidate_set)
                                break
                        print("Hole that is covered now:")
                        print(s)
                        break


            # print(transition_set_list)
        #step -7 : remove redundant sets
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
        transition_set_list.append(set(transitions_per_class[index]))
        print("\nFinal transition set list")
        print(class_name)
        print(transition_set_list)


        transition_sets_per_class.append(transition_set_list)
    return transition_sets_per_class

if __name__ == "__main__":

    print("Starting with reading files ...")
    # step 1: read_file returns list of all plans. Each plan contains tuples of action and its args.
    input_file_name = '../locm_data/rocket_locmfeb.txt'
    domain_name = input_file_name.split('/')[-1].split('.')[0]
    sequences = read_file(input_file_name)

    print("Sequences")
    print_sequences(sequences[:10])
    print("\nNumer of Sequences")
    print(len(sequences))

    # step 2: find out transition set, objects in domain, action names.
    transitions = set() #set of all transitions in a domain
    arguments = set() #set of all arguments in a domain
    actions = set() #set of all actions in a domain

    for seq in sequences:
        for actarg_tuple in seq:
            actions.add(actarg_tuple[0])
            for j, arg in enumerate(actarg_tuple[1]):
                transitions.add(actarg_tuple[0]+"."+str(j))
                arguments.add(arg)

    print("\nActions")
    print(actions)
    print("\nTransitions")
    print(transitions)
    print("\nArguments/Objects")
    print(arguments)

    d = get_actarg_dictionary(sequences)
    classes = get_classes(d) #sorts of object
    print("\nSorts/Classes")
    print(classes)

    class_names = get_class_names(classes)
    print("\nExtracted class names")
    print(class_names)

    print("\nNumber of Actions: {},\nNumber of unique transitions: {},\nNumber of unique objects (arguments): {},\nNumber of classes/sorts: {}".format(len(actions), len(transitions), len(arguments), len(classes)))

    #### Step 3:  Build FSMs (weighted directed graphs) for transitions.
    adjacency_matrix_list = build_and_save_fsms(classes, domain_name, class_names)

    #### Check well-formedness of adjacency matrix - if yes, then apply LOCM1 (automatically goes to LOCM1)

    ### Values in transition matrix row describes for a given transition, which transitions may follow.
    ### Any two transitions which end up in same state, will have a same pattern in row.
    ### Under the assumption that each transition may only appear once in the state based representation,
    ### we can say any two rows must be identical or non-overlapping.

    ### So we need to find overlapping + non-identical fingerprints.

    ####  Step 4: Finding holes
    ####   Holes are transition pairs not observed in the data, but would be permitted if approximated by single state machine LOCM.
    adjacency_matrix_list_with_holes = get_adjacency_matrix_with_holes(adjacency_matrix_list)


    ### Printing FSM matrices with and without holes
    for index,adjacency_matrix in enumerate(adjacency_matrix_list):
        print("\n==========" + class_names[index] + "==========")
        # print(adjacency_matrix)
        print(tabulate(adjacency_matrix, headers='keys', tablefmt='psql'))

        print("\n===== HOLES: " + class_names[index] + "==========")
        print(tabulate(adjacency_matrix_list_with_holes[index], headers='keys', tablefmt='psql'))

    ####   Step 5: Create list of set of holes per class (H)
    holes_per_class = []

    for index,df in enumerate(adjacency_matrix_list_with_holes):
        holes = set()
        for i in range(df.shape[0]):
            for j in range(df.shape[1]):
                if df.iloc[i,j] == 'hole':
                    holes.add(frozenset({df.index[i] , df.columns[j]}))
        holes_per_class.append(holes)

    ####    Step 6: Create list of transitions per class (T_all). It is just a set of transitions that occur for a class.
    transitions_per_class = []
    for index, df in enumerate(adjacency_matrix_list_with_holes):
        transitions_per_class.append(df.columns.values)

    ####    Step 7: Create list of consecutive transitions per class (P). If value is not null, ordered pair i,j would be consecutive transitions per class
    consecutive_transitions_per_class = get_consecutive_transitions_per_class(adjacency_matrix_list_with_holes)

    ############    LOCM2 #################
    ####    Input ready for LOCM2, Starting LOCM2 algorithm now
    ####    Step 8:  selecting transition sets (TS) [Main LOCM2 Algorithm]
    print("######## Getting transitions sets for each class using LOCM2 ######")
    transition_sets_per_class = locm2_get_transition_sets_per_class(holes_per_class, transitions_per_class, consecutive_transitions_per_class)


    # Printing Transition Sets per Class
    ### LOCM1: Step 1 induction of state machines

    print("\n=========LOCM===============")
    print("*****************")
    print("Step 1: Induction of Finite State Machines")
    state_machines_overall_list = [] # list of all state machines
    for index, ts in enumerate(transition_sets_per_class):
        state_machines_per_class = [] # state machines for each class.
        print(class_names[index])
        # print(ts)
        num_fsms = len(ts)
        print("Number of FSMS:" + str(num_fsms))


        #### Add state identifiers
        states_per_transition_set = []
        for transition_set in ts:
            states = set()
            for transition in transition_set:
                states.add(frozenset({"start(" + transition + ")"}))
                states.add(frozenset({"end(" + transition + ")"}))
            states_per_transition_set.append(states)

        # print(states_per_transition_set)

        #### For each pair of consecutive transitions T1, T2 in TS: Unify states end(T1) and start(T2) in set OS
        for fsm_no, transition_set in enumerate(ts):
            transition_df = adjacency_matrix_list[index].loc[list(transition_set), list(transition_set)] #uses transition matrix without holes

            consecutive_transitions_state_machines_per_class = set()  # find consecutive transitions for a state machine in a class.
            for i in range(transition_df.shape[0]):
                for j in range(transition_df.shape[1]):
                    if transition_df.iloc[i, j] != 'hole':
                        if transition_df.iloc[i, j] > 0:
                            consecutive_transitions_state_machines_per_class.add((transition_df.index[i], transition_df.columns[j]))

            # for every consecutive transition and for every state of a class, check if that state matches end(t1) or start(t2)
            for ct in consecutive_transitions_state_machines_per_class:
                s1, s2, s3 = -1, -1, -1
                for s in states_per_transition_set[fsm_no]:
                    if "end("+ct[0]+")" in s:
                        s1 = s
                    if "start("+ct[1]+")" in s:
                        s2 = s
                    if s1 != -1 and s2 != - 1: #if they do, combine them.
                        s3 = s1.union(s2) # union

                if s1 != -1 and s2 != -1 and s3 != -1: #for every ct, if we have combined state, we update states_per_transition_set
                    if s1 in states_per_transition_set[fsm_no]:
                        states_per_transition_set[fsm_no].remove(s1)
                    if s2 in states_per_transition_set[fsm_no]:
                        states_per_transition_set[fsm_no].remove(s2)
                    states_per_transition_set[fsm_no].add(s3)

            ## build a state machine now.
            fsm_graph = nx.DiGraph()

            for state in states_per_transition_set[fsm_no]:
                fsm_graph.add_node(state)

            # transition_df is defined above. Add edges from transitions.
            # print_table(transition_df)
            for i in range(transition_df.shape[0]):
                for j in range(transition_df.shape[1]):
                    if transition_df.iloc[i, j] != 'hole':
                        if transition_df.iloc[i, j] > 0:
                            for node in fsm_graph.nodes():
                                starting_node, ending_node = -1,-1
                                if "end("+transition_df.index[i]+")" in node:
                                    starting_node = node
                                if "start("+transition_df.columns[j]+")" in node:
                                    ending_node = node
                                if starting_node != -1 and ending_node != -1:
                                    if fsm_graph.has_edge(starting_node, ending_node):
                                        fsm_graph[starting_node][ending_node]['weight'] += transition_df.iloc[i, j]
                                    else:
                                        fsm_graph.add_edge(starting_node, ending_node, weight=transition_df.iloc[i, j], name=""+transition_df.index[i])

            df = nx.to_pandas_adjacency(fsm_graph, nodelist=fsm_graph.nodes(), dtype=int)
            # TODO: consider making a state dictionary for pretty print of frozen set
            nx.write_graphml(fsm_graph, "output/" + domain_name + "/" + class_names[index] + "_stateFSM_" + str(fsm_no+1)+ ".graphml")
            state_machines_per_class.append(df)

        state_machines_overall_list.append(state_machines_per_class)

    ###############  TODO: Step 2:ZERO ANALYSIS

    ############### Step 3: Induction of parameterised Finite State Machines
    ## Step 3 Input: action sequence Seq, Transition set TS, Object set Obs
    ## Output: HS retained hypotheses for state parameters
    ## 3.1 Form hypotheses from state machines
    print("*****************")
    print("Step 3: Induction of Parameterised Finite State Machines")
    HS_list = []
    for index, fsms_per_class in enumerate(state_machines_overall_list):
        class_name = class_names[index]
        print("CLASS:"+ class_name)
        for fsm_no, fsm in enumerate(fsms_per_class):
            print("FSM:" + str(fsm_no + 1))
            print_table(fsm)

        print("\nTransition set of this class:")
        print(transition_sets_per_class[index])

        # Hypothesis set per class.
        HS_per_class = []
        for fsm_no, transition_set in enumerate(transition_sets_per_class[index]):
            transition_df = adjacency_matrix_list[index].loc[list(transition_set), list(transition_set)]
            consecutive_transitions_state_machines_per_class = set()  # find consecutive transitions for a state machine in a class.
            for i in range(transition_df.shape[0]):
                for j in range(transition_df.shape[1]):
                    if transition_df.iloc[i, j] != 'hole':
                        if transition_df.iloc[i, j] > 0:
                            consecutive_transitions_state_machines_per_class.add((transition_df.index[i], transition_df.columns[j]))

            # Step 3.1 for each pair <B.k and C.l> of consecutive transitions in transition set of a state machine.
            # store hypothesis in Hypothesis set
            HS = set()
            for ct in consecutive_transitions_state_machines_per_class:
                B = ct[0].split('.')[0] # action name of T1
                k = int(ct[0].split('.')[1]) # argument index of T1

                C = ct[1].split('.')[0] # action name of T2
                l = int(ct[1].split('.')[1]) # argument index of T2

                # When both actions B and C contain another argument of the same sort G' in position k' and l' respectively, we hypothesise that there may be a relation between sorts G and G'.
                for seq in sequences:
                    for actarg_tuple in seq:
                        arglist1 = []
                        arglist2 = []
                        if actarg_tuple[0] == B: #if action name is same as B
                            arglist1 = actarg_tuple[1].copy()
                            arglist1.remove(actarg_tuple[1][k]) # remove k from arglist
                            for actarg_tuple_prime in seq: #loop through seq again.
                                if actarg_tuple_prime[0] == C:
                                    arglist2 = actarg_tuple_prime[1].copy()
                                    arglist2.remove(actarg_tuple_prime[1][l]) # remove l from arglist

                            # for arg lists of actions B and C, if class is same add a hypothesis set.
                            for i in range(len(arglist1)):
                                for j in range(len(arglist2)):
                                    class1 = get_class_index(arglist1[i], classes)
                                    class2 = get_class_index(arglist2[j], classes)
                                    if class1 == class2:
                                        HS.add((frozenset({"end("+B+"."+ str(k)+")", "start("+C+"."+str(l)+")"}),B,k,i,C,l,j,index,class1))

            ####### Step 3.2 Test Hypothesis against example sequences!!
            # Check hypothesis against sequences.
            ## It performs an inductive process such that the hypotheses can be either refuted or retained according to the example sequence, but it can never be definitely confirmed.
            ## Requires more data than usual.
            HS_copy = HS.copy()
            for hs in HS:
                # for every consecutive transision for a state machine per class.
                for ct in consecutive_transitions_state_machines_per_class:
                    A_p = ct[0].split('.')[0]
                    m = int(ct[0].split('.')[1])

                    A_q = ct[1].split('.')[0]
                    n = int(ct[1].split('.')[1])

                    if A_p == hs[1] and m == hs[2] and A_q == hs[4] and n == hs[5]:
                        k_prime = hs[3]
                        l_prime = hs[6]
                        for seq in sequences:
                            for actarg_tuple in seq:
                                arglist1 = []
                                arglist2 = []
                                if actarg_tuple[0] == A_p:
                                    arglist1 = actarg_tuple[1].copy()
                                    arglist1.remove(actarg_tuple[1][m])  # remove k from arglist
                                    for actarg_tuple_prime in seq:
                                        if actarg_tuple_prime[0] == A_q:
                                            arglist2 = actarg_tuple_prime[1].copy()
                                            arglist2.remove(actarg_tuple_prime[1][n])  # remove l from arglist

                                    class1, class2 = -1,-1
                                    if k_prime < len(arglist1) and l_prime < len(arglist2):
                                        class1 = get_class_index(arglist1[k_prime], classes)
                                        class2 = get_class_index(arglist2[l_prime], classes)

                                    # Refute the hypothesis if classes are not same at the location specified by hypothesis.
                                    if class1 != -1 and class2!=-1 and class1 != class2:
                                        if hs in HS_copy:
                                            HS_copy.remove(hs)



            HS_per_class.append(HS_copy)
        HS_list.append(HS_per_class)


    ## printing hypothesis
    # print("\n****** HYPOTHESIS SET*********")
    # for HS_per_class in HS_list:
    #     for HS_per_fsm in HS_per_class:
    #         for h in HS_per_fsm:
    #             print(h)

    ########### Step 4: Creation and merging of state parameters
    print("Step 4: creating and merging state params")
    param_bindings_list_overall = []
    for classindex, HS_per_class in enumerate(HS_list):
        param_bind_per_class = []
        for HS_per_fsm in HS_per_class:
            param_binding_list = []
            for index,h in enumerate(HS_per_fsm):
                param_binding_list.append((h,"v"+str(index)))

            for i in range(len(param_binding_list)-1):
                for j in range(i+1, len(param_binding_list)):
                    h_1 = param_binding_list[i][0]
                    h_2 = param_binding_list[j][0]

                    if (h_1[0] == h_2[0] and h_1[1] == h_2[1] and h_1[2] == h_2[2] and h_1[3] == h_2[3]) or (h_1[0] == h_2[0] and h_1[4] == h_2[4] and h_1[5] == h_2[5] and h_1[6] == h_2[6]):
                        new_tuple = (param_binding_list[j][0], param_binding_list[i][1])
                        param_binding_list.remove((param_binding_list[j][0], param_binding_list[j][1]))
                        param_binding_list.insert(j,new_tuple)
            param_bind_per_class.append(param_binding_list)
        param_bindings_list_overall.append(param_bind_per_class)


    ########### Step 5: Removing parameter flaws
    # A parameter P associated with an FSM state S is said to be flawed if there exists a transition into S, which does not supply P with a value.
    # This may occur when there exists a transition B.k where end(B.k)=S, but there exists no h containing end(B.k)

    para_bind_overall_fault_removed = []
    for class_index, para_bind_per_class in enumerate(param_bindings_list_overall):
        print(class_names[class_index])
        para_bind_per_class_fault_removed = []

        # print(state_machines_overall_list[class_index][fsm_index].index.values)
        for fsm_index, transition_set in enumerate(transition_sets_per_class[class_index]):
            transition_df = adjacency_matrix_list[class_index].loc[list(transition_set), list(transition_set)]
            consecutive_transitions_state_machines_per_class = set()  # find consecutive transitions for a state machine in a class.
            for i in range(transition_df.shape[0]):
                for j in range(transition_df.shape[1]):
                    if transition_df.iloc[i, j] != 'hole':
                        if transition_df.iloc[i, j] > 0:
                            consecutive_transitions_state_machines_per_class.add(
                                (transition_df.index[i], transition_df.columns[j]))

            # initialize h_exists with false
            h_exists = []
            for param_index, param_bind in enumerate(para_bind_per_class[fsm_index]):
                h_exists.append(False)

            for ct in consecutive_transitions_state_machines_per_class:
                for state in state_machines_overall_list[class_index][fsm_index].index.values:
                    if {"end("+ ct[0] + ")"} <= state:
                        current_state = state

                        # for every parameter binding which contains subset of current_state, if B and k are there, hypothesis exists
                        for param_index,param_bind in enumerate(para_bind_per_class[fsm_index]):
                            if param_bind[0][0] <= current_state: #subset of current_state of FSM
                                # print(param_bind[0][1])
                                # print(param_bind[0][2])
                                # print(ct[0].split('.')[0])
                                # print(ct[0].split('.')[1])
                                # print()
                                if param_bind[0][1] == ct[0].split('.')[0]:
                                    if param_bind[0][2] == int(ct[0].split('.')[1]): #TODO: Do we need to check other things here
                                        h_exists[param_index] = True

            param_bind_per_fsm_copy = para_bind_per_class[fsm_index].copy()
            for param_index, param_bind in enumerate(para_bind_per_class[fsm_index]):
                # if h_exists[param_index]:
                #     print(param_bind[1])
                if not h_exists[param_index]:
                    param_bind_per_fsm_copy.remove(param_bind)

            para_bind_per_class_fault_removed.append(param_bind_per_fsm_copy)
        para_bind_overall_fault_removed.append(para_bind_per_class_fault_removed)

    # printing para bindings
    print("Fault Removed Parameter Bindings")
    for class_index, para_bind_per_class in enumerate(para_bind_overall_fault_removed):
        print(class_names[class_index])
        for fsm_no, para_bind_per_fsm in enumerate(para_bind_per_class):
            print("Fsm_no:" + str(fsm_no))
            for p in para_bind_per_fsm:
                print(p)

    ############## TODO: Nice to have Step 6: Specify static conditions


    ############## Step 7: Formation of PDDL Schema.
    # get action schema
    print("********************PDDL output******************")
    output_file = "output/"+ domain_name + "/" +  domain_name + ".pddl"
    write_file = open(output_file, 'w')
    write_line = "(define\n"
    write_line += "\t(domain "+ domain_name+")\n"
    write_line += "\t(:requirements :typing)\n"
    write_line += "\t(:types"
    for class_name in class_names:
        write_line += " " + class_name
    write_line += ")\n"
    write_line += "\t(:predicates\n"

    state_dict_per_class = []
    predicates = []
    for class_index, para_bind_per_class in enumerate(para_bind_overall_fault_removed):

        state_dict_per_fsm = []
        for fsm_no, para_bind_per_fsm in enumerate(para_bind_per_class):

            state_dictionary = {}
            for state_index, state in enumerate(state_machines_overall_list[class_index][fsm_no]):
                predicate = ""
                write_line += "\t\t(" + class_names[class_index] + "_fsm" + str(fsm_no) + "_state" + str(state_index)
                predicate += "\t\t(" + class_names[class_index] + "_fsm" + str(fsm_no) + "_state" + str(state_index)
                state_dictionary[state_index] = state
                for para_bind in para_bind_per_fsm:
                    if para_bind[0][0] <= state:
                        write_line += " ?"+para_bind[1] + " - " + str(class_names[para_bind[0][8]])
                        predicate += " ?"+para_bind[1] + " - " + str(class_names[para_bind[0][8]])
                write_line += ")\n"
                predicate += ")"
                predicates.append(predicate)
            state_dict_per_fsm.append(state_dictionary)
        state_dict_per_class.append(state_dict_per_fsm)

    for action_index, action in enumerate(actions):
        write_line += "\t(:action\n"
        write_line += "\t" + action + "\n"
        write_line += "\t:parameters\n"
        write_line += "\t("
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

        print(args_per_action)


        # need to use finite STATE machines to get preconditions and effects.
        # Start-state = precondition. End state= Effect
        preconditions = []
        effects = []
        for arglist in params_per_action:
            for arg in arglist:
                current_class_index = get_class_index(arg, classes)
                for fsm_no, fsm in enumerate(state_machines_overall_list[current_class_index]):
                    # print_table(fsm)
                    df = fsm

                    for i in range(df.shape[0]):
                        for j in range(df.shape[1]):
                            if df.iloc[i, j] > 0:
                                # print("(" + df.index[i] + "," + df.columns[j] + ")")
                                start_state = df.index[i]
                                end_state = df.columns[j]

                                start_state_index, end_state_index = -1, -1
                                for k,v in state_dict_per_class[current_class_index][fsm_no].items():
                                    if v == start_state:
                                        start_state_index = k
                                    if v == end_state:
                                        end_state_index = k

                                for predicate in predicates:
                                    pred = predicate.split()[0].lstrip('(').rstrip(')')
                                    if pred == class_names[current_class_index]+"_fsm"+str(fsm_no)+"_state"+str(start_state_index):
                                        if predicate not in preconditions:
                                            preconditions.append(predicate)
                                    if pred == class_names[current_class_index]+"_fsm"+str(fsm_no)+"_state"+str(end_state_index):
                                        if predicate not in effects:
                                            effects.append(predicate)





        write_line += "\t:precondition\n"
        write_line += "\t(and\n"
        for precondition in preconditions:
            # precondition = precondition.replace(?)
            write_line += "\t\t"+precondition+"\n"
        write_line += "\t)\n"
        write_line += "\t:effect\n"
        write_line += "\t(and\n"
        for effect in effects:
            write_line += "\t\t" + effect + "\n"
        write_line += "\t)"

        write_line += ")\n"




    print(write_line)

    write_file.write(write_line)
    write_file.close()





    ############ TODO: Step 8: Intial and final states in terms of actions.






































































