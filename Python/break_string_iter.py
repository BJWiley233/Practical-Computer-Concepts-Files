# -*- coding: utf-8 -*-
"""
Created on Mon Oct  7 23:24:47 2019

@author: bjwil
"""
import numpy as np

def print_breaks(L, break_, i, j, breaks):

    if j - i >= 2:
        k = break_[int(i), int(j)]
        #print("Break at", L[int(k)])
        breaks.append(L[int(k)])
        print_breaks(L, break_, int(i), int(k), breaks)
        print_breaks(L, break_, int(k), (j), breaks)
        
    return breaks

def split_iter(n, L):


    L = (0,) + L + (n,)
    L = sorted(L, key = lambda k: k)
    m = len(L)
    cost = np.zeros(shape=(m, m))
    break_ = np.zeros(shape=(m, m))
    for i in range(m-1):
        cost[i,i] = cost[i, i+1] = 0
    cost[m-1, m-1] = 0
    for l in range(3,m+1):
        for i in range(0, m - l + 1):
            j = i + l - 1
            cost[i, j] = float("inf")
            for k in range(i+1, j):
                if (cost[i, k] + cost[k, j]) < cost[i, j]:
                    cost[i, j] = cost[i, k] + cost[k, j]
                    break_[i, j] = k
            cost[i, j] = cost[i, j] + L[j] - L[i]
            
    
    return cost[0, m-1], print_breaks(L, break_, 0, m-1, [])

n=20
L=(10, 2, 8)
print(split_iter(n, L))   

n=20
L=(2,4,6,8)
print(split_iter(n, L))

n=206
L=(2,17,6,5,3)
print(split_iter(n, L))

n=206
L=(41,32,6,7,104)
print(split_iter(n, L))

n=206
L=(1,2,3,4,5,6,7,8,9,10)
print(split_iter(n, L))

n=206
L=(1,16,3,6,5,24,7,88,109,10)
print(split_iter(n, L))