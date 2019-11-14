# -*- coding: utf-8 -*-
"""
Created on Wed Oct 23 10:26:20 2019

@author: bjwil
"""

class Linked_List():
    
    def __init__(self, x):
            self.head = 
    
class Node():
    
    def __init__(self, x):
        self.next = None
        self.set = Linked_List()
        self.value = x
        

        

test = [[4,8], [3], [9,2,6], [], [], [1,7], [5]]
#test_set_parent = [i for i,k in enumerate(test)]
test_nodes = [Node(x) for i in test for x in i]
test_set_parent_nodes = [Node(i) for i,k in enumerate(test)]

