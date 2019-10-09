# -*- coding: utf-8 -*-
"""
Created on Thu Apr 12 00:49:24 2018

@author: bjwil
"""
a = np.matrix([['A',.2,.2,0,0,0,0,.9,.1,.1,.1,.3,0],
     ['C',.1,.6,0,0,0,0,.0,.4,.1,.2,.4,.6],
     ['G',0,0,1,1,.9,0.9,.1,0,0,0,0,0],
     ['T',.7,.2,0,0,.1,.1,0,.5,.8,.7,.3,.4]])

profile = {

    'A': [0.2, 0.2, 0.0, 0.0, 0.0, 0.0, 0.9, 0.1, 0.1, 0.1, 0.3, 0.0],
    'C': [0.1, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.1, 0.2, 0.4, 0.6],
    'G': [0.0, 0.0, 1.0, 1.0, 0.9, 0.9, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0],
    'T': [0.7, 0.2, 0.0, 0.0, 0.1, 0.1, 0.0, 0.5, 0.8, 0.7, 0.3, 0.4]
}

P = 'TCGTGGATTTCC'
P[4]
def Pr(P,a):
    listIT = []
    for i in range(0,len(P)):
        for j in range(0,a.shape[0]):
            if P[i] == a[j,0]:
                listIT.append(a[j,i+1])
    
    return list(map(float,listIT))

reduce(lambda x,y: x*y, Pr(P,a))

from functools import reduce
import numpy as np   
import math
 
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

def functionColumnSumApply(matrix):
    i=0
    j=0
    totalSum = 0
    subProb = 0
    colSum = 0
    matrixProb = matrix/10
    for j in range(0,matrixProb.shape[1]):
        colSum = 0
        for i in range(0,matrixProb.shape[0]):
            if matrixProb[i,j] == 0:
                subProb = 0
            else: 
                subProb = matrixProb[i,j]*math.log(matrixProb[i,j],2)
            colSum += subProb 
        totalSum += (-(colSum))
    return round(totalSum,4)


def scoreMatrix(array):
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
            if Motifs[i][j] == 'A':
                aCount += 1
            elif Motifs[i][j] == 'C':
                cCount += 1
            elif Motifs[i][j] == 'G':
                gCount += 1
            elif Motifs[i][j] == 'T':
                tCount += 1
        acgtArray.extend([aCount, cCount, gCount, tCount])  
        for i in range(0,4):
            matrix[i][j] = acgtArray[i]

    
    return functionColumnSumApply(matrix)

scoreMatrix(Motifs)
    


def mismatch(text1, text2):
    count = 0
    if len(text1) != len(text2):
        print('Lengths are different.')
        sys.exit()
    for i in range(len(text1)):
        if text1[i] != text2[i]:
            count += 1
    return count

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


def DistanceBetweenPatternAndStrings(Pattern, Dna):
    k = len(Pattern)
    listA = []
    distance = 0
    for string in Dna:
        HammingDistance = float("inf")
        for text in window(string, k):
            if HammingDistance > hamming_distance(Pattern, text):
                HammingDistance = hamming_distance(Pattern, text)
        distance = distance + HammingDistance
    return distance




with open ('dataset_5164_1 (3).txt', 'r') as in_file:
    lines = in_file.read().split()
    DNA = lines[1:]
    Pattern = str.split(lines[0])[0]


DistanceBetweenPatternAndStrings(Pattern, DNA)

def MedianString(Dna, k):
    distance = float("inf")
    for combo in combination(k):
        if distance > DistanceBetweenPatternAndStrings(combo, Dna):
            distance = DistanceBetweenPatternAndStrings(combo, Dna)
            Median = combo
    return Median


with open ('dataset_158_9 (1).txt', 'r') as in_file:
    lines = in_file.read().split()
    Dna = lines[1:]
    k = str.split(lines[0])
    k = int(k[0]) 
    
MedianString(Dna, k)

import numpy as np
import string
ALPHA = string.ascii_letters

