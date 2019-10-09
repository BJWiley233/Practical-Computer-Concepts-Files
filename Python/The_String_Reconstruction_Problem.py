# -*- coding: utf-8 -*-
"""
Created on Tue Dec 25 00:20:52 2018

@author: bjwil
"""

import os

os.getcwd()

os.chdir('C:\\Users\\bjwil\\Bioinformatics')

def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]

def alphabetical_strings(s, k):
    dicts = {}
    i = 1
    for string in window(s, k):
        dicts[i] = string
        i = i + 1
    return [(dicts[k]) for k in sorted(dicts, key=dicts.get)]

with open ('dataset_197_3(2).txt', 'r') as in_file:
    lines = in_file.read().split()
    s = lines[1]
    k = int(lines[0])
        
#print(*alphabetical_strings(s, k), sep = '\n')

strings = alphabetical_strings(s, k)

with open('Output.txt', 'w') as f:
    for item in strings:
        f.write("%s\n" % item)
