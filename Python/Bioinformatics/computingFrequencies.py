# -*- coding: utf-8 -*-
"""
Created on Mon Feb 26 22:56:13 2018

@author: bjwil
"""
from numberToPattern import numberToPattern
from patternToNumber import patternToNumber, symbolToNumber

def computingFreqs(Text, k):
    frequencyArray = []
    for i in range(4**k-1+1):
        frequencyArray.insert(i, 0)
    for i in range(len(Text)-k+1):
        pattern = Text[i:i+k]
        j = patternToNumber(pattern)
        frequencyArray[j] += 1
    return frequencyArray

Text = 'ACGCGGCTCTGAAA'
pattern = textList[0:2]
computingFreqs('ACGCGGCTCTGAAA',2)

def read_data(filename):
    with open(filename, 'r') as f:
        Text = f.readline()
        k = f.readline()
        return Text.strip(), int(k)

if __name__ == "__main__":
    Text, k = read_data('dataset_2994_5 (2).txt')
    result = computingFreqs(Text, k)
    out = []
    for i in result:
        out.append(str(i))
    print (" ".join(out))



def Skew(text):
    array = []
    g = 0
    c = 0
    minVal = 0
    index = 0
    skew = 0
    for i in range(len(text)):
        index += 1
        if text[i] == 'C':
            c += 1
        elif text[i] == 'G':
            g += 1
        skew = g - c
        if skew < minVal:
            array = [index]
            minVal = skew
        if skew == minVal and index not in array:
            array.append(index)

    return array  

import numpy as np
import sys

def skew(text):
    res = []
    cntr = 0
    res.append(cntr)
    for i in text:
        if i == 'C':
            cntr -= 1
        if i == "G":
            cntr += 1
        res.append(cntr)
    res = np.array(res)
    min = np.where(res == res.min())
    return np.savetxt(sys.stdout, min, fmt="%i")

with open ('dataset_7_6 (1).txt', 'r') as in_file:
    text = in_file.readline()
skew(text)


text1 = 'GGGCCGTTGGT'
text2 = 'GGACCGTTGAC'


import inspect
lines = inspect.getsourcelines(patternMismatch)
print("/".join(lines[0]))

    
with open ('dataset_9_3.txt', 'r') as in_file:
    text1, text2 = in_file.read().split()
mismatch(text1, text2)

pattern = 'ATTCTGGA'
text = 'CGCCCGAATCCAGAACGCATTCCCATATTTCGGGACCACTGGCCTCCACGGTACGGACGTCAATCAAAT'
d = 3
    

    
text[0:len(pattern)]
mismatch(pattern,text[61:61+len(pattern)])
    
with open ('dataset_9_4 (2).txt', 'r') as in_file:
    lines = in_file.read().splitlines()
    pattern = lines[0]
    text = lines[1]
    d = int(lines[2])
print(*patternMismatch(pattern, text, d)) 
    
  
pattern = 'AATCCTTTCA'
text = 'CCAAATCCCCTCATGGCATGCATTCCCGCAGTATTTAATCCTTTCATTCTGCATATAAGTAGTGAAGGTATAGAAACCCGTTCAAGCCCGCAGCGGTAAAACCGAGAACCATGATGAATGCACGGCGATTGCGCCATAATCCAAACA'
d = 3 
print(*patternMismatch(pattern, text, d))     
len(text) 


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
    
    
patternMismatchCount('GAGG','TTTAGAGCCTTCAGAGG', 2)    


with open ('dataset_9_6 (1).txt', 'r') as in_file:
    lines = in_file.read().splitlines()
    pattern = lines[0]
    text = lines[1]
    d = int(lines[2])
print(len(patternMismatch(pattern, text, d))) 


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


