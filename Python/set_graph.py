# -*- coding: utf-8 -*-
"""
Created on Sun Oct 13 23:59:33 2019

@author: bjwil
"""
from collections import OrderedDict
import heapq
from queue import PriorityQueue
class Graph():
    
    def __init__(self, directed=False):
        self.directed = directed
        self.V = []
        self.E = OrderedDict()
        self.sets = []
        self.Adj = {}
        
    def insert_vertices(self, vertices):
        for v in vertices:
            self.V.append(v)
            
    def insert_edges(self, edges):
        for k,v in edges.items():
            if k[0] not in self.V:
                self.V.append(k[0])
            if k[1] not in self.V:
                self.V.append(k[1])    
            self.E[k] = v
            self.E[(k[1],k[0])] = v
            if k[0] not in self.Adj:
                self.Adj[k[0]] = [k[1]]
            else:
                self.Adj[k[0]].append(k[1])
            if k[1] not in self.Adj:
                self.Adj[k[1]] = [k[0]]
            else:
                self.Adj[k[1]].append(k[0])
            
    def make_set(self, v):
        self.sets.append(set({v}))
        return
    

    def find_set(self, v):
        for set_ in self.sets:
            if v in set_:
                return set_

    def union(self, u, v):
        u.update(v)
        self.sets = [i for i in self.sets if (i != v)]

    
    def conn_comp(self):
        for v in self.V:
            self.make_set(v)  
        
        for edge in self.E:
            u, v = edge[0], edge[1]
            set_u = self.find_set(u)
            set_v = self.find_set(v)
            if set_u != set_v:
                self.union(set_u, set_v)
    
    def w(self, a,b):
        return self.E[(a,b)]
    
    def mst_kruskal(self):
        A = set()
        for vertex in self.V:
            self.make_set(vertex)
        self.E = OrderedDict(sorted(self.E.items(), key=lambda kv: kv[1]))
        for edge in self.E:
            print(edge[0].value, edge[1].value, self.w(edge[0],edge[1]))
        #for edge in self.E:
            #print(self.find_set(edge[0][0]), self.find_set(edge[0][1]))
    
    def mst_prim(self, r):
        r.key = 0
        q = []
        for v in self.V:
            heapq.heappush(q, v)
        while q:
            u = heapq.heappop(q)
            for v in self.Adj[u]:
                #print(u.value, v.value)
                #for k, v in self.E.items():
                    #print((k[0].value, k[1].value))
                if v in q and self.w(u, v) < v.key:
                    v.p = u
                    v.key = self.w(u,v)
                    heapq.heapify(q)
        
        
        return
            
class Node():
    
    def __init__(self, value, key, p):
        self.value = value
        self.key = key
        self.p = p
    
    def __lt__(self, other):
        return self.key < other.key
        
            
if '__main__' == __name__:           
    G = Graph()
    a = Node('a', float('inf'), None)
    b = Node('b', float('inf'), None)
    c = Node('c', float('inf'), None)
    d = Node('d', float('inf'), None)
    e = Node('e', float('inf'), None)
    f = Node('f', float('inf'), None)
    g = Node('g', float('inf'), None)
    h = Node('h', float('inf'), None)
    i = Node('i', float('inf'), None)

    q = []
    heapq.heappush(q, b)
    heapq.heappush(q, a)
    a.key = 0
    heapq.heapify(q)
    test = heapq.heappop(q)
    test.value
    test.key
    test1 = heapq.heappop(q)
    test1.value
    test1.key
    
    G.insert_vertices([a,b,c,d,e,f,g,h,i])
    edges = {(a,b):4, (b,c):8, (c,d):7, (d,e):9, (e,f):10,
             (d,f):14, (c,f):4, (c,i):2, (i,g):6, (h,g):1,
             (g,f):2, (b,h):11, (a,h):8}
    G.insert_edges(edges)
    G.mst_prim(a)

    for v in G.V:
        print(v.value, end=', ')
        if v.p is not None:
            print(v.p.value)
        else:
            print(v.p)
            

