# -*- coding: utf-8 -*-
"""
Created on Thu Sep 19 11:10:49 2019

@author: bjwil
"""

import random

A = []
m = 8
r = random.randint(0, 50)
h_k = r % m
j = h_k
A.append(j)
i = 0

while i < m:
    i += 1
    j = (i + j) % m
    A.append(j)
print(A)