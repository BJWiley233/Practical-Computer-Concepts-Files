# -*- coding: utf-8 -*-
"""
Created on Sat Mar 24 03:26:32 2018

@author: bjwil
"""

chars = "ACGT"

def neighbors(pattern, d):
    assert(d <= len(pattern))

    if d == 0:
        return [pattern]

    r2 = neighbors(pattern[1:], d-1)
    r = [c + r3 for r3 in r2 for c in chars if c != pattern[0]]

    if (d < len(pattern)):
        r2 = neighbors(pattern[1:], d)
        r += [pattern[0] + r3 for r3 in r2]

    return r



import sys
import inspect
lines = inspect.getsourcelines(patternMismatch)
print("".join(lines[0]))

def mismatch(text1, text2):
    count = 0
    if len(text1) != len(text2):
        print('Lengths are different.')
        sys.exit()
    for i in range(len(text1)):
        if text1[i] != text2[i]:
            count += 1
    return count

def patternMismatch(pattern, text, d):
    array = []
    for i in range(len(text)-len(pattern)+1):
        count = mismatch(pattern,text[i:i+len(pattern)])
        if count <= d:
            array.append(i)
    return array   

def patternMismatchCount(pattern, text, d):
    array = []
    for i in range(len(text)-len(pattern)+1):
        count = mismatch(pattern,text[i:i+len(pattern)])
        if count <= d:
            array.append(i)
    return len(array) 

chars = "ACGT"
for i in chars:
    print(i + suffix)
    
def Neighbors(hammer,t):
    if t == 0:
        return [hammer]
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

print("\n".join(Neighbors('ACCACTGA', 2)))

Text = 'ACGTTGCATGTCGCATGATGCATGAGAGCT'
k, d = 4, 1

def computingFreqs(Text, k):
    frequencyArray = []
    for i in range(4**k-1+1):
        frequencyArray.insert(i, 0)
    for i in range(len(Text)-k+1):
        pattern = Text[i:i+k]
        j = patternToNumber(pattern)
        frequencyArray[j] += 1
    return frequencyArray


''' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'''
def computingFreqsWithMismatch(Text, k, d):
    frequencyArray = []
    frequencyArrayPlusComp = []
    maxFreqPattern = []
    maxFreqPatternRC = []
    for i in range(4**k-1+1):
        frequencyArray.insert(i, 0)
    for i in range(len(Text)-k+1):
        pattern = Text[i:i+k]
        Neighborhood = Neighbors(pattern, d)
        for text in Neighborhood:
            j = patternToNumber(text)
            frequencyArray[j] += 1
    A = np.array(frequencyArray)
    maximum_indices = np.where(A==max(frequencyArray))
    for i in np.nditer(maximum_indices):
        maxFreqPattern.append(numberToPattern(i, k))
    for i in range(len(frequencyArray)):
        countI = frequencyArray[i]
        countC = frequencyArray[patternToNumber(Reverse(numberToPattern(i,k)))]
        count_IC = countI+countC
        frequencyArrayPlusComp.append(count_IC)
    B = np.array(frequencyArrayPlusComp)
    maximum_RC = np.where(B==max(frequencyArrayPlusComp)) 
    for i in np.nditer(maximum_RC):
        maxFreqPatternRC.append(numberToPattern(i, k))
    return frequencyArray, maxFreqPattern, maxFreqPatternRC

with open ('dataset_9_8 (1).txt', 'r') as in_file:
    lines = in_file.read().splitlines()
    Text = lines[0]
    k, d = str.split(lines[1])
results = computingFreqsWithMismatch(Text, int(k), int(2))
print(*results[2])   
''' BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'''

results = computingFreqsWithMismatch('ACGTTGCATGTCGCATGATGCATGAGAGCT', 4, 1)
print(*results[2]) 

frequencyArrayPlusComp = []
for i in range(len(newResults)):
    countI = newResults[i]
    countC = newResults[patternToNumber(Reverse(numberToPattern(i,k)))]
    count_IC = countI+countC
    frequencyArrayPlusComp.append(count_IC)
A = np.array(frequencyArrayPlusComp)
maximum_indices = np.where(A==max(frequencyArrayPlusComp))
for i in np.nditer(maximum_indices):
    numberToPattern(i, k))
    
newResults = results[0]   
newResults
newResults[patternToNumber(Reverse(numberToPattern(0,k)))]    
k = 4

 

results = computingFreqsWithMismatch('ACGTTGCATGTCGCATGATGCATGAGAGCT', 4, 1)
print(*results[1])  

 
Neighborhood = Neighbors('AATT', 0)
type(Neighborhood)
for text in Neighborhood:
    print(text)
    j = patternToNumber(string)
import numpy as np

