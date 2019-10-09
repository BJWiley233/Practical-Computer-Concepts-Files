# -*- coding: utf-8 -*-
"""
Created on Mon Aug 19 22:30:11 2019

@author: bjwil
"""

#import pandas as pd
import numpy as np
from collections import OrderedDict

class Graph(object):
    
    def __init__(self, graph_dict=None, directed = True):
        if graph_dict == None:
            graph_dict = OrderedDict()
        self.graph_dict = graph_dict
        if directed == None:
            self.directed == True
        self.directed = directed
        self.time = 0
        
        
    def vertices(self):
        
        return self.graph_dict.keys()
    
    
    def edges(self):
        
        return self.generate_edges()
    
    
    def add_vertex(self, vertex):
        if vertex not in self.graph_dict:
            self.graph_dict[vertex] = []
    
    
    def add_edge(self, from_vertex, to_vertex):
        if not self.directed:
            if from_vertex not in self.graph_dict:
                self.graph_dict[from_vertex] = [to_vertex]
            else:
                self.graph_dict[from_vertex].append(to_vertex)
            if to_vertex not in self.graph_dict:
                self.graph_dict[to_vertex] = [from_vertex]
            else:
                self.graph_dict[to_vertex].append(from_vertex)
        else:
            if from_vertex not in self.graph_dict:
                self.graph_dict[from_vertex] = {'edges' : [to_vertex]}
            else:
                self.graph_dict[from_vertex]['edges'].append(to_vertex)
            if to_vertex not in self.graph_dict:
                self.graph_dict[to_vertex] = {"edges" : []}
        self.adj_mat()
        
    
    def generate_edges(self):
        edges = []
        [edges.append((vertex, edge)) for vertex, edge_list in 
         self.graph_dict.items() for edge in edge_list['edges']]
        
        return edges
     
           
    def string(self):
        print("vertices:")
        for k in self.graph_dict.keys():
            print(k, end = " ")
        print("\nedges:")
        print(self.generate_edges())
        
        
    def adj_mat(self):
        mat = np.zeros(shape = (len(self.graph_dict), len(self.graph_dict)))
        for a, b in [(list(self.graph_dict).index(a), 
                      list(self.graph_dict).index(b)) for a, row in
                     self.graph_dict.items() for b in row['edges']]:
            mat[a, b] = 2 if (a==b and not self.directed) else 1
        self.adj_matrix = mat
        
        return mat
    
    
    def bfs(self, s):
        self.graph_dict['s']['parent'] = []
        visited = []   
        queue = [list(self.graph_dict).index(s)]
        while queue:
            pop = queue.pop(0)
            if pop not in visited:
                visited.append(pop)
            for i in list(np.where(self.adj_matrix[pop] >= 1)[0]):
                if i not in queue:
                    self.graph_dict[list(self.graph_dict)[i]]['parent'] = [list(self.graph_dict)[pop]]
            [queue.append(i) for i in list(np.where(self.adj_matrix[pop] == 1)[0]) if i not in queue]    
            
        return [list(self.graph_dict)[i] for i in visited]
    
    
    def dfs_visit(self, u):
        self.time += 1
        self.graph_dict[u]['time'] = [self.time]
        self.graph_dict[u]['color'] = 'gray'
        for edge in self.graph_dict[u]['edges']:
            if self.graph_dict[edge]['color'] == 'white':
                self.graph_dict[edge]['parent'] = u
                self.dfs_visit(edge)
        self.graph_dict[u]['color'] = 'black'
        self.time += 1
        self.graph_dict[u]['time'].append(self.time)
        return

    def dfs(self, vertex_start):
        self.graph_dict.move_to_end(vertex_start, last = False)
        for vertex in self.graph_dict:
            self.graph_dict[vertex]['color'] = "white"
            self.graph_dict[vertex]['parent'] = None
        self.time = 0
        for vertex in self.graph_dict:
            if self.graph_dict[vertex]['color'] == "white":
                self.dfs_visit(vertex)
    
    def path(self, s, v):
        if v == s:
            print(s)
        elif not self.graph_dict[v]['parent']:
            print("no path from {} to {}".format(s, v))
        else:
            self.path(s, self.graph_dict[v]['parent'][0])
            print(v)
        
'''
graph = Graph(None, directed=True)
graph.add_edge("s", "w");
graph.add_edge("s", "r");
graph.add_edge("r", "v");
graph.add_edge("w", "t");
graph.add_edge("w", "x");
graph.add_edge("t", "x");
graph.add_edge("t", "u");
graph.add_edge("x", "u");
graph.add_edge("x", "y");
graph.add_edge("u", "y");
graph.generate_edges()
graph.string()
G = graph.graph_dict
graph.adj_mat()
graph.bfs('s')
'''
'''
graph.adj_matrix
graph.path('s', 'y')
graph.path('t', 'v')
'''

'''
dFSGraph = Graph()
dFSGraph.add_edge('S', 'Z');
dFSGraph.add_edge('Z', 'Y');
dFSGraph.add_edge('Y', 'X');
dFSGraph.add_edge('X', 'Z');
dFSGraph.add_edge('Z', 'W');
dFSGraph.add_edge('S', 'W');
dFSGraph.add_edge('T', 'V');
dFSGraph.add_edge('V', 'W');
dFSGraph.add_edge('V', 'S');
dFSGraph.add_edge('U', 'T');
dFSGraph.add_edge('T', 'U');
''' 
   
dFSGraph1 = Graph()
'''
dFSGraph1.add_edge('u', 'v');
dFSGraph1.add_edge('u', 'x');
dFSGraph1.add_edge('v', 'y');
dFSGraph1.add_edge('y', 'x');
dFSGraph1.add_edge('x', 'v');
dFSGraph1.add_edge('w', 'y');
dFSGraph1.add_edge('w', 'z');
dFSGraph1.add_edge('z', 'z');
dFSGraph1.adj_matrix
dFSGraph1.dfs()
'''

dFSGraph1.add_edge('Z', 'Y');
dFSGraph1.add_edge('Y', 'X');
dFSGraph1.add_edge('X', 'Z');
dFSGraph1.add_edge('Z', 'W');
dFSGraph1.add_edge('S', 'W');
dFSGraph1.add_edge('T', 'V');
dFSGraph1.add_edge('V', 'W');
dFSGraph1.add_edge('V', 'S');
dFSGraph1.add_edge('U', 'T');
dFSGraph1.add_edge('T', 'U');
dFSGraph1.add_edge('S', 'Z');
dFSGraph1.dfs('S')
A = dFSGraph1.adj_matrix
G = dFSGraph1.graph_dict
for vertex in G:
    print(vertex, " ", G[vertex])
'''
G.move_to_end('v', last = False)
G
'''