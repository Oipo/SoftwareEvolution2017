import sys
import json

output = []
temp = {}
f = open(sys.argv[1], 'r')

for line in f:
    l = line.split('|')

    if len(l) == 5:
        if l[1] in temp:
            temp[l[1]].add(l[3])
        else:
            temp[l[1]] = set([l[3]])

f.close()

g = open(sys.argv[2], 'w')
g.write(json.dumps([{'name': i, 'imports': list(temp[i]) } for i in temp]))
g.close()
