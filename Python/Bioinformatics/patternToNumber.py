# -*- coding: utf-8 -*-
"""
Created on Mon Feb 26 22:54:48 2018

@author: bjwil
"""

import pdb

def symbolToNumber(symbol):
    if symbol == "A":
        number = 0
    elif symbol == "C":
        number = 1
    elif symbol == "G":
        number = 2
    elif symbol == "T":
        number = 3
    return number

def patternToNumber(Pattern):
    #pdb.set_trace()
    patternList = list(Pattern)
    if not patternList:
        return 0
    symbol = patternList[-1]
    prefix = patternList[:-1]
    #print symbol, prefix
    return 4 * patternToNumber(prefix) + symbolToNumber(symbol)

def readData(filename):
    with open(filename, 'r') as f:
        #f.readline() # Skip input line
        Pattern = f.readline()
        return Pattern.strip()

if __name__ == "__main__":
    Pattern = readData('dataset_3010_2.txt')
    result = patternToNumber(Pattern)
    print(result)
    
g = ['T']
patternToNumber(g)

def mismatch(text1, text2):
    count = 0
    if len(text1) != len(text2):
        print('Lengths are different.')
        sys.exit()
    for i in range(len(text1)):
        if text1[i] != text2[i]:
            count += 1
    return count

type({'A','C','G','T'})

numberToPattern(1,2)
k = 2
t = 1
hammerAA = 'AA'
hammerAT = 'AT'
mismatch(hammerAA, hammerAT)

import sys

chars = "ACGT"
for i in chars:
    print(i + suffix)
    
def Neighbors(hammer,t):
    if t == 0:
        return hammer
    if len(hammer) == 1:
        return {'A','C','G','T'}
    array = []
    suffix = hammer[-(len(hammer)-1):]
    prefix = hammer[0:1]
    SuffixNeighbors = Neighbors(suffix,t)
    for text in SuffixNeighbors:
        if mismatch(suffix, text) < t:
            for i in chars:
                array.append(i + text)
        else:
            array.append(prefix + text)    
    return array

prefix = text[0:1]
prefix + 'AT'
suffix = text[-(len(text)-1):]

text = 'CAA'
text[-(len(text)-1):]
text[-2:]
print("\n".join(Neighbors('ACCACTGA', 2)))


patternToNumber('AC')
kmerArray = []
for i in range(0,4**k):
    kmerArray.append((numberToPattern(i,k)))
kmerArray

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