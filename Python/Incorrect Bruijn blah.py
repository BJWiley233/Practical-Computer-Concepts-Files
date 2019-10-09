# -*- coding: utf-8 -*-
"""
Created on Mon Dec 31 02:55:14 2018

@author: bjwil
"""

fin = open('bruijn3.txt', 'r')
fout=open('output7.txt', 'w')
reads=[]
for line in fin.readlines():
    reads.append(line.replace('\n',''))

def debruijn_Graph(reads):
    patterns=[]
    smegnosty={}
    for r in reads:
        prefix=r[:-1]
        suffix=r[1:]
        if not(prefix in patterns):
            patterns.append(prefix)
        #if not(suffix in patterns):
            #patterns.append(suffix)
    for pattern in patterns:
        smegnosty[pattern]=[]
    for r in reads:
        smegnosty[r[:-1]].append(r[1:])
    
    text = [] 
    for key in sorted(smegnosty):
        if not(smegnosty[key]==[]):
            text.append(key+" -> "+','.join(smegnosty[key]))
    return text

smegnosty = debruijn_Graph(reads) 

for key in sorted(smegnosty):
    if not(smegnosty[key]==[]):
        fout.write(key+" -> "+','.join(smegnosty[key])+'\n')
    else:
        print(key, smegnosty[key])
fin.close()
fout.close()
