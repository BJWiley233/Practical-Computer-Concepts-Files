# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 07:31:50 2019

@author: bjwil
"""

with open('dataset_203_2.txt', 'r') as file:
    graph = dict((line.strip().split(' -> ') for line in file))
    for key in graph:
        graph[key] = [graph[key].split(',')]
        
for v in graph:
    graph[v].append([len(graph[v][0]), 0])

for v in graph:
    for e in graph[v][0]:
        graph[e][1][1] += 1



vio_same = all([all(inout == graph[v][1][0] for inout in graph[v][1]) for v in graph])

circ = []
stack = []
v=next(iter(graph))


while (graph[v][0] or stack):
    if not graph[v][0]:
        circ.append(v)
        v = stack.pop()
    else:
        stack.append(v)
        v = graph[v][0].pop()



with open('test_euler_out.txt', 'w') as file:
    file.write("->".join(reversed(circ)) + '->' + circ[-1])
        


    


'''           
Start with an empty stack and an empty circuit (eulerian path).
- If all vertices have same out-degrees as in-degrees - choose any of them.
- If all but 2 vertices have same out-degree as in-degree, and one of those 2 vertices has out-degree with one greater than its in-degree, and the other has in-degree with one greater than its out-degree - then choose the vertex that has its out-degree with one greater than its in-degree.
- Otherwise no euler circuit or path exists.
If current vertex has no out-going edges (i.e. neighbors) - add it to circuit, 
remove the last vertex from the stack and set it as the current one. Otherwise 
(in case it has out-going edges, i.e. neighbors) - add the vertex to the stack, 
take any of its neighbors, remove the edge between that vertex and selected neighbor, 
and set that neighbor as the current vertex.
Repeat step 2 until the current vertex has no more out-going edges (neighbors) and the stack is empty.
'''


        
        
    


