import os

domain_name = "miconic"
folder_path = "./"+domain_name+"/"
write_file_path = domain_name + ".txt"

for the_file in folder_path:
    file_path = folder_path + the_file
    print(file_path)
# file = open(file_path, 'r')
# write_file = open(write_file_path,'w')
# write_line = ''
# for line in file:
#     action_def = line.rstrip("\n\r").lstrip("\n\r").lower()
#
#     if len(action_def) > 0 :
#         csv_line = action_def.replace(' ',', ')
#         line = csv_line.replace(', ','(',1)
#         line = line + ')'
#     write_line += line
# write_line = write_line.replace(')','), ')
# write_line = write_line.rstrip(', \n\r')
# write_line = write_line + '\n'
# print(write_line)
# write_file.write(write_line)
#
# file.close()
# write_file.close()


