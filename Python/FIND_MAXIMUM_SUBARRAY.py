# -*- coding: utf-8 -*-
"""
Created on Wed Jul 17 22:47:04 2019

@author: bjwil
"""

a = [-1, 2, 3, 4]
low = 0
mid = int((0 + len(a)-1)/2)
high = len(a)-1

low, mid, high = 0, 0, 1
def fmcs(a, low, mid, high):
    left_sum = -(float("inf"))
    total_sum = 0
    for i in range(mid, -1, -1):
        total_sum += a[i]
        if total_sum > left_sum:
            left_sum = total_sum
            max_left = i
    right_sum = -(float("inf"))
    total_sum = 0
    for j in range(mid+1, high+1):
        total_sum += a[j]
        if total_sum > right_sum:
            right_sum = total_sum
            max_right = j
    
    return (max_left, max_right, left_sum + right_sum)

#fmcs(a, low, mid, high)
#fmcs(a, 0, 0, 1)
a = [-1, 2, 3, 4, -5, 6]
low = 0
high = len(a)-1
def fms(a, low, high):
    if high == low:
        return (low, high, a[low])
    else:
        mid = int((low + high)/2)
        left_low, left_high, left_sum = fms(a, low, mid)
        right_low, right_high, right_sum = fms(a, mid+1, high)
        cross_low, cross_high, cross_sum = fmcs(a, low, mid, high)
        
    if left_sum >= right_sum and left_sum >= cross_sum:
        return (left_low, left_high, left_sum)
    elif right_sum >= left_sum and right_sum >= cross_sum:
        return (right_low, right_high, right_sum)
    else:
        return (cross_low, cross_high, cross_sum)