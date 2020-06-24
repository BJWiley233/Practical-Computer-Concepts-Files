# -*- coding: utf-8 -*-
"""
Created on Wed Jan  2 01:15:43 2019

@author: bjwil
"""
import random
import copy

sign = '->'

answer = '6->8->7->9->6->5->4->2->1->0->3->2->6'

with open ('Eulerian_Cycle.txt', 'r') as in_file:
    lines = in_file.read().split('\n')
    #s = lines[1]
    #n = int(lines[0])
    
edict1 = {}

for connection in lines:
    connection = connection.replace(" ", "")
    edict1[connection.split('->')[0]] = [v for v in connection.split('->')[1].split(',')]

    
def generate_edges(graph):
    edges = []
    for node in graph:
        for neighbour in graph[node]:
            edges.append((node, neighbour))

    return edges

graph = generate_edges(edict1)



def cycle(edict):
    dict_copy = copy.deepcopy(edict)
    path = ''
    #start = start_key
    start = random.choice(list(dict_copy.keys()))
    path = path + (start + sign)
    while start in dict_copy:
        next_ = random.choice(dict_copy[start])
        path = path + (next_ + sign)
        dict_copy[start].remove(next_)
        if dict_copy[start] == []:
            dict_copy.pop(start, 'already popped')
        start = next_
    path = path[:-2]
    return bool(dict_copy), path, dict_copy, edict


test = cycle(edict1)
while test[0]:
    test = cycle(edict1)
    final = test[1]
print(test[1])

    

with open('Output8.txt', 'w') as f:
        f.write(final)

