# -*- coding: utf-8 -*-
"""
Created on Sun Oct 13 23:59:33 2019

@author: bjwil
"""

   
class OLM():
    
    def __init__(self, m, n):
        self.sets = {}
        self.m = m
        self.n = n
        self.extracted = [0 for i in range(m)]
    
    

    
    def make_sets_init(self, set):
        for i, set_ in enumerate(sets):
            self.sets[i] = set(set_)
        return


    def find_set(self, v):

        for key, vals in self.sets.items():
            if v in vals:
                return key

            
    def union(self, l, j):
        self.sets[l] = set(self.sets[l]|self.sets[j])
        self.sets.pop(j)

 
    def off_line_min(self):
        for i in range(self.n):
            j = self.find_set(i+1)
            if j != (self.m):
                self.extracted[j] = (i+1)
                self.sets[j].discard(i+1)
                l = min([k for k,v in self.sets.items() if k > j])
                self.union(l, j)
            
        return
        

if '__main__' == __name__:
    G = OLM(m=6, n=9)
    G.make_sets_init([[4,8], [3], [9,2,6], [], [], [1,7], [5]])
    G.off_line_min()
    print(G.extracted)

brian = set()
type(brian)
brian.discard(0)