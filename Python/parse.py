# -*- coding: utf-8 -*-
"""
Created on Thu Feb 15 21:11:12 2018

@author: bjwil

"""


""""https://d28rh4a8wq0iu5.cloudfront.net/ads1/data/lambda_virus.fa"""
import urllib.request

def readGenome(filename):
    genome = ''
    with open(filename, 'r') as f:
        for line in f:
            if not line[0] == '>':
                genome += line.rstrip()
    return genome
genome = readGenome("lambda_virus.fa")

from os.path import expanduser
home = expanduser("~")
import numpy as np
import pandas as pd
help(pd.DataFrame)
counts = {'A': 0, 'C': 0, 'G': 0, 'T': 0}
for base in genome:
    counts[base] += 1
print(counts)
import collections
collections.Counter(genome)

s = 'AAGGCCTT'
s[0]
s[4:4]
least 
seq = "ACGT"
seq[1]
len(seq)
seq1 = 'CCAA'
print(seq + seq1)
seqs = ['A','C','G','T']
print(','.join(seq))
import random

random.seed(7)
random.choice('ACGT')