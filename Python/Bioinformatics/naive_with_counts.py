# -*- coding: utf-8 -*-
"""
Created on Sat Mar  7 19:14:04 2020

@author: bjwil
"""

def naive_with_counts(p, t):
    occurrences = []
    num_alignments = 0
    num_comparisons = 0
    for i in range(len(t) - len(p) + 1):
        num_alignments += 1
        match = True
        for j in range(len(p)):
            num_comparisons += 1
            if not p[j] == t[i+j]:
                match = False
                break
        if match:
            occurrences.append(i)
            
    return occurrences, num_alignments, num_comparisons



      

