
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
        self.size = 0
        self.array = []
    
    def parent(self, i):
        return int((i-1)/2)
    
    def left(self, i):
        return 2*i + 1
    
    def right(self, i):
        return 2*i + 2
    
    def max_heapify(self, i):
        l = self.left(i) # 2*1 + 1 = 3
        r = self.right(i) # 2*1 + 2 = 4
        if l <= (self.size - 1) and self.array[l] > self.array[i]: 
            largest = l
        else:
            largest = i
        if r <= (self.size - 1) and self.array[r] > self.array[largest]:
            largest = r
        if largest != i:
           self.array[i], self.array[largest] = self.array[largest], self.array[i]
           self.max_heapify(largest)
        return l
        
    def build_max_heap(self, A):
        self.size = len(A)
        self.array = A[:]
        
        for i in range(int((len(self.array))/2)-1, -1, -1):
            self.max_heapify(i)
            
    def heapsort(self):
        self.build_max_heap(self.array)
        for i in range(self.size - 1, 0, -1):
            self.array[0], self.array[i] = self.array[i], self.array[0]
            self.size -= 1
            self.max_heapify(0)
            
    def heap_maximum(self):
        return self.array[0]
    
    def extract_maximum(self):
        if self.size < 1:
            raise ValueError("heap underflow")
        maximum = self.array[0]
        self.array[0] = self.array[self.size - 1]
        self.array.pop()
        self.size -= 1
        self.max_heapify(0)
        return maximum
    
    def increase_key(self, i, key):
        if key < self.array[i]:
            raise ValueError("new key is smaller than current key")
        self.array[i] = key
        while i > 0 and self.array[self.parent(i)] < self.array[i]:
            self.array[i],  self.array[self.parent(i)] =  self.array[self.parent(i)], self.array[i]
            i = self.parent(i)
    
    def max_heap_insert(self, key):
        self.size += 1
        self.array.append(float("inf")*(-1))
        #A[self.size] = float("inf")*(-1)
        self.increase_key(self.size - 1, key)

    def build_max_heap_prime(self, B):
        self.size = 0
        for i in range(0, len(B)):
            self.max_heap_insert(B[i])
            
heapA = BinaryHeap()   
heapA.max_heap_insert(1)
heapA.max_heap_insert(2)
heapA.max_heap_insert(3)
heapA.max_heap_insert(14)
heapA.max_heap_insert(5)
heapA.max_heap_insert(6)
heapA.heapsort()
#.max_heapify(1)
heapA.array
heapA.size
#heapA.extract_maximum()
'3b' < '4'

heapB = BinaryHeap()
heapB.build_max_heap(['2c', '3', '1b','2a','1a', '1c', '5'])   
heapB.heapsort()
heapB.array

class Node():
    
    def __init__(self, data, order):
        self.data = data
        self.order = order

class BinaryHeapNode():

    def __init__(self):
        self.size = 0
        self.array = []
    
    def parent(self, i):
        return int((i-1)/2)
    
    def left(self, i):
        return 2*i + 1
    
    def right(self, i):
        return 2*i + 2
    
    def max_heapify(self, i):
        l = self.left(i) # 2*1 + 1 = 3
        r = self.right(i) # 2*1 + 2 = 4
        if l <= (self.size - 1) and self.array[l].data > self.array[i].data: 
            largest = l
        else:
            largest = i
        if r <= (self.size - 1) and self.array[r].data > self.array[largest].data:
            largest = r
        if largest != i:
           self.array[i], self.array[largest] = self.array[largest], self.array[i]
           self.max_heapify(largest)
        
    def build_max_heap(self, A):
        self.size = len(A)
        self.array = A[:]

        for i in range(int((len(self.array))/2)-1, -1, -1):
            self.max_heapify(i)
            
    def heapsort(self):
        self.build_max_heap(self.array)
        for i in range(self.size - 1, 0, -1):
            self.array[0], self.array[i] = self.array[i], self.array[0]
            self.size -= 1
            self.max_heapify(0)


['2c', '3', '1b','2a','1a', '1c', '5']
two_c = Node(2, 'c')
three = Node(3, '')
one_b = Node(1, 'b')
two_a = Node(2, 'a')
one_a = Node(1,'a')
one_c = Node(1, 'c')
five = Node(5, '')
test = [two_c, three, one_b, two_a, one_a, one_c, five]
heapC = BinaryHeapNode()
heapC.build_max_heap(test)

for node in heapC.array:
    print(node.data, " ", node.order)
heapC.heapsort()
for node in heapC.array:
    print(node.data, " ", node.order)
    
class NodeStable():

    def __init__(self, data, order, order_numeric):
        self.data = data
        self.order = order
        self.order_numeric = order_numeric
    
class BinaryHeapNodeStable():

    def __init__(self):
        self.size = 0
        self.array = []
    
    def parent(self, i):
        return int((i-1)/2)
    
    def left(self, i):
        return 2*i + 1
    
    def right(self, i):
        return 2*i + 2
    
    def max_heapify(self, i):
        l = self.left(i) # 2*1 + 1 = 3
        r = self.right(i) # 2*1 + 2 = 4
        if l <= (self.size - 1) and self.array[l].data > self.array[i].data: 
            largest = l
        elif (l <= (self.size - 1) and 
              self.array[l].data == self.array[i].data and 
              self.array[l].order_numeric > self.array[i].order_numeric):
            largest = l
        else:
            largest = i
        if r <= (self.size - 1) and self.array[r].data > self.array[largest].data:
            largest = r
        elif (r <= (self.size - 1) and 
              self.array[r].data == self.array[largest].data and 
            self.array[r].order_numeric > self.array[largest].order_numeric):
            largest = r
        if largest != i:
           self.array[i], self.array[largest] = self.array[largest], self.array[i]
           self.max_heapify(largest)
        
    def build_max_heap(self, A):
        self.size = len(A)
        self.array = A[:]

        for i in range(int((len(self.array))/2)-1, -1, -1):
            self.max_heapify(i)
            
    def heapsort(self):
        self.build_max_heap(self.array)
        for i in range(self.size - 1, 0, -1):
            self.array[0], self.array[i] = self.array[i], self.array[0]
            self.size -= 1
            self.max_heapify(0)


['2c', '3', '1b','2a','1a', '1c', '5']
two_c = NodeStable(2, 'c', 0)
three = NodeStable(3, '', 1)
one_b = NodeStable(1, 'b', 2)
two_a = NodeStable(2, 'a', 3)
one_a = NodeStable(1,'a', 4)
one_c = NodeStable(1, 'c', 5)
five = NodeStable(5, '', 6)
test = [two_c, three, one_b, two_a, one_a, one_c, five]
heapC = BinaryHeapNodeStable()
heapC.build_max_heap(test)

for node in heapC.array:
    print(node.data, " ", node.order)
heapC.heapsort()
for node in heapC.array:
    print(node.data, " ", node.order)