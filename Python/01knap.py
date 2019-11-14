# -*- coding: utf-8 -*-
"""
Created on Wed Nov  6 23:51:11 2019

@author: bjwil
"""

import numpy as np

class Item():
    
    def __init__(self, weight, value):
        self.weight = weight
        self.value = value
        
item1 = Item(2,1)
item2 = Item(10,20)
item3 = Item(3,3)
item4 = Item(6,14)
item5 = Item(18,100)

items = [item1, item2, item3, item4, item5]
W = 15

def _01(items, W):
    n = len(items)
    K = np.zeros(shape=(n+1,W+1))
    for i in range(1, n+1):
        for w in range(1, W+1):
            print(i,w)
            if items[i-1].weight <= w:
                K[i, w] = max(K[i-1, w], K[i-1, w-items[i-1].weight] + items[i-1].value)
            else:
                K[i, w] = K[i-1, w]
    print(K[-1,-1])
            
_01(items, W)           
                
    
    
    
    
    
    
    
    