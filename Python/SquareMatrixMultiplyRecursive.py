# -*- coding: utf-8 -*-
"""
Created on Sat Jul 20 17:29:30 2019

@author: bjwil
"""
import numpy as np

#a = np.matrix('1 2 3 4; 4 4 4 4; 4 3 2 1; 1 2 3 4')
#b = np.matrix('1 1 1 1; 2 2 2 2; 3 3 3 3; 4 4 4 4')
rows = cols = 2
a = np.matrix(np.random.randint(0,10, size=(rows, cols)))
b = np.matrix(np.random.randint(0,10, size=(rows, cols)))
#n = 2
#k = 4
#np.matmul(a[0:n,0:n], b[0:n, n:k])
def smm(a, b):
    n = len(a)
    c = np.zeros(shape=(len(a), len(a)))
    for i in range(0, n):
        for j in range(0, n):
            for k in range(0,n):
                c[i,j] = c[i,j] + (a[i,k] * b[k,j])
                 
    return c


def smmr(a, b):
    n = len(a)
    c = np.zeros(shape=(len(a), len(a)))
    if n == 1:
        c[0,0] = a[0,0] * b[0,0]
    else:
        n = int(n/2)
        k = int(len(c))
        c[0:n, 0:n] = smmr(a[0:n,0:n], b[0:n,0:n]) + smmr(a[0:n, n:k], b[n:k,0:n])
        
        c[0:n, n:k] = smmr(a[0:n,0:n], b[0:n, n:k]) + smmr(a[0:n, n:k], b[n:k, n:k])
        
        c[n:k, 0:n] = smmr(a[n:k,0:n], b[0:n,0:n]) + smmr(a[n:k, n:k], b[n:k,0:n])
        
        c[n:k, n:k] = smmr(a[n:k,0:n], b[0:n, n:k]) + smmr(a[n:k, n:k], b[n:k, n:k])
    
    return c

class Strassen():
    
    def __init__(self):
        self.multiplications = 0
    
    def strassen_smmr(self, a, b):
        n = len(a)
        c = np.zeros(shape=(len(a), len(a)))
        if n == 1:
            c[0,0] = a[0,0] * b[0,0]
            self.multiplications += 1
        else:
            n = int(n/2)
            k = int(len(c))
            a11 = a[0:n,0:n]
            a12 = a[0:n, n:k]
            a21 = a[n:k,0:n]
            a22 = a[n:k,n:k]
            b11 = b[0:n,0:n]
            b12 = b[0:n, n:k]
            b21 = b[n:k,0:n]
            b22 = b[n:k,n:k]
    
            
            s1 = b12 - b22
            s2 = a11 + a12
            s3 = a21 + a22
            s4 = b21 - b11
            s5 = a11 + a22
            s6 = b11 + b22
            s7 = a12 - a22
            s8 = b21 + b22
            s9 = a11 - a21
            s10 = b11 + b12
            
            p1 = self.strassen_smmr(a11, s1)
            p2 = self.strassen_smmr(s2, b22)
            p3 = self.strassen_smmr(s3, b11)
            p4 = self.strassen_smmr(a22, s4)
            p5 = self.strassen_smmr(s5, s6)
            p6 = self.strassen_smmr(s7, s8)
            p7 = self.strassen_smmr(s9, s10)
            
            c[0:n,0:n] = p5 + p4 - p2 + p6
            c[0:n, n:k] = p1 + p2
            c[n:k,0:n] = p3 + p4
            c[n:k,n:k] = p5 + p1 - p3 - p7
            
        return c



import timeit, functools

sm = 7
times = 100

index = [i for i in range(0, sm)]
array_1 = []
array_2 = []
array_3 = []
#i = 2
for i in range(0, sm):
    a = np.floor(np.random.rand(2**i,2**i)*10)
    b = np.floor(np.random.rand(2**i,2**i)*10)
    
    sm1 = timeit.Timer(functools.partial(smm, a, b))      
    array_1.append(sm1.timeit(times)) 
    
    sm2 = timeit.Timer(functools.partial(smmr, a, b))      
    array_2.append(sm2.timeit(times))
    
    test = Strassen()
    sm3 = timeit.Timer(functools.partial(test.strassen_smmr, a, b))      
    array_3.append(sm3.timeit(times)) 

import matplotlib.pyplot as plt
import pandas as pd

df = pd.DataFrame({'matrix_order': [2**i for i in index], 
                   'smmNonRecursive' : array_1,
                   'smmRecursive': array_2,  
                   'strassen' : array_3,
                   })
# gca stands for 'get current axis'
ax = plt.gca()
df.plot(kind='line',x='matrix_order',y='smmNonRecursive', color='green', ax=ax)
df.plot(kind='line',x='matrix_order',y='smmRecursive',ax=ax)
df.plot(kind='line',x='matrix_order',y='strassen', color='red', ax=ax)
plt.ylabel("seconds")
plt.title("Comparison for Matrix Methods: {} runs".format(times))
plt.show()
