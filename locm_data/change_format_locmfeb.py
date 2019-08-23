import os
file_path = "../locmfeb/ex/blocks_04.pl"
write_file_path = "blocks_04_1.txt"

file = open(file_path, 'r')
write_file = open(write_file_path,'w')
write_line = ''

start_flag = False
end_flag = False
new_seq_flag = False
for line in file:


    if start_flag and not end_flag:
        if "[" in line:
            continue
        if "]" in line:
            l = line.replace('],','')
        else:
            l = line.rstrip("\n\r").lstrip("\n\r").lower()
        # print(line)
        write_line += l


    if "Training" in line:
        start_flag = True
        end_flag = False
    if start_flag and '],' in line:
        end_flag = True
        start_flag = False



write_line = write_line.replace(',', ', ')
print(write_line)
write_file.write(write_line)

file.close()
write_file.close()

