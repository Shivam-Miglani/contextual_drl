import os
file_path = "../locmfeb/ex/rocket.pl"
write_file_path = "rocket_locmfeb.txt"

file = open(file_path, 'r')
write_file = open(write_file_path,'w')
write_line = ''

for line in file:
    if "sequence_task" in line:
        line = line[line.find("[")+1:line.find("]")] + "\n"
        write_line += line


write_line = write_line.replace(',', ', ')
print(write_line)
write_file.write(write_line)

file.close()
write_file.close()

