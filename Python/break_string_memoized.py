# -*- coding: utf-8 -*-
"""
Created on Thu Oct  3 02:44:32 2019

@author: bjwil
"""


def split_memoized(n, cuts, n_pos__mincost_minpos_dict):
    split_memoized.counter +=1
    
    if len(cuts) == 0: 
        return [0,[]]
    min_positions = []
    min_cost = float("inf")
    
    for c in cuts:
        left_split = tuple([x for x in cuts if x < c])
        right_split = tuple([x-c for x in cuts if x > c]) 
        # if split_memoized already called with same (c,left_split) then retreive
        if (c,left_split) in n_pos__mincost_minpos_dict:
            left_cost = n_pos__mincost_minpos_dict[(c,left_split)]
        else:
            left_cost = split_memoized(c, left_split,n_pos__mincost_minpos_dict)
            # memoize to dict
            n_pos__mincost_minpos_dict[(c, left_split)] = (left_cost[0], left_cost[1])
        # if split_memoized already called with same (n-c,right_split) then retreive
        if (n-c,right_split) in n_pos__mincost_minpos_dict:
            right_cost = n_pos__mincost_minpos_dict[(n-c,right_split)]
        else:
            right_cost = split_memoized(n-c, right_split, n_pos__mincost_minpos_dict)
            # memoize to dict
            n_pos__mincost_minpos_dict[(n-c, right_split)] = (right_cost[0], right_cost[1])
        
        cost = n + left_cost[0] + right_cost[0]
        positions = tuple([c]) + tuple(left_cost[1]) + tuple([x+c for x in right_cost[1]])

        if cost < min_cost:
            min_cost = cost
            min_positions = positions

    return (min_cost, min_positions) 


# test 1, 10,2,8 is same minumum cost as 10,8,2 as in text
n_pos__mincost_minpos_dict = {}
n=20
L=(10, 2, 8)
split_memoized.counter = 0
print("For n =", n, ", L =", L, "result:", split_memoized(n, L, n_pos__mincost_minpos_dict))
print("For", len(L), "breaks we make", split_memoized.counter, "calls with memoization.")


# test 2
n_pos__mincost_minpos_dict = {}
n=20
L=(2,4,6,8)
split_memoized.counter = 0
print("For n =", n, ", L =", L, "result:", split_memoized(n, L, n_pos__mincost_minpos_dict))
print("For", len(L), "breaks we make", split_memoized.counter, "calls with memoization.")


# test 3, on 18 calls with memoization compared to 
n_pos__mincost_minpos_dict = {}
n=206
L=(2,17,6,5,3)
split_memoized.counter = 0
print("For n =", n, ", L =", L, "result:", split_memoized(n, L, n_pos__mincost_minpos_dict))
print("For", len(L), "breaks we make", split_memoized.counter, "calls without memoization.")


# test 4 same n as test 3 but the cut sites determine how many calls
# this is 48 calls with memoization but for same n in test 3 is 42 calls with memoization
n_pos__mincost_minpos_dict = {}
n=206
L=(41,32,6,7,104)
split_memoized.counter = 0
print("For n =", n, ", L =", L, "result:", split_memoized(n, L, n_pos__mincost_minpos_dict))
print("For", len(L), "breaks we make", split_memoized.counter, "calls with memoization.")
n_pos__mincost_minpos_dict


n_pos__mincost_minpos_dict = {}
n=206
L=(1,2,3,4,5,6,7,8,9,10)
split_memoized.counter = 0
print("For n =", n, ", L =", L, "result:", split_memoized(n, L, n_pos__mincost_minpos_dict))
print("For", len(L), "breaks we make", split_memoized.counter, "calls with memoization.")


n_pos__mincost_minpos_dict = {}
n=206
L=(1,16,3,6,5,24,7,88,109,10)
split_memoized.counter = 0
print("For n =", n, ", L =", L, "result:", split_memoized(n, L, n_pos__mincost_minpos_dict))
print("For", len(L), "breaks we make", split_memoized.counter, "calls with memoization.")


'''# Run Time Test
import timeit, functools
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from break_string_NOT_memoized import split
from break_string_iter import print_breaks, split_iter



times = 1000
length = 9

array_not_memoized = []
array_memoized = []
iter_arr = []
for i in range(1, length):
    n=(i+5)**2
    L=tuple(np.random.choice(range(1,n), i, replace=False))
    n_pos__mincost_minpos_dict = {}
    
    not_memoized = timeit.Timer(functools.partial(split, n, L))      
    array_not_memoized.append(not_memoized.timeit(times))
    
    memoized = timeit.Timer(functools.partial(split_memoized, n, L, n_pos__mincost_minpos_dict))      
    array_memoized.append(memoized.timeit(times))
    
    iterated = timeit.Timer(functools.partial(split_iter, n, L))      
    iter_arr.append(iterated.timeit(times))
    
    
df = pd.DataFrame({'Length L[1..m]': [i for i in range(1,length)], 
                   'not_memoized' : array_not_memoized,
                   'memoized': array_memoized,  
                   'iterated': iter_arr
                   })
# gca stands for 'get current axis'
ax = plt.gca()
df.plot(kind='line',x='Length L[1..m]',y='not_memoized', color='green', ax=ax)
df.plot(kind='line',x='Length L[1..m]',y='memoized',ax=ax)
df.plot(kind='line',x='Length L[1..m]',y='iterated', color='red', ax=ax)
plt.ylabel("seconds")
plt.title("Comparison for Not Memoized vs Memoized: {} runs".format(times))
plt.show()    
'''

