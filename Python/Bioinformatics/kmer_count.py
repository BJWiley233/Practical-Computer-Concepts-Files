# -*- coding: utf-8 -*-
"""
Created on Fri Oct 11 16:43:38 2019

@author: bjwil
"""

from collections import Counter

def open_fasta_kmers(f, kmer):
    kmer_set = []
    with open(f, 'r') as file:
        next(file)
        sequence =  file.read().replace('\n', '') 
        length = len(sequence)
        for i in range(0, length-kmer+1):
            kmer_set.append(sequence[i:i+kmer])
            
    return Counter(kmer_set)
        
f = "sequence.fasta"
kmer = 13
top = 10

counts = open_fasta_kmers(f, kmer)
sorted(counts.items(), key = lambda kv: kv[1], reverse=True)[0:top]


import khmer

