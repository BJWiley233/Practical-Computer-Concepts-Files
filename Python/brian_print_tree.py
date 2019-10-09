# -*- coding: utf-8 -*-
"""
Created on Sun Sep 29 21:25:54 2019

@author: bjwil
"""
import numpy as np

p = [0., .15, .10, .05, .10, .20]
q = [.05, .10, .05, .05, .05, .10]
n = 5
def optimal_bst_prime(p, q, n):
    e = np.zeros((n+1,n+1))
    w = np.zeros((n+1,n+1))
    root = np.zeros((n,n))
    for i in range(1, n+2):
        e[i-1,i-1] = q[i-1]
        w[i-1,i-1] = q[i-1]
    for l in range(1, n+1):
        for i in range(1, n-l+2):
            j = i + l - 1
            e[i-1,j] = float("inf")
            w[i-1,j] = w[i-1, j-1] + p[j] + q[j]
            for r in range(i, j+1):
                t = e[i-1,r-1] + e[r,j] + w[i-1,j]
                if t < e[i-1,j]:
                    e[i-1,j] = t
                    root[i-1,j-1] = r
    return e, root
                    
optimal_bst_prime(p, q, n)                    
root = optimal_bst_prime(p, q, n)[1]

def construct_optimal_bst(root,i,j,parent):
    if j==i-1:
        print('d{}'.format(j), end = ' ')
        if j < parent:
            print('is the left child of k{}'.format(parent))
        else:
            print('is the right child of k{}'.format(parent))
        return
    r=int(root[i,j])
    print('k{}'.format(r), end = ' ')
    if parent is None:
        print('is the root')
    elif r<parent:
        print('is left child of k{}'.format(parent))
    else:
        print('is right child of k{}'.format(parent))
    construct_optimal_bst(root,i,r-1,r)
    construct_optimal_bst(root,r+1,j,r)
    

# Need to pad a row and column here!!!
new_root = np.zeros((n+1,n+1))
new_root[1:,1:] = root

i = 1
j = 5
parent = None
construct_optimal_bst(new_root,i,j,parent)

# HW Problem
print('')

p = [0, 0.04, 0.06, 0.08, 0.02, 0.10, 0.12, 0.14]
q = [0.06, 0.06, 0.06, 0.06, 0.05, 0.05, 0.05, 0.05]
n = 7
optimal_bst_prime(p, q, n) 
root = optimal_bst_prime(p, q, n)[1]
new_root = np.zeros((n+1,n+1))
new_root[1:,1:] = root
i = 1
j = n
parent = None
construct_optimal_bst(new_root,i,j,parent)

'''
import networkx as nx # use additional library Graphviz and pydot
G = nx.DiGraph()
G.add_node('k2', shape='box', style='filled', fillcolor='green')
G.add_node('k1', shape='box', style='filled', fillcolor='green')
G.add_node('k5', shape='box', style='filled', fillcolor='green')
G.add_node('d0', shape='diamond', style='filled', fillcolor='blue')
G.add_node('d1', shape='diamond', style='filled', fillcolor='blue')
G.add_node('k4', shape='box', style='filled', fillcolor='green')
G.add_node('d5', shape='diamond', style='filled', fillcolor='blue')
G.add_node('k3', shape='box', style='filled', fillcolor='green')
G.add_node('d4', shape='diamond', style='filled', fillcolor='blue')
G.add_node('d2', shape='diamond', style='filled', fillcolor='blue')
G.add_node('d3', shape='diamond', style='filled', fillcolor='blue')

# Must be careful when adding edge order here...
G.add_edge('k2','k1')
G.add_edge('k2','k5')
G.add_edge('k1','d0')
G.add_edge('k1','d1')
G.add_edge('k5','k4')
G.add_edge('k5','d5')
G.add_edge('k4','k3')
G.add_edge('k4','d4')
G.add_edge('k3','d2')
G.add_edge('k3','d3')

pdot = nx.drawing.nx_pydot.to_pydot(G)

for i, edge in enumerate(pdot.get_edges()):
    edge.set_color('black') 
png_path = "CONSTRUCT-OPTIMAL-BST.png"
pdot.write_png(png_path)  
'''




'''
#Just for show :)
G2 = nx.DiGraph()
for i, pnode in enumerate(p[1:]):
    G2.add_node('k{}'.format(i+1), shape='circle', style='filled', fillcolor='pink')
for i, qnode in enumerate(q):
    G2.add_node('d{}'.format(i), shape='doubleoctagon', style='filled', fillcolor='turquoise')
G2.nodes  

# Testing method and graphing here
def construct_optimal_bst_graph(root,i,j,parent,G):
    if j==i-1:
        print('d{}'.format(j), end = ' ')
        if j < parent:
            G.add_edge('k{}'.format(parent), 'd{}'.format(j))
            print('is the left child of k{}'.format(parent))
        else:
            G.add_edge('k{}'.format(parent), 'd{}'.format(j))
            print('is the right child of k{}'.format(parent))
        return
    r=int(root[i,j])
    print('k{}'.format(r), end = ' ')
    if parent is None:
        print('is the root')
    elif r<parent:
        G.add_edge('k{}'.format(parent), 'k{}'.format(r))
        print('is left child of k{}'.format(parent))
    else:
        G.add_edge('k{}'.format(parent), 'k{}'.format(r))
        print('is right child of k{}'.format(parent))
        
    construct_optimal_bst_graph(root,i,r-1,r,G)
    construct_optimal_bst_graph(root,r+1,j,r,G)

i = 1
j = n
parent = None
construct_optimal_bst_graph(new_root,i,j,parent,G2)
pdot = nx.drawing.nx_pydot.to_pydot(G2)

for i, edge in enumerate(pdot.get_edges()):
    edge.set_color('black') 
png_path = "CONSTRUCT-OPTIMAL-BST-HW.png"
pdot.write_png(png_path)  
'''


''' Another way to do the optimal bst          
def optimal_bst(p, q, n):
    e = np.zeros((n+1,n+1))
    w = np.zeros((n+1,n+1))
    root = np.zeros((n,n))
    for i in range(n+1):
        e[i,i] = q[i]
        w[i,i] = q[i]
    for l in range(1, n+1):
        for i in range(n-l+1):
            j = i + l
            print(i)
            e[i,j] = float("inf")
            w[i,j] = w[i, j-1] + p[j] + q[j]
            for r in range(i, j):
                print(i, j)
                t = e[i,r] + e[r+1,j] + w[i,j]
                if t < e[i,j]:
                    e[i,j] = t
                    root[i,j-1] = r+1
    return e, root
'''