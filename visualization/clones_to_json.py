import json
import pprint

output = []
temp = {}
f = open('test', 'r')

for line in f:
    l = line.strip()[1:-1].split('|')

    if len(l) == 5:
        if l[1] in temp:
            temp[l[1]].add(l[3])
        else:
            temp[l[1]] = set([l[3]])

f.close()

# pprint.pprint(temp)

g = open('out.json', 'w')

g.write(json.dumps([{'name': i, 'imports': list(temp[i]) } for i in temp]))
