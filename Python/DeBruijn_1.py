# -*- coding: utf-8 -*-
"""
Created on Tue Dec 25 00:20:52 2018

@author: bjwil
"""

import os
import itertools
import regex as re
import collections

os.getcwd()

#os.chdir('C:\\Users\\bjwil\\Bioinformatics')

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]



sign = ' -> '
with open ('dataset_199_6.txt', 'r') as in_file:
    lines = in_file.read().split()
    s = lines[1]
    n = int(lines[0])


def debruin1(s, n):
    Debruin_list = {}
    final_list = []
    for nodes in window(s, n-1):
        Debruin_list[nodes] = []
        #sorted(Debruin_list, key=Debruin_list.get)
    for string in Debruin_list:
        for node in window(s, n-1):
            if (string[1:] == node[:-1] and
                len(Debruin_list[string]) < 
                collections.Counter(re.findall(string, s, overlapped=True))[string]):
                    Debruin_list[string].append(node)
    
    for k, v in sorted(Debruin_list.items()):
        if Debruin_list[k]:
            final_list.append(str(k) + sign + ', '.join('{}'.format(v) for v in Debruin_list[k]))
            #print(str(k) + sign + ', '.join('{}'.format(v) for v in adjacent_list[k]))

    return final_list




strings = debruin1(s, n)

with open('Output3.txt', 'w') as f:
    for item in strings:
        f.write("%s\n" % item)


  

import networkx as nx
import matplotlib.pyplot as plt 

G = nx.MultiDiGraph()

G.add_edges_from(lines)

plt.figure(figsize=(8,8))
nx.draw(G)




