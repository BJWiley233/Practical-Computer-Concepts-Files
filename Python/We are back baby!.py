# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
import pandas as pd
import re
import numpy as np
import random
import math
from tabulate import tabulate

def mysqrt(a, x):
    
    while True:
        #print(x)
        y = (x + a/x) / 2
        if y == x:
            break
        x=y
    
    return y

i = 3
mysqrt(4, 41)
start_num, end_num = 1, 9

def test_square(start_num, end_num):
    df = pd.DataFrame(columns=['a', 'mysqrt(a)', 'math.sqrt(a)', 'diff'])
    df2 = pd.DataFrame([[re.sub(r'[^\s]', '-', df.columns.values[i]) for i in 
                       range(len(df.columns.values))]], 
                       columns=list(df.columns.values), dtype='float')
    for i in range(start_num, end_num+1):
        my_sqr = float(mysqrt(i, random.randint(i,i*3)))
        math_sqr = float(math.sqrt(i))
        diff = float(abs(math_sqr-my_sqr))
        df2 = df2.append(pd.Series([i, my_sqr, math_sqr, diff], dtype = 'Float64', index=df2.columns), 
                         ignore_index=True)
    return df2

print(test_square(start_num, end_num).to_string(index=False))

#BBBBOOOOOOOOOOMMMMMMM!!!
print(tabulate(df2, showindex=False, headers=df2.columns, tablefmt = 'plain'))

df2.loc[1:]
df2.loc[1:].astype('float')










df = pd.DataFrame(columns=['a', 'mysqrt(a)', 'math.sqrt(a)', 'diff'])
df2 = pd.DataFrame([[re.sub(r'[^\s]', '-', df.columns.values[i]) for i in 
                    range(len(df.columns.values))]], 
                    columns=list(df.columns.values))



dicts = {}
keys = range(len(df.columns.values))
for i in keys:
    dicts[df.columns.values[i]] = re.sub(r'[^\s]', '-', df.columns.values[i])

word = "mysqrt(a)"
word1 = re.sub(r'[^\s]', '-', word)

s = "string. With. Punctuation?"
s = re.sub(r'[^\w\s]','',s)