import sys
import json

from pprint import pprint

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

temp2 = []

for k in temp:
    if temp[k] not in temp2:
        temp2.append(temp[k])

pprint(len(temp2))
print len(temp)

g = open(sys.argv[2], 'w')
g.write(json.dumps({'name': 'clones', 'children': [{'name': i, 'children': list(temp[i]) } for i in temp]}))
g.close()
