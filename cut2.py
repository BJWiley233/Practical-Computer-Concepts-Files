# -*- coding: utf-8 -*-
"""
Created on Thu Oct  3 02:44:32 2019

@author: bjwil
"""


def split(n, cut_list, n_pos__mincost_minpos_dict):
        split.counter +=1
        if len(cut_list) == 0: 
            return [0,[]]
        min_positions = []
        min_cost = float("inf")
        for k in cut_list:
            
            left_split = tuple([ x for x in cut_list if x < k])
            right_split = tuple([ x-k for x in cut_list if x > k]) 

            if (k,left_split) in n_pos__mincost_minpos_dict:
                lcost = n_pos__mincost_minpos_dict[(k,left_split)]
            else:
                lcost = split(k, left_split,n_pos__mincost_minpos_dict)
            if (n-k,right_split) in n_pos__mincost_minpos_dict:
                rcost = n_pos__mincost_minpos_dict[(n-k,right_split)]
            else:
                rcost = split(n-k, right_split, n_pos__mincost_minpos_dict) 
                
            cost = n+lcost[0] + rcost[0]
            positions = tuple([k]) + tuple(lcost[1]) + tuple([x+k for x in rcost[1]])
  
            if cost < min_cost:
                min_cost = cost
                min_positions = positions
                n_pos__mincost_minpos_dict[(n,positions)] = (min_cost, min_positions)



        return (min_cost, min_positions) 

# test 1
n_pos__mincost_minpos_dict = {}
n=20
S=(2,4,6,8)
split.counter = 0
print(split(n, S, n_pos__mincost_minpos_dict))
print(split.counter)

# test 2
n_pos__mincost_minpos_dict = {}
n=40
S=(7,2,13,4,6,8, 5)
split.counter = 0
print(split(n, S, n_pos__mincost_minpos_dict))
print(split.counter)





''' test can only hash tuples
type(S)
k=3
type(tuple([ x for x in S if x > k]))

t = (5, (6,2))
t[0]
test_dict[(5, (6,2))] = 2
'''