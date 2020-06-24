# -*- coding: utf-8 -*-
"""
Created on Sun Feb 25 20:21:23 2018

@author: bjwil
"""

import pdb

def numberToSymbol(number):
    if number == 0:
        symbol = "A"
    elif number == 1:
        symbol = "C"
    elif number == 2:
        symbol = "G"
    elif number == 3:
        symbol = "T"
    return symbol

numberTo

numberToPattern(0,2)
def numberToPattern(index,k):
    if k == 1:
        return numberToSymbol(index)      
    prefixIndex = index//4
    r = index % 4
    if index == 0:
        symbol = 'A'
    else:
        symbol = numberToSymbol(r)
    prefixPattern = numberToPattern(prefixIndex,k-1)
    return prefixPattern + symbol

def readData(filename):
    with open(filename, 'r') as f:
        index = f.readline()
        k = f.readline()
        return int(index), int(k)

if __name__ == "__main__":
    index, k = readData('dataset_3010_5 (1).txt')
    result = numberToPattern(index,k)
    print(result)
    
numberToPattern(45,4)
g = 'g'
t = 'a'
symbol = 'A'
symbol += symbol

2//4