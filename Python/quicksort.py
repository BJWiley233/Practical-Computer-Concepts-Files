# -*- coding: utf-8 -*-
"""
Created on Tue Aug  6 18:57:09 2019

@author: bjwil
"""
import random


def partition(A, p, r):
    x = A[r]
    i = p - 1
    for j in range(p, r):
        if A[j] <= x:
            i += 1
            A[i], A[j] = A[j], A[i]
    A[i + 1], A[r] = A[r], A[i + 1]
    
    return i + 1

def quicksort(A, p, r):
    if p < r:
        q = partition(A, p, r)
        quicksort(A, p, q-1)
        quicksort(A, q+1, r)
        
def Rpartition(A, p, r):
    i = random.randint(p, (r))
    A[i], A[r] = A[r], A[i]
    print(A)
    return partition(A, p, r)

def Rquicksort(A, p, r):
    if p < r:
        q = Rpartition(A, p, r)
        Rquicksort(A, p, q-1)
        Rquicksort(A, q+1, r)

def partitionNode(A, p, r):
    x = A[r].data
    i = p - 1
    for j in range(p, r):
        if A[j].data <= x:
            i += 1
            A[i], A[j] = A[j], A[i]
    A[i + 1], A[r] = A[r], A[i + 1]
    
    return i + 1

def quicksortNode(A, p, r):
    if p < r:
        q = partitionNode(A, p, r)
        quicksortNode(A, p, q-1)
        quicksortNode(A, q+1, r)

class Node():
    
    def __init__(self, data, order):
        self.data = data
        self.order = order
        
A = [2,4,1,4,3]

quicksort(A, 0, len(A)-1)
A = [Node(2,''), Node(4, 'a'), Node(1, ''), Node(4, 'b'), Node(3, '')]
A = [Node(4, 'a'), Node(2,''), Node(3, ''), Node(4, 'b'), Node(1, '')]
for i in A:
    print(i.data, " ", i.order)
quicksortNode(A, 0, len(A)-1)





'''
def tail_quicksort(A, p, r):
    while p < r:
        q = partition(A, p, r)
        print("tqs q: ", q)
        tail_quicksort(A, p, q-1)
        
        p = q + 1
        #print("tqs p: ", p)
        #print(p)


#tail_quicksort(A, 0, len(A)-1)
#print(A)

B = [1, 2, 3, 4, 5, 6]
quicksort(A, 0, len(A)-1)
print("")
#tail_quicksort(B, 0, len(B)-1)
'''