# -*- coding: utf-8 -*-
"""
Created on Wed Oct  2 19:33:08 2019

@author: bjwil
"""

exchange_rate_dict = {}

rates = [0.8, 0.7, 1.1, .9, .85, .7]
n = 4
r = 0
for i in range(1, n+1):
    for j in range (i, n+1):
        if i==j:
            exchange_rate_dict[(i,j)] = 1
        else:
            exchange_rate_dict[(i,j)] = rates[r]
            exchange_rate_dict[(j,i)] = 1/rates[r]
            r += 1

def get_best_return(exchange_rate_dict, i, n):
    if i == n:
        print("Exchanging with itself is pointless")
    