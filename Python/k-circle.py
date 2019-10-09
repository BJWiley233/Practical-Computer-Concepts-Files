# -*- coding: utf-8 -*-
"""
Created on Fri Feb 22 14:39:58 2019

@author: bjwil
"""

import itertools

fin = open('dataset_203_7.txt', 'r')
fout=open('genome1.txt', 'w')
for line in fin.readlines():
    n = line

lst = list(itertools.product([0, 1], repeat=n))

new_lst = [''.join(str(i) for i in entry) for entry in lst]
#debruijn_Graph(new_lst)
string = StringReconstruction(new_lst)[:-(n-1)]

fout.write(string)
fin.close()
fout.close()
