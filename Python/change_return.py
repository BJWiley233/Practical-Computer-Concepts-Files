# -*- coding: utf-8 -*-
"""
Created on Sat Oct  5 03:48:02 2019

@author: bjwil
"""


def greedy_change(n_cents, c):
    change = []
    while n_cents > 0:
        max_coin = max([x for x in c if x <= n_cents])
        change.append(max_coin)
        n_cents -= max_coin

    return change 

c = [1, 7, 9]
n_cents = 15        
change = greedy_change(n_cents, c)
print(change)




def dynamic_change(n_cents, c):

    C = [0 for i in range(n_cents + 1)]
    S = [0 for i in range(n_cents + 1)]
    for p in range(1, n_cents + 1):
        minimum = float("inf")
        coin = None
        for i in range(len(c)):
            if c[i] <= p:
                if (1 + C[p - c[i]]) < minimum:
                    minimum = (1 + C[p - c[i]])
                    coin = i
            C[p] = minimum
            S[p] = coin
            
    change_array = []
    while n_cents > 0:
        change_array.append(c[S[n_cents]])
        n_cents -= c[S[n_cents]]
        
    return change_array

c = [9, 7, 1]
n_cents = 15
change = dynamic_change(n_cents, c)
print(change)