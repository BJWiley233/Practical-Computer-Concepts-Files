# -*- coding: utf-8 -*-
"""
Created on Sat Sep 28 21:50:23 2019

@author: bjwil
"""
import numpy as np

p = [1,5,8,9,10,17,17,20,24,30]
n = 7
def cut_rod(p, n):
    print(n)
    if n == 0:
        return 0
    q = -float("inf")
    for i in range(n):
        q = max(q, p[i] + cut_rod(p, n-i-1))
    return q

cut_rod(p, n)
    

def momoized_cut_rod_aux(p, n, r):
    if r[n-1] >= 0:
        return r[n-1]
    if n == 0:
        q = 0
    else:
        q = -float("inf")
    for i in range(n):
        q = max(q, p[i] + momoized_cut_rod_aux(p, n-i-1, r))
    r[n-1] = q
    return q

def momoized_cut_rod(p,n):
    #r = np.empty(n, dtype=object)
    r = [0] * n
    for i in range(n):
        r[i] = -float("inf")
    return momoized_cut_rod_aux(p, n, r), r

momoized_cut_rod(p,n)    
momoized_cut_rod(p,9)   
