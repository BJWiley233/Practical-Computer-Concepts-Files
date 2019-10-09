# -*- coding: utf-8 -*-
"""
Created on Tue Dec 25 00:20:52 2018

@author: bjwil
"""



sign = ' -> '


def bruijn_graph(lines):
    Debruin_list = {}
    Debruin_list2 = {}
    final_list = []
    for nodes in lines:
        Debruin_list[nodes] = {}
        Debruin_list[nodes][nodes[:-1]] = []
    for string in Debruin_list:
        for i in range(sum(string in s for s in lines)):
            for node in lines:
                if (string[1:] == node[:-1] and
                    len(Debruin_list[string][string[:-1]]) <
                    sum(string in s for s in lines)):
                    Debruin_list[string][string[:-1]].append(node[:-1])
                    
    for string in Debruin_list:
        Debruin_list2[[key for key in Debruin_list[string]][0]] = []
    for string in Debruin_list:
        for value in Debruin_list[string][string[:-1]]:
            Debruin_list2[[key for key in Debruin_list[string]][0]].append(Debruin_list[string][string[:-1]][0])


    TGCCCCTTACGA': ['TAACCATGCCCCTTACGAC'],
 'TAACCATGCCCCTTACGAC': ['AACCATGCCCCTTACGACC'],

    for k, v in sorted(Debruin_list2.items()):
        if Debruin_list2[k]:
            final_list.append(str(k) + sign + ','.join('{}'.format(v) for v in sorted(Debruin_list2[k])))

    return final_list


# https://stepik.org/api/attempts/78614536/file
with open ('dataset_200_8.txt', 'r') as in_file:
    lines = in_file.read().split()
    #s = lines[1]
    #n = int(lines[0])
    

strings = bruijn_graph(lines)

with open('Output5.txt', 'w') as f:
    for item in strings:
        f.write("%s\n" % item)




