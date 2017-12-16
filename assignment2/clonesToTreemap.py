import sys
import json

output = []
temp = {}
f = open(sys.argv[1], 'r')

for line in f:
    l = line.split('|')

    if len(l) == 5:
        x = {'name': l[1], 'size': l[3], 'cloneTag': 'codeclone' + l[0]}

        if l[0] in temp and l[1] not in [d['name'] for d in temp[l[0]]]:
            temp[l[0]].append(x)
        else:
            temp[l[0]] = [x]

f.close()

g = open(sys.argv[2], 'w')
g.write(json.dumps({'name': 'clones', 'children': [{'name': t, 'children': temp[t]} for t in temp]}))
g.close()
