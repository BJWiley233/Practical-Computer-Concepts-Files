# -*- coding: utf-8 -*-
"""
Created on Mon Apr  2 21:15:17 2018

@author: bjwil
"""

import itertools

def combination(k):
    return (''.join(p) for p in itertools.product('ATCG', repeat=k))

def hamming_distance(pattern, seq):
    return sum(c1 != c2 for c1, c2 in zip(pattern, seq))

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]

def motif_enumeration(k, d, DNA):
    pattern = set()
    for combo in combination(k):
        if all(any(hamming_distance(combo, pat) <= d 
                for pat in window(string, k)) for string in DNA):
            pattern.add(combo)
    return pattern

DNA = ['ATTTGGC', 'TGCCTTA', 'CGGTATC', 'GAAAATT']
print(len(motif_enumeration(int(k), int(d), Dna)))




d = int(d)

k = int(k)
type(d)
def Neighbors(hammer,t):
    if t == 0:
        return [hammer]
    if len(hammer) == 1:
        return {'A','C','G','T'}
    array = set()
    suffix = hammer[-(len(hammer)-1):]
    prefix = hammer[0:1]
    SuffixNeighbors = Neighbors(suffix,t)
    for text in SuffixNeighbors:
        if mismatch(suffix, text) < t:
            for i in chars:
                array.add(i + text)
        else:
            array.add(prefix + text)    
    return array

def MotifEnumeration(Dna, k, d):
    Patterns = set()
    for combo in combination(k):
         if all(any(hamming_distance(combo, pat) <= d
                for pat in window(string, k)) for string in Dna):
            Patterns.add(combo)
    return Patterns

def motif_enumeration(k, d, DNA):
    pattern = set()
    for combo in combination(k):
        if all(any(hamming_distance(combo, pat) <= d 
                for pat in window(string, k)) for string in DNA):
            pattern.add(combo)
    return pattern

with open ('dataset_156_8.txt', 'r') as in_file:
    lines = in_file.read().splitlines()
    Dna = lines[1:]
    k, d = str.split(lines[0])
    
print(*MotifEnumeration(int(k), int(d), Dna))


Motifs = [
"TCGGGGGTTTTT",
"CCGGTGACTTAC",
"ACGGGGATTTTC",
"TTGGGGACTTTT",
"AAGGGGACTTCC",
"TTGGGGACTTCC",
"TCGGGGATTCAT",
"TCGGGGATTCCT",
"TAGGGGAACTAC",
"TCGGGTATAACC"
]

len(Motifs)
for letter in line for line in Motifs:
    print(letter)
[letter for letter in word for word in Motifs]
type(Motifs)

Letters = {'A','C','G','T'}

import numpy as np
import pandas as pd

matrix = np.zeros((4,len(Motifs[0])))
np.insert(matrix)
matrix[1][6] = 4
df = pd.DataFrame(matrix)


df.rename({0: 'A', 1: 'C', 2: 'G', 3: 'T'})
df.replace()
numCols = len(Motifs[0])
n = range(numCols)

matrix = np.zeros((4,len(Motifs[0])))
matrix[0][0] = 4
'''BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'''
def functionColumnApply(matrix):
    i=0
    j=0
    totalSum = 0
    subProb = 0
    colSum = 0
    for j in range(0,matrixProb.shape[1]):
        colSum = 0
        for i in range(0,matrixProb.shape[0]):
            if matrixProb[i,j] == 0:
                subProb = 0
            else: 
                subProb = matrixProb[i,j]*math.log(matrixProb[i,j],2)
            colSum += subProb
        '''print(-(colSum))''' 
        totalSum += (-(colSum))
    return round(totalSum,4)

def weDidIt(array):
    matrix = np.zeros((4,len(Motifs[0])))
    aCount = 0
    cCount = 0
    gCount = 0
    tCount = 0
    for j in range(len(Motifs[0])):
        acgtArray = []
        aCount = 0
        cCount = 0
        gCount = 0
        tCount = 0
        for i in range(len(Motifs)):
            '''print(Motifs[i][j])'''
            if Motifs[i][j] == 'A':
                aCount += 1
            elif Motifs[i][j] == 'C':
                cCount += 1
            elif Motifs[i][j] == 'G':
                gCount += 1
            elif Motifs[i][j] == 'T':
                tCount += 1
        '''print(aCount, cCount, gCount, tCount)'''
        acgtArray.extend([aCount, cCount, gCount, tCount])  
        '''print(acgtArray)'''    
        '''print(j)'''
        for i in range(0,4):
            matrix[i][j] = acgtArray[i]

    
    return functionColumnApply(matrix)

weDidIt(Motifs)

'''BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'''

matrix
matrixProb = (matrix/10)
matrixProb = np.asmatrix(matrixProb)
matrixProb[0,0]
import math
-(1*math.log(1,2))
matrixProb[:,0]
len(matrixProb[:,0])
matrixProb.shape[1]
def functionColumnApply(matrix):
    i=0
    j=0
    totalSum = 0
    subProb = 0
    colSum = 0
    for j in range(0,matrixProb.shape[1]):
        colSum = 0
        for i in range(0,matrixProb.shape[0]):
            if matrixProb[i,j] == 0:
                subProb = 0
            else: 
                subProb = matrixProb[i,j]*math.log(matrixProb[i,j],2)
            colSum += subProb
        '''print(-(colSum))''' 
        totalSum += (-(colSum))
    return totalSum

functionColumnApply(matrixProb)
    
math.log?
math.log(math.exp(1),math.exp(1))

math.log(math.exp(1)) 





