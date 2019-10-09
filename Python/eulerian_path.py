# -*- coding: utf-8 -*-
"""
Created on Wed Jan  2 05:54:57 2019

@author: bjwil
"""


import networkx as nx
import matplotlib.pyplot as plt
import sys
from sys import stdin, stderr, stdout, exit

sign = '->'


'''with open ('test5.txt', 'r') as in_file:
    lines = in_file.read().split('\n')
'''
'''fin = open('bruijn3.txt', 'r')
fout=open('output7.txt', 'w')
reads=[]
for line in fin.readlines():
    reads.append(line.replace('\n',''))
reads = reads[1:]'''

def debruijn_Graph(reads):
    patterns=[]
    smegnosty={}
    for r in reads:
        prefix=r[:-1]
        suffix=r[1:]
        if not(prefix in patterns):
            patterns.append(prefix)
        #if not(suffix in patterns):
            #patterns.append(suffix)
    for pattern in patterns:
        smegnosty[pattern]=[]
    for r in reads:
        smegnosty[r[:-1]].append(r[1:])
    
    text = [] 
    for key in sorted(smegnosty):
        if not(smegnosty[key]==[]):
            text.append(key+" -> "+','.join(smegnosty[key]))
    return text



def debruijn_prepare_eulerian(smegnosty):
    edict = {}
    for connection in smegnosty:
        connection = connection.replace(" ", "")
        edict[connection.split('->')[0]] = [v for v in connection.split('->')[1].split(',')]
    
    return edict



'''def generate_edges(graph):
    edges = []
    for node in graph:
        for neighbour in graph[node]:
            edges.append((node, neighbour))

    return edges

graph = generate_edges(edict)
'''
def get_eulerian(edict):
    G = nx.DiGraph(edict)
    if (not nx.is_eulerian(G)):
        out_degrees = G.out_degree([node for node in G])
        in_degrees = G.in_degree([node for node in G])
        ds = [out_degrees, in_degrees]
        d = {}
        out_degree_dict = dict(out_degrees)
        for k in out_degree_dict.keys():
            d[k] = tuple(d[k] for d in ds)
        for key in d:
            d[key] = d[key][0] - d[key][1]
        extra_out = [key  for (key, value) in d.items() if value == 1][0]
        extra_in = [key  for (key, value) in d.items() if value == -1][0]
        
        G.add_edge(extra_in, extra_out)
    
    
        euler = list(nx.eulerian_circuit(G, source = extra_out))
        index = euler.index((extra_in, extra_out))
        #blah = euler[index+1:] + euler[:index-1] 
        blah = euler[index+1:] + euler[:index]
        #blah.append((euler[:index-1][-1][1], extra_in))
    
        path = []
        path = blah[0][0] + sign + blah[0][1]
        for line in blah[1:]:
            path = path + (sign + line[1])
    else:
        eulerian = list(nx.eulerian_circuit(G))
        path = eulerian[0][0] + sign + eulerian[0][1]
        for line in eulerian[1:]:
            path = path + (sign + line[1])
            
    return path

def eulerian_to_genome(text_for_genome):
    splits = text_for_genome.split('->')
    genome = splits[0]
    for i in range(1, len(splits)):
        genome += splits[i][-1]
    return genome





def StringReconstruction(reads):
    smegnosty = debruijn_Graph(reads) 
    text_for_genome = get_eulerian(debruijn_prepare_eulerian(smegnosty))
    genome = eulerian_to_genome(text_for_genome)
    
    return genome

#fin = open(stdin)
#fout=open(stdout, 'w')
reads=[]
for line in stdin.readlines():
#for line in fin.readlines():
    reads.append(line.replace('\n',''))
reads = reads[1:]
    
genome = StringReconstruction(reads)

#fout.write(genome)
stdout.write(genome)
#fin.close()
#fout.close()

#nx.draw_networkx(G, arrows=True)
