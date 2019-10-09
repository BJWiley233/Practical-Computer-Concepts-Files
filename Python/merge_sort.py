# -*- coding: utf-8 -*-
"""
Created on Sat Jul  6 13:58:14 2019

@author: bjwil
"""


# merge (a, 8, 11, 15)
# gives a[8:12] and a[12:16]
#p, q, r = 8, 11, 15
def merge(a, p, q, r):
    n1 = q - p + 1 # 11 - 8 + 1 = 4
    n2 = r - q # 15 - 11 = 4
    left = [] # java and C++ will have to give length n1+1 
    right = [] # and n2+1 for sentinel
    for i in range(1, n1 + 1):
        left.append(a[p + i - 1])
    for i in range(1, n2 + 1):
        right.append(a[q + i])
    left.append(float("inf"))
    right.append(float("inf"))
    i = 0
    j = 0
    for k in range(p, r + 1):
        if left[i] < right [j]:
            a[k] = left[i]
            i += 1
        else:
            a[k] = right[j]
            j += 1
    
    ##return a

#merge(a, p, q, r)
def merge_sort(a, p, r):
    if p < r:
        q = int((p + r) / 2)
        merge_sort(a, p, q)
        merge_sort(a, q + 1, r)
        merge(a, p, q, r)
        
        return a

a = [5, 2, 7, 4, 1, 3, 2, 6]
merge_sort(a, p = 0, r = len(a)-1)

#merge_sort(a, p = 0, r = len(a)-1)
'''
merge(a, 0, 0, 1)
print(a)
merge(a, 2, 2, 3)
print(a)
merge(a, 0, 1, 3)
print(a)
merge(a, 4, 4, 5)
print(a)
merge(a, 6, 6, 7)
print(a)
merge(a, 4, 5, 7)
print(a)
merge(a, 0, 3, 7)
print(a)
'''

