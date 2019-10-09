# -*- coding: utf-8 -*-
"""
Created on Fri Aug  3 18:14:17 2018

@author: bjwil
"""

import itertools

array = list((1,2,3,4.3,5,6,7,8,9,14,58,33))
groups = 2

def two_clusters_equal_len(array, groups = 2):
    
    if groups != 2:
        return("Must be 2 groups. Create new functions for more than 2 groups")
    length_group = len(array)/groups
    smallest_difference = float('Inf')
    set_smallest_partition = [[1]]
    for labels in itertools.product(range(groups), repeat=len(array)):
        partition = [[] for i in range(groups)]
        for i, label in enumerate(labels):
            partition[label].append(array[i])
        if len(array) % groups == 0:
            if all([len(i) == length_group for i in partition]):
                diff = abs(sum(partition[0])-sum(partition[1]))
                if diff < smallest_difference:
                    smallest_difference = diff
                    set_smallest_partition[0] = partition
        elif len(array) % groups == 1:
            if len(partition[0]) == len(array)//groups + 1:
                diff = abs(sum(partition[0])-sum(partition[1]))
                if diff < smallest_difference:
                    smallest_difference = diff
                    set_smallest_partition[0] = partition
    return round(smallest_difference, 4), set_smallest_partition

two_clusters_equal_len(array, groups)
#two_clusters_equal_len(array, groups=3)

