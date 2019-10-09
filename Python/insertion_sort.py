i# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import math
A = [0.78, 0.17, 0.39, 0.26, 0.72, 0.94, 0.21, 0.12, 0.23, 0.68]

def insertion_sort_asc(a):
    for j in range(1, len(a)):
        key = a[j]
        i = j - 1
        while i > -1 and a[i] > key:
            a[i+1] = a[i]
            i = i - 1
        a[i+1] = key
    
    return a
            
insertion_sort_asc(A)      
# print(a)

def bucket_sort(A):
    n = len(A)
    B = [0 for i in A]
    for i in range(0, n):
        B[i] = []
    for i in range(0, n):
        B[math.floor(n*A[i])].append(A[i])
    for i in range(0, n):
        insertion_sort_asc(B[i])
    return [i for itemlist in B for i in itemlist]

a = [5, 2, 4, 6, 1, 3]
def insertion_sort_desc(a):
    for j in range(1, len(a)):
        key = a[j]
        i = j - 1
        while i > - 1 and a[i] < key: # the only change is > to <
            a[i+1] = a[i]
            i = i - 1
        a[i+1] = key
    
    return a

insertion_sort_desc(a)




def binary_to_int(A):
    return sum([(k * 2**(len(A)-1-i)) for i,k in enumerate(A)])

def bit_add_gt2(dict_):
    k = len(dict_)
    extra_cols = int(k/2)
    C = [0 for i in range(0, (max(len(x) for x in dict_) + (extra_cols)))]
    for num in dict_:
       while len(num) < len(C):
            num.insert(0, 0)
    carry = 0
    for i in range((len(dict_[0])-1), -1, -1):
        C[i] = sum([list_[i] for list_ in dict_], carry) % 2
        carry = int(sum([list_[i] for list_ in dict_], carry) / 2)
    #print(C)
    dict_.append(C)
    dict_ = ["A" for i in dict_]
    #dict_ = [(binary, binary_to_int(binary)) for binary in dict_]
    
    return dict_
    
A = [0,1,1,1,0] #14
B = [0,1,1,0] #6
C = [1,1,0,1,1,1,0] #110
D = [0,1,0,1] #5
E = [1,1,1,0] #14
dict_ = [A, B, C, D, E] 
bit_add_gt2(dict_) 

blah = bit_add_gt2(dict_)  
print(blah)     
for binary in dict_:
    print((binary, binary_to_int(binary)))


dict_[0] = (dict_[0], 1)
dict_[0][0]


    
    
def bit_add(A, B):
    n = len(A)
    C = [0 for i in range(0, (n + 1))]
    carry = 0
    for i in range((n - 1), -1, -1):
        C[i + 1] = (A[i] + B[i] + carry) % 2
        carry = int((A[i] + B[i] + carry)/2)
    C[i] = carry
    print(C)
        

A = [0,1,1,0]
B = [0,1,1,1]

def change(list_):
    list_ = 'A'
change(A)
print(A)  

bit_add(A, B)
A = [1,1,1]
B = [1,1,1]
bit_add(A, B)
