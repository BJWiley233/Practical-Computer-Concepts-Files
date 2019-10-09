# -*- coding: utf-8 -*-
"""
Created on Wed Jan  2 05:54:57 2019

@author: bjwil
"""


import networkx as nx
import matplotlib.pyplot as plt

sign = '->'


with open ('last.txt', 'r') as in_file:
    lines = in_file.read().split('\n')

edict = {}

for connection in lines:
    connection = connection.replace(" ", "")
    edict[connection.split('->')[0]] = [v for v in connection.split('->')[1].split(',')]

def generate_edges(graph):
    edges = []
    for node in graph:
        for neighbour in graph[node]:
            edges.append((node, neighbour))

    return edges

graph = generate_edges(edict)

G = nx.DiGraph(edict)
out_degrees = G.out_degree([node for node in G])
in_degrees = G.in_degree([node for node in G])
ds = [out_degrees, in_degrees]
d = {}
for k in out_degrees.keys():
    d[k] = tuple(d[k] for d in ds)
for key in d:
    d[key] = d[key][0] - d[key][1]
extra_out = [key  for (key, value) in d.items() if value == 1][0]
extra_in = [key  for (key, value) in d.items() if value == -1][0]

G.add_edge(extra_in, extra_out)

nx.is_eulerian(G)
euler = list(nx.eulerian_circuit(G, source = extra_out))
index = euler.index((extra_in, extra_out))
blah = euler[index+1:] + euler[:index-1] 
blah.append((euler[:index-1][-1][1], extra_in))


path = blah[0][0] + sign + blah[0][1]
for line in blah[1:]:
    path = path + (sign + line[1])

with open('Output10.txt', 'w') as f:
        f.write(path)

nx.draw_networkx(G, arrows=True)
