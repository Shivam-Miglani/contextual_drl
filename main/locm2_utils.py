from tabulate import tabulate
import itertools
import os



def findsubsets(S,m):
    return set(itertools.combinations(S, m))

def print_table(matrix):
    print(tabulate(matrix, headers='keys', tablefmt='psql'))

def print_sequences(sequences):
    for seq in sequences:
        print(seq)


def empty_directory(folder):
    for the_file in os.listdir(folder):
        file_path = os.path.join(folder, the_file)
        try:
            if os.path.isfile(file_path):
                os.unlink(file_path)
            # elif os.path.isdir(file_path): shutil.rmtree(file_path)
        except Exception as e:
            print(e)