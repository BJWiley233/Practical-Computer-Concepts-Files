# -*- coding: utf-8 -*-
"""
Created on Wed Oct 16 09:55:56 2019

@author: bjwil
"""

from string import ascii_lowercase

class Node():
    
    def __init__(self, x):
        self.p = x
        self.value = x
        self.rank = 0
        # for cicular linked list implementation
        # see https://gist.github.com/sometimescasey/3e3be1a4c2893d8995c2a704c898905f
        self.back = x

class Graph():
    
    def __init__(self, directed=False):
        self.directed = directed
        self.V = []
        self.E = []
        self.sets = {}
       
        
    def insert_vertices(self, vertices):
        for v in vertices:
            self.V.append(v)
       
        
    def insert_edges(self, edges):
        for e in edges:
            if e[0] not in self.V:
                self.V.append(e[0])
            if e[1] not in self.V:
                self.V.append(e[1])    
            self.E.append(e)
     
        
    def make_set(self, x):
         self.sets[x] = Node(x)
         
         return
     
    def make_sets(self, set_list):
        for i, set_ in enumerate(set_list):
            self.sets[i] = Node(set_[0])
            for j in range(0, len(set_)-1):
                self.union(set_[j], set_[j + 1])   
              


    def find_set(self, x):
        #print(self.sets[x].value, "'s orginal parent is", self.sets[x].p)
        if self.sets[x].value != self.sets[x].p:
            self.sets[x].p = self.find_set(self.sets[x].p)
            print(self.sets[x].value, self.sets[x].p)
        return self.sets[x].p

    
    def link(self, x, y):
        if(x != y):
            if self.sets[x].rank > self.sets[y].rank:
                self.sets[y].p = self.sets[x].value
            else:
                self.sets[x].p = self.sets[y].value
                if self.sets[x].rank == self.sets[y].rank:
                    self.sets[y].rank += 1
            
            temp = self.sets[x].back
            self.sets[x].back = self.sets[y].back
            self.sets[y].back = temp


    def union(self, x, y):
        self.link(self.find_set(x), self.find_set(y))


    def conn_comp(self):
        for v in self.V:
            self.make_set(v)
        '''
        for edge in self.E:
            x, y = edge[0], edge[1]
            self.union(x, y)
        '''
    
    def print_set(self, x):
        set_print = set()
        current_val = x
        while(self.sets[current_val].back != x):
            # this prints out set in order of back pointer
            # adding to a set will not preserve circular linked list order
            set_print.add(self.sets[current_val].value)
            current_val = self.sets[current_val].back
        set_print.add(current_val)
        
        return set_print
   

G = Graph()
G.make_sets([(4,8), (3), (9,2,6), (), (), (1,7), (5)])

G.sets
'''
G.insert_vertices(['a','b','c','d','e','f','g','h','i','j'])
#G.insert_edges([('b','d'), ('e','g'), ('a','c'), ('h','i'), ('a','b'), ('e','f'), ('b','c')])
G.insert_edges([('b', 'h'), ('c', 'h'), ('e','c'), ('c','f'), ('g','d'), ('e','f')])
G.conn_comp()
'''


'''
G2 = Graph()
G2.insert_vertices(list(ascii_lowercase[:11]))
G2.insert_edges([('d', 'i'),('f', 'k'),('g', 'i'),('b', 'g'),('a', 'h'),('i', 'j'),
                 ('d', 'k'),('b', 'j'),('d', 'f'),('g', 'j'),('a', 'e')
                 ])
G2.conn_comp()
'''

'''
for i in G.V:
    print(G.print_set(i))
print()

print("\n")
for i in G.V:
    print(G.sets[i].value, G.sets[i].p)
print()

for i in G2.V:
    print(G2.print_set(i)) 
'''   






