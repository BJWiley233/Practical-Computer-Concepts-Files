# -*- coding: utf-8 -*-
"""
Created on Fri Sep 28 22:31:21 2018

@author: bjwil
"""

from sys import stdin
import matplotlib.pyplot as plt
import numpy as np
from sklearn import datasets, linear_model
from sklearn.metrics import mean_squared_error, r2_score
from sklearn.linear_model import LinearRegression
import os
import random

data = pd.read_csv('kc_house_data.csv')
os.getcwd()
data.head(10)

price = data["price"]
space = data["sqft_living"]
x = np.array(space).reshape(-1, 1)
y = np.array(price).reshape(-1, 1)

model = LinearRegression(fit_intercept=True)

model.fit(x, y)

xfit = x
yfit = model.predict(xfit)

plt.scatter(x, y)
plt.plot(xfit, yfit);

print("Model slope:    ", model.coef_[0])
print("Model intercept:", model.intercept_)

Text = 'GCGCG'
Pattern = 'GCG'

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]
        
window(Text, Pattern)

def PatternCount(Text, Pattern):
    count = 0
    for string in window(Text, len(Pattern)):
        if string == Pattern:
            count += 1
    return count


import sys
lines = sys.stdin.read().splitlines()

Text = lines[0]
Patterns = lines[1]

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]

def PatternCount(Text, Pattern):
    count = 0
    for string in window(Text, len(Pattern)):
        if string == Pattern:
            count += 1
    return count


PatternCount(Text, Pattern)

inseq = 'CGGACTCGACAGATGTGAAGAACGACAATGTGAAGACTCGACACGACAGAGTGAAGAGAAGAGGAAACATTGTAA'

k = 5
L = 50
t = 4
seg = 'CGACA'
i = 6

def search(inseq, k, L, t):
    lookup = defaultdict(list)
    result = set()

    for i in range(len(inseq) - k + 1):
        seg = inseq[i:i + k]
        

        # remove prior positions of the same segment
        # if they are more than L distance far
        while lookup[seg] and i + k - lookup[seg][0] > L:
            lookup[seg].pop(0)
            
        lookup[seg].append(i)
        print(lookup)
        if len(lookup[seg]) == t:
            result.add(seg)

    return result