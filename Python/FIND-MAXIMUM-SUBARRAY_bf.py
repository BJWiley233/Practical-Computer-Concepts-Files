# -*- coding: utf-8 -*-
"""
Created on Fri Jul 19 20:20:03 2019

@author: bjwil
"""

from FIND_MAXIMUM_SUBARRAY import fmcs, fms

a = [-1, 2, 3, 4, -5, 6]

def bruteforce_maximum_subarray(nlist,low,high):
    """
    This function takes an array of numbers, and find the sum of the maximum
    subarray in the list.
    Input: A list of real numbers; the beginning and the end of the part in the list.
    Output: Indices and sum.
    """
    S = {}
    p1 = low
    S[p1 - 1] = 0
    for p1 in range(low,high + 1):
        S[p1] = S[p1 - 1] + nlist[p1]
    maxsum = -float('inf')
    for p1 in range(low,high + 1):
        for p2 in range(p1,high + 1):
            subsum = S[p2] - S[p1 - 1]
            if subsum > maxsum:
                maxsum = subsum
                left,right = p1,p2
    return (left,right,maxsum)

bruteforce_maximum_subarray(a, 0, len(a)-1)

def msa_bf(a):
    max_sum = -(float("inf"));
    start = 0;
    end = 0;
    curr_sum = 0;
    for i in range(0, len(a)):
        curr_sum += a[i];
        if curr_sum > max_sum:
            max_sum = curr_sum
            start = i
            end = i
        for j in range(i+1, len(a)):
            curr_sum += a[j]
            if curr_sum > max_sum:
                max_sum = curr_sum
                start = i
                end = j
        curr_sum = 0;
    
    return (start, end, max_sum)




import time
import numpy as np
from FIND_MAXIMUM_SUBARRAY import fmcs, fms
import timeit, functools
import pandas as pd

t = timeit.Timer(functools.partial(msa_bf, a))
print(t.timeit(10000))

time_bf_array = []
time_rec_array = []
i = 30
for i in range(1, 51):
    a = np.random.randint(-20, 100, size=i)
    b = timeit.Timer(functools.partial(msa_bf, a))
    time_bf_array.append(b.timeit(10000)*1000)
    
    t = timeit.Timer(functools.partial(fms, a, 0, len(a)-1))
    time_rec_array.append(t.timeit(10000)*1000)
    
    b_internet = timeit.Timer(functools.partial(bruteforce_maximum_subarray, a, 0, len(a)-1))
    b_internet.timeit(10000)

import math  
def maximum_subarray_recursion(numlist,low,high):
    """
    This function takes an array of numbers, and find the sum of the maximum
    subarray in the list.
    Input: A list of real numbers; the beginning and the end of the part in the list.
    Output: Indices and sum.
    """
    if low == high: # base case
        return low,high,numlist[low]
    else:
        mid = int(math.ceil(float(low + high)/2))
        left_l,left_h,left_sum = maximum_subarray_recursion(numlist,low,mid - 1)
        right_l,right_h,right_sum = maximum_subarray_recursion(numlist,mid,high)
        cross_l,cross_h,cross_sum = max_crossing_array(numlist,low,mid,high)
        final = max(left_sum,right_sum,cross_sum)        
        if left_sum == final:
            return left_l,left_h,left_sum
        elif right_sum == final:
            return right_l,right_h,right_sum
        else:
            return cross_l,cross_h,cross_sum

def max_crossing_array(sublist,low,mid,high):
    """
    This helper function tries to find the indices of a maximum subarray that
    crosses the midpoint, and return the sum.
    Input: A list of real numbers.
    Output: The indices of a maximum subarray that crosses the midpoint, together
    with its sum.
    """
    inf = float('inf')
    left_sum = -inf
    s = 0
    i = mid - 1
    # beware that i and j should be consistent with maximum_subarray configurations;
    # that is, if use ceiling, then (mid - 1) and mid; if using floor,
    # then mid and (mid + 1).
    while i >= low:
        s = s + sublist[i]
        if s > left_sum:
            left_sum = s
            left_index = i
        i -= 1
    right_sum = -inf
    s = 0
    j = mid
    while j <= high:         
        s = s + sublist[j]         
        if s > right_sum:
            right_sum = s
            right_index = j
        j += 1
    total = left_sum + right_sum
    return (left_index,right_index,total)

    r_internet = timeit.Timer(functools.partial(maximum_subarray_recursion, a, 0, len(a)-1))
    r_internet.timeit(10000)
    
bruteforce_maximum_subarray(a, 0 , len(a)-1)
msa_bf(a) 

fms(a, 0, len(a)-1)
maximum_subarray_recursion(a, 0, len(a)-1)
