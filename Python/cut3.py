# -*- coding: utf-8 -*-
"""
Created on Thu Oct  3 02:44:32 2019

@author: bjwil
"""


def splitstr(n,cut_list,string1, string2, test_dict):
        splitstr.counter +=1
        string1 = ('           ' + string1)
        #print(string1, "-"+string2)
        if len(cut_list) == 0: 
            return [0,[]]
        min_positions = []
        min_cost = float("inf")
        for k in cut_list:
            left_split = tuple([ x for x in cut_list if x < k])
            right_split = tuple([ x-k for x in cut_list if x > k]) 


            lcost = splitstr(k,left_split,string1," ", test_dict)
            rcost = splitstr(n-k,right_split,string1," ", test_dict) 
            cost = n+lcost[0] + rcost[0]
            positions = tuple([k]) + tuple(lcost[1]) + tuple([x+k for x in rcost[1]])
            #print(string1, "-",n, lcost[0], rcost[0])
            #print(string1, "-",[k],  lcost[1], [x+k for x in rcost[1]])
            #print "cost:", cost, " min: ", positions
            if cost < min_cost:
                min_cost = cost
                #print(string1, "-",'min_cost: ', min_cost)
                min_positions = positions
                test_dict[(n,positions)] = (min_cost, min_positions)
            else:
                #continue
                #print(string1, "-","not less than: ", min_cost)
                test_dict[(n,positions)] = (min_cost, min_positions)

        return (min_cost, min_positions) 


test_dict = {}
n=20
S=(2,4,6,8)
splitstr.counter = 0
print(splitstr(n,S, '','', test_dict))
print(splitstr.counter)
'''
type(S)
k=3
type(tuple([ x for x in S if x > k]))

t = (5, (6,2))
t[0]
test_dict[(5, (6,2))] = 2
'''