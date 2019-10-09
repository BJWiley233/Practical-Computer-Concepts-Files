# -*- coding: utf-8 -*-
"""
Created on Thu Oct  3 02:44:32 2019

@author: bjwil
"""


def split(n, cuts):
    split.counter +=1
    
    if len(cuts) == 0: 
        return [0,[]]
    min_positions = []
    min_cost = float("inf")
    
    for c in cuts:
        left_split = tuple([x for x in cuts if x < c])
        right_split = tuple([x-c for x in cuts if x > c]) 

        left_cost = split(c, left_split)
        right_cost = split(n-c, right_split) 
 
        cost = n + left_cost[0] + right_cost[0]
        positions = tuple([c]) + tuple(left_cost[1]) + tuple([x+c for x in right_cost[1]])
        
        if cost < min_cost:
            min_cost = cost
            min_positions = positions


    return (min_cost, min_positions) 


# test 1, 10,2,8 is same minumum cost as 10,8,2 as in text
# 3 cuts so 3^3 = 27 calls
n=20
L=(10, 2, 8)
split.counter = 0
print("For n =", n, ", L =", L, "result:", split(n, L))
print("For", len(L), "breaks we make", split.counter, "calls without memoization.")


# test 2, 4 cuts so 3^4 = 81 calls
n=20
L=(2,4,6,8)
split.counter = 0
print("For n =", n, ", L =", L, "result:", split(n, L))
print("For", len(L), "breaks we make", split.counter, "calls without memoization.")


# test 3, 5 cuts so 3^5 calls = 243 calls
n=206
L=(2,17,6,5,3)
split.counter = 0
print("For n =", n, ", L =", L, "result:", split(n, L))
print("For", len(L), "breaks we make", split.counter, "calls without memoization.")


# test 4 same n as 3, and number of cuts, without memoization is also 3^5 = 243 calls
n=206
L=(41,32,6,7,104)
split.counter = 0
print("For n =", n, ", L =", L, "result:", split(n, L))
print("For", len(L), "breaks we make", split.counter, "calls without memoization.")


# show that is it 3^m calls to the function = 3^10 = 59,049 calls
n=206
L=(1,2,3,4,5,6,7,8,9,10)
split.counter = 0
print("For n =", n, ", L =", L, "result:", split(n, L))
print("For", len(L), "breaks we make", split.counter, "calls without memoization.")


# show that is it 3^m calls to the function is always 59,049 calls
n=206
L=(1,16,3,6,5,24,7,88,109,10)
split.counter = 0
print("For n =", n, ", L =", L, "result:", split(n, L))
print("For", len(L), "breaks we make", split.counter, "calls without memoization.")


