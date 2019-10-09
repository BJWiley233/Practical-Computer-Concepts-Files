# -*- coding: utf-8 -*-
"""
Created on Fri Aug 30 13:55:38 2019

@author: bjwil
"""

A = [1,2,3,4,5,6,7,8]
v = 1

def binary_search_it(A, v, high, low):
    while low <= high:
        mid = int((low+high)/2) # second round this would be int(0+2/2) or 1
        print(mid)
        if v == A[mid]:
            return mid
        elif v > A[mid]:
            low = mid + 1
        else:
            high = mid # equals 2
                 
    return None

binary_search_it(A, v, len(A)-1, 0) # A, v, 0, 7