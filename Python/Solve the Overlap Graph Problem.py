# -*- coding: utf-8 -*-
"""
Created on Tue Dec 25 00:20:52 2018

@author: bjwil
"""

import os
import itertools

os.getcwd()

#os.chdir('C:\\Users\\bjwil\\Bioinformatics')

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]



sign = ' -> '
with open ('dataset_198_10.txt', 'r') as in_file:
    lines = in_file.read().split()
    #s = lines[1]
    #k = int(lines[0])
patterns = lines
def Overlap_Graph(patterns):
    adjacent_list = {}
    final_list = []
    for nodes in patterns:
        adjacent_list[nodes] = []
    for string in adjacent_list:
        for node in patterns:
            if string[1:] == node[:-1]:
                adjacent_list[string].append(node)
    
    for k, v in adjacent_list.items():
        if adjacent_list[k]:
            final_list.append(str(k) + sign + ', '.join('{}'.format(v) for v in adjacent_list[k]))
            #print(str(k) + sign + ', '.join('{}'.format(v) for v in adjacent_list[k]))

    return final_list

strings = Overlap_Graph(patterns)




'''
idx = 0
item = lines[0]
while len(lines) > 0:   
    for idx,item in enumerate(lines[:-1]):
        if lines[idx][-len(item)+1:] == lines[idx+1][0:len(item)-1]: 
            genome_string = genome_string + lines[idx+1][-1]
            
'''   



