# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 18:00:04 2019

@author: bjwil
"""

a = [1, 1, 1, 1, 1, 1, 1, 1, 2, 4, 5, 7, 3, 3, 3, 3]
def merge(a, p, q, r):
    n1 = q - p + 1 # 11 - 8 + 1 = 4
    n2 = r - q # 15 - 11 = 4
    left = [] # java and C++ will have to give length n1+1 
    right = [] # and n2+1 for sentinel
    for i in range(1, n1 + 1):
        left.append(a[p + i - 1])
    for i in range(1, n2 + 1):
        right.append(a[q + i])   
    for k in range(p, r + 1):
        if not left:
            a[k] = right[0]
            right.pop(0)
        elif not right:
            a[k] = left[0]
            left.pop(0)
        elif left[0] < right [0]:
            a[k] = left[0]
            left.pop(0)
        else:
            a[k] = right[0]
            right.pop(0)
    
    #return a
p, q, r = 8, 11, 15
merge(a, p, q, r)

def merge_sort(a, p, r):
    if p < r:
        q = int((p + r) / 2)
        merge_sort(a, p, q)
        merge_sort(a, q + 1, r)
        merge(a, p, q, r)
        
        return a

a = [5, 2, 7, 4, 1, 3, 2, 6]
merge_sort(a, p = 0, r = len(a)-1)