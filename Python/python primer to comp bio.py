# -*- coding: utf-8 -*-
"""
Created on Sun Mar 24 16:48:04 2019

@author: bjwil
"""
import os
os.getcwd()

with open('seq.txt', 'r') as f:
        text = f.readline().strip()
       
def codon_window(text, k = int(3)):
    for i in range(len(text) - k + 1):
        yield text[i:i+k]

codon_dict = {}
for codon in codon_window(text):
    print(codon)















      
fin = open('seq.txt', 'r')

reads=[]
for line in fin.readlines():
    reads.append(line.replace('\n',''))
    
    
fout=open('output7.txt', 'w')