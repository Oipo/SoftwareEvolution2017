import sys
import json

output = []
temp = {}
f = open(sys.argv[1], 'r')

for line in f:
    l = line.split('|')

    if len(l) == 5:
        if l[0] in temp:
            temp[l[0]].append(l[1])
        else:
            temp[l[0]] = [l[1]]

f.close()

g = open(sys.argv[2], 'w')
g.write(json.dumps([{'name': j, 'imports': temp[i]} for i in temp for j in temp[i]]))
g.close()
