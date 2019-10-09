# -*- coding: utf-8 -*-
"""
Created on Thu Oct  3 02:14:05 2019

@author: bjwil
"""




def split(n, cuts_pos):
    
    if not cuts_pos:
        return [0, []]
    pos = []
    min_cost = float("inf")
    for c in cuts_pos:
        left_split = [x for x in cuts_pos if x < c]
        #print(left_split)
        right_split = [x-c for x in cuts_pos if x > c]
        #print(right_split)
        left_cost = split(c, left_split)
        right_cost = split(n-c, right_split)
        #print(left_cost[1])
        print(right_cost[1])
        right_cost = split(n-c, right_split)
        pos = [c] + left_cost[1] + [x+c for x in right_cost[1]]
        min_cost = min(min_cost, left_cost[0] + right_cost[0])

    return (min_cost + n, pos)

n = 20
cuts = [2,4,6,8]    
print(split(n, cuts))
