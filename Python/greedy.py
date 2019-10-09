# -*- coding: utf-8 -*-
"""
Created on Fri Sep 27 00:31:13 2019

@author: bjwil
"""

s = [0,1,3,0,5,3,5,8,6,8,2,12]
f = [0,4,5,6,7,9,9,11,10,12,14,16]

import numpy as np
new = np.argsort(f)

newf = np.array(f)[new]
news = np.array(s)[new]

array = []
def ras(s, f, k, n):
    m = k + 1
    while m <= n and s[m] < f[k]:
        m += 1
    if m <= n:
        array.append(m)
        ras(s, f, m, n)
    else:
        return None

ras(news, newf, 0, len(s)-1)  
print(array)

import networkx as nx
import random
#import matplotlib.pyplot as plt
#from networkx.drawing.nx_agraph import write_dot, graphviz_layout
#import graphviz
#import pygraphviz

G = nx.DiGraph()

G.add_node(f"abcdefgh; 54")

G.add_node(f"h; 21")
G.add_node(f"abcdefg; 33")
G.add_node("g; 13")
G.add_node("abcdef; 20")
G.add_node("f; 8")
G.add_node("abcde; 12")
G.add_node("e; 5")
G.add_node("abcd; 7")
G.add_node("d; 3")
G.add_node("abc; 4")
G.add_node("c; 2")
G.add_node("ab; 2")
G.add_node("b; 1")
G.add_node("a; 1")
G.add_edge(f"abcdefgh; 54",f"h; 21")
G.add_edge(f"abcdefgh; 54",f"abcdefg; 33")
G.add_edge("abcdefg; 33", "g; 13")
G.add_edge("abcdefg; 33", "abcdef; 20")
G.add_edge("abcdef; 20", "f; 8")
G.add_edge("abcdef; 20", "abcde; 12")
G.add_edge("abcde; 12", "e; 5")
G.add_edge("abcde; 12", "abcd; 7")
G.add_edge("abcd; 7", "d; 3")
G.add_edge("abcd; 7", "abc; 4")
G.add_edge("abc; 4", "c; 2")
G.add_edge("abc; 4", "ab; 2")
G.add_edge("ab; 2", "b; 1")
G.add_edge("ab; 2", "a; 1")
'''
write_dot(G,'test1.dot')

plt.title("Huffman Fibonacci 8")
pos = graphviz_layout(G, prog='dot')
nx.draw(G, pos, with_labels=True, node_size=1200, arrows=True, node_shape='s')
plt.savefig('nx_test.png')
'''

pdot = nx.drawing.nx_pydot.to_pydot(G)
#pdot.write_png(png_path)
pdotE = pdot.get_edges()

for i, node in enumerate(pdot.get_nodes()):
    #node.set_label("n%d" % i)
    node.set_shape('box')
    node.set_fillcolor('red')
    node.set_fontcolor('black')
    #node.set_style('filled')
for i, edge in enumerate(pdot.get_edges()):
    edge.set_color('black') 
    if i % 2 == 1:
        edge.set_fontcolor('blue')    
        edge.set_label("1")
    else:
        edge.set_fontcolor('red')    
        edge.set_label("0")
png_path = "test.png"
pdot.write_png(png_path)





shapes = ['box', 'polygon', 'ellipse', 'oval', 'circle', 'egg', 'triangle', 'exagon', 'star', ]
colors = ['blue', 'black', 'red', '#db8625', 'green', 'gray', 'cyan', '#ed125b']
styles = ['filled', 'rounded', 'rounded, filled', 'dashed', 'dotted, bold']

for i, node in enumerate(pdot.get_nodes()):
    #print(node)
    #node.set_label("%s" % i)
    node.set_shape('box')
    node.set_fontcolor('black')
    node.set_fillcolor('red')
    node.set_style('filled')
    node.set_color('red')

for i, edge in enumerate(pdot.get_edges()):
    edge.set_label("")
    edge.set_fontcolor("black")
    if i % 2 = 1:
        edge.set_color('blue')
    else: 
        
    edge.set_style('filled')

png_path = "test.png"
pdot.write_png(png_path)

pdot.get_node_list()