# -*- coding: utf-8 -*-
"""
Created on Sun Sep 29 21:25:54 2019

@author: bjwil
"""
import numpy as np



def optimal_bst(p, q, n):
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

p = [0., .15, .10, .05, .10, .20]
q = [.05, .10, .05, .05, .05, .10]
n = 5  
opt_bst = optimal_bst(p, q, n)            
e, root = opt_bst[0], opt_bst[1]                     
print(e)
# Need to pad a row and column here!!!
new_root = np.zeros((n+1,n+1))
new_root[1:,1:] = root
i = 1
j = n
parent = None
construct_optimal_bst(new_root,i,j,parent)

# HW Problem
print('')

p = [0, 0.04, 0.06, 0.08, 0.02, 0.10, 0.12, 0.14]
q = [0.06, 0.06, 0.06, 0.06, 0.05, 0.05, 0.05, 0.05]
n = 7
opt_bst = optimal_bst(p, q, n)            
e, root = opt_bst[0], opt_bst[1]                     
print(e)
new_root = np.zeros((n+1,n+1))
new_root[1:,1:] = root
i = 1
j = n
parent = None
construct_optimal_bst(new_root,i,j,parent)

