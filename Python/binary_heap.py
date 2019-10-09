
# -*- coding: utf-8 -*-
"""
Created on Sat Aug  3 00:58:36 2019

@author: bjwil
"""

'''
class Node():
    
    def __init__(self, data):
        self.data = data
        self.left = None
        self.right = None
        self.parent = None
'''
class BinaryHeap():
    
    def __init__(self):
        self.size = None
    
    def parent(self, i):
        return int((i-1)/2)
    
    def left(self, i):
        return 2*i + 1
    
    def right(self, i):
        return 2*i + 2
    
    def max_heapify(self, A, i):
        l = self.left(i) # 2*1 + 1 = 3
        r = self.right(i) # 2*1 + 2 = 4
        if l <= (self.size - 1) and A[l] > A[i]:
            largest = l
        else:
            largest = i
        if r <= (self.size - 1) and A[r] > A[largest]:
            largest = r
        if largest != i:
           A[i], A[largest] = A[largest], A[i]
           self.max_heapify(A, largest)
        
    def build_max_heap(self, A):
        self.size = len(A)
        for i in range(int(self.size/2)-1, -1, -1):
            self.max_heapify(A, i)
            
    def heapsort(self, A):
        self.build_max_heap(A)
        for i in range(len(A) - 1, 0, -1):
            A[0], A[i] = A[i], A[0]
            self.size -= 1
            self.max_heapify(A, 0)
            
    def heap_maximum(self, A):
        return A[0]
    
    def extract_maximum(self, A):
        if self.size < 1:
            raise ValueError("heap underflow")
        maximum = A[0]
        A[0] = A[self.size - 1]
        self.size -= 1
        self.max_heapify(A, 0)
        return maximum
    
    def increase_key(self, A, i, key):
        if key < A[i]:
            raise ValueError("new key is smaller than current key")
        A[i] = key
        while i > 0 and A[self.parent(i)] < A[i]:
            A[i],  A[self.parent(i)] =  A[self.parent(i)], A[i]
            i = self.parent(i)
    
    def max_heap_insert(self, A, key):
        self.size += 1
        #A.append(float("inf")*(-1))
        A[self.size] = float("inf")*(-1)
        self.increase_key(A, self.size - 1, key)

    def build_max_heap_prime(self, A):
        self.size = 0
        for i in range(1, len(A)):
            self.max_heap_insert(A, A[i])
    
A = [16, 4, 10, 14, 7, 9, 3, 2, 8, 1]
B = [16, 4, 10, 14, 7, 9, 3, 2, 8, 1]
heap = BinaryHeap()
heap.build_max_heap(A)
#heap.build_max_heap_prime(B)
#A == B
#heap.heapsort(A)
#heap.heap_maximum(A)
#heap.extract_maximum(A)
#heap.increase_key(A, 8, 15)
heap.max_heap_insert(A, 35)