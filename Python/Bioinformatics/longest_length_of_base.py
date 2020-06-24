# -*- coding: utf-8 -*-
"""
Created on Fri Jul 20 14:05:47 2018

@author: bjwil
"""

string = 'GGGGTTAAAAWWWWWAAAAAAAATTTAAATGCCC'

string[15:23]
location = [0]
location[0] = 1

def long_length_letter_in_string(string, letter):
    location = [0,0]
    count = 0
    maxCount = 0
    for i in range(0, len(string)):
        if string[i] == letter:
            count +=1
            if count > maxCount:
                maxCount = count
                location[1] = i+1
                location[0] = location[1] - maxCount     
        else: 
            count = 0
    return maxCount, location, string[location[0]:location[1]]
        
long_length_letter_in_string(string, 'A')

