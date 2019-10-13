# -*- coding: utf-8 -*-
"""
Created on Wed Jul 31 22:16:12 2019

@author: bjwil
"""

class Node():
    
    def __init__(self, data, color=None, parent=None):
        self.data = data
        self.left = None
        self.right = None
        self.parent = None
        self.color = color

      
class BinaryTree:
    
    def __init__(self):
        self.root = None
        self.sentinel = Node(data=None, color="Black")
    '''    
    def insert(self, node):
        y = None
        x = self.root
        while x:
            y = x
            if node.data < x.data:
                x = x.left
            else:
                x = x.right
        node.parent = y
        if y == None:
            self.root = node
        elif node.data < y.data:
            y.left = node
        else:
            y.right = node
    '''
    def insert(self, node):
        if self.root:
            self.insert_recursion(self.root, node)
        else:
            self.root = node
            self.root.parent = self.sentinel
            
    def insert_recursion(self, node, value):
            if value.data < node.data:
                if node.left:
                    return self.insert_recursion(node.left, value)
                else:
                    node.left = value
                    node.left.parent = node
            else:
                if node.right:
                    return self.insert_recursion(node.right, value)
                else:
                    node.right = value
                    node.right.parent = node
        
    def in_order(self, x, array):
        if x:
            self.in_order(x.left, array)
            array.append(x.data)
            self.in_order(x.right, array)
        
        return array 
    
    def set_sentinels(self, node, data):
        node = self.search(node, data);
        if node.left is None:
            node.left = self.sentinel
        if node.right is None:
            node.right = self.sentinel    
        
    
    def search(self, node, data):
        if data == node.data:
            return node
        if data < node.data and node.left:
            return self.search(node.left, data)
        elif data >= node.data and node.right:
            return self.search(node.right, data)
        return False
    
    def get_parent(self, data):
        return self.search(data).parent
    
    def minimum(self, node):
        while node.left:
            node = node.left
        return node
    
    def maximum(self, node):
        while node.right:
            node = node.right
        return node
    
    def get_successor(self, node):
        x = self.search(self.root, node)
        if x.right:
            return self.minimum(x.right)
        y = x.parent
        while y and x == y.right:
            x = y
            y = y.parent
        return y
    
    def get_predecessor(self, node):
        x = self.search(self.root, node)
        if x.left:
            return self.maximum(x.left)
        y = x.parent
        while y and x == y.left:
            x = y
            y = y.parent
        return y
    
    def transplant(self, u, v):
        if u.parent == None or u.parent == self.sentinel:
            self.root = v
        elif u == u.parent.left:
            u.parent.left = v
        else:
            u.parent.right = v
        if v:
            v.parent = u.parent
    '''        
    def delete(self, node):
        node = self.search(self.root, node)
        if node:
            if node.left == None:
                self.transplant(node, node.right)
            elif node.right == None:
                self.transplant(node, node.left)
            else:
               y = self.minimum(node.right) # Line 5 ﬁnds node y, which is the successor of node
               if y.parent != node:
                   self.transplant(y, y.right)
                   y.right = node.right
                   y.right.parent = y
               self.transplant(node, y)
               y.left = node.left
               y.left.parent = y
        else:
            print("Node not found")
    '''

       
 
T = BinaryTree()  
A = [7, 11, 4, 6, 3, 2, 9, 6, 18, 14, 12, 17, 19, 22, 20]

for i in A:
    N = Node(i) # since we are not searching we creating the node here
    T.insert(N) 
N.data
#print(T.root.parent.color)
print(T.search(T.root, 18).left.data)
print(T.in_order(T.root, []))
[T.set_sentinels(T.root, i) for i in A]
print(T.search(T.root, 3).right.color)
print(T.search(T.root, 12).left.color)