profileTest1 = {

    'A': [0.2, 0.2, 0.0, 0.0, 0.0, 0.0, 0.9, 0.1, 0.1, 0.1, 0.3, 0.0],
    'C': [0.1, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.1, 0.2, 0.4, 0.6],
    'G': [0.0, 0.0, 1.0, 1.0, 0.9, 0.9, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0],
    'T': [0.7, 0.2, 0.0, 0.0, 0.1, 0.1, 0.0, 0.5, 0.8, 0.7, 0.3, 0.4]
}

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]
        
def chunks(l, n):
    # For item i in a range that is a length of l,
    for i in range(0, len(l), n):
        # Create an index range for l of n items:
        yield l[i:i+n]

'''Dna = 'CCGAG'
f=open('most_Probable1.txt','r') 
Dna=f.readline() 
k=int(f.readline()) 
P=[] 
for j in range(k): 
    P[4j:4(j+1)]=f.readline().split()'''

import re 
  
with open ('most_Probable1.txt', 'r') as in_file:
    lines = ''
    for line in in_file:
        if re.match(r'^[A-Za-z]', line):
            lines = re.sub('\n$', '', lines)
        lines = ''.join([lines, line])
    
    newLines = lines.split()   
      
    Dna = newLines[0]
    k = int(newLines[1])
    profile = list(map(float, newLines[2:]))
    #W = np.mat(profile)
    #newW = profile.reshape(4,k)
    new_Profile = list(chunks(profile, k))
    final_Profile = {

    'A': new_Profile[0],
    'C': new_Profile[1],
    'G': new_Profile[2],
    'T': new_Profile[3]
    }   
    
answer = ['']
maxSum = 0
textSum = 0
for text in window(Dna,k):
    textSum = 0
    for i in range(0,len(text)):
        textSum += final_Profile[text[i]][i]
    if textSum > maxSum:
        maxSum = textSum
        answer[0] = text
print(*answer)


profile_Matrix = dict.fromkeys(['A','C','G','T'])

profile_Matrix.update({'A': newW[0]})
profile_Matrix.update({'C': newW[1]})
profile_Matrix.update({'G': newW[2]})
profile_Matrix.update({'T': newW[3]})
i = 'A'
profile_Matrix['A'][2]


def chunks(l, n):
    # For item i in a range that is a length of l,
    for i in range(0, len(l), n):
        # Create an index range for l of n items:
        yield l[i:i+n]

def read_file1(input_file):
    '''
    >>> k,t,Dna = read_file('Greedy.txt')
    >>> k,t,Dna = read_file('test.randomizedmotifsearch.extra.txt')
    '''
    f = open(input_file)
    #data = [item.strip() for item in f.readlines()]
    #k,t = map(int,data[0].split(' '))
    f.close()
    return (f)
read_file1('beerSong.txt') 

profileTest1 = {

    'A': [0.2, 0.2, 0.0, 0.0, 0.0, 0.0, 0.9, 0.1, 0.1, 0.1, 0.3, 0.0],
    'C': [0.1, 0.6, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.1, 0.2, 0.4, 0.6],
    'G': [0.0, 0.0, 1.0, 1.0, 0.9, 0.9, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0],
    'T': [0.7, 0.2, 0.0, 0.0, 0.1, 0.1, 0.0, 0.5, 0.8, 0.7, 0.3, 0.4]
}

Dna1 = {
'A': [ 0.5,  0.33333333,  0.5,  0.33333333, 0.16666667, 0.16666667,  0.5,  0.5], 
'C': [0.66666667,  0.33333333,  0.33333333,  0.33333333,  0.33333333, 0.33333333,  0.33333333,  0.33333333],
'G': [0.16666667,  0.66666667,  0.5       ,  0.66666667,  0.66666667, 0.66666667,  0.16666667,  0.33333333],
'T': [0.16666667,  0.16666667,  0.16666667,  0.16666667,  0.33333333, 0.33333333,  0.5       ,  0.33333333]
}