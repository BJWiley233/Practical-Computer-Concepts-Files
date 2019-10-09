# -*- coding: utf-8 -*-
"""
Created on Tue Sep 17 04:28:15 2019

@author: bjwil
"""

import math



def median(a, b):

    if (len(a) == 1 and len(b) == 1):
        return min(a, b)[0]
    med_a = a[math.ceil(len(a)/2) - 1]
    med_b = b[math.ceil(len(b)/2) - 1]
    if med_a == med_b:
        return med_a
    if med_a < med_b:
        # if the length is even we don't include the lesser in getting the greater half
        if len(a) % 2 == 0:
            return median(a[(math.ceil(len(a)/2) - 1)+1:], b[:(math.ceil(len(b)/2))])
        else:
            return median(a[(math.ceil(len(a)/2) - 1):], b[:(math.ceil(len(b)/2))])
    else:
         # if the length is even we don't include the lesser in getting the greater half
        if len(b) % 2 == 0:
            return median(b[(math.ceil(len(b)/2) - 1)+1:], a[:(math.ceil(len(a)/2))])
        else:
            return median(b[(math.ceil(len(b)/2) - 1):], a[:(math.ceil(len(a)/2))])
            
a = [1,2,3,13,15,17,19,21,23]
b = [3,3,4,13,13,16,17,21,40]
c = [i for i in (a + b)]
c.sort()

median(a,b) == c[int((len(c)/2)-1)]



a = [1,1,1,2,3,13,15,17,19,21,23,25]
b = [2,2,3,3,4,13,13,16,17,21,40,42]
c = [i for i in (a + b)]
c.sort()

median(a,b) == c[int((len(c)/2)-1)]
