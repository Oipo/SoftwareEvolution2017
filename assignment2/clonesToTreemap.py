import sys
import json

output = []
temp = {}
f = open(sys.argv[1], 'r')

for line in f:
    l = line.split('|')

    if len(l) == 9:
        if l[1] + l[2] in temp:
            temp[l[1] + l[2]].add((l[3], l[7]))
        else:
            temp[l[1] + l[2]] = set([(l[1], l[5]), (l[3], l[7])])

f.close()

temp2 = []

# remove duplicates
for k in temp:
    if temp[k] not in temp2:
        temp2.append(temp[k])

g = open(sys.argv[2], 'w')
g.write(json.dumps({'name': 'clones', 'children': [{'name': "class" + str(i), 'children': [{'name': x[0].split('/')[-1][:-5], 'size': int(x[1])} for x in temp2[i]]} for i in range(len(temp2))]}))
g.close()
