# -*- coding: utf-8 -*-
"""
Created on Sun Jul 15 22:20:51 2018

@author: bjwil
"""
import string

def my_outer_function(param1, param2, three):
    
    def inner_function_1(param1):
        innerID = 'some text!'
        inner1 = innerID + param1
        yield inner1
    
    def punctuation_search(inner1):
        punctuationVar = set(string.punctuation).intersection(set(inner1))
        yield punctuationVar
    
    return punctuation_search()

def trie_tostr(root):
    s = []
    def dump_leaf(curr,parent_id):
        current_id = parent_id + 1
        for key, value in curr.iteritems():
            if (value == _end):
                continue
            s.append(str(parent_id)+'->'+str(current_id)+':'+key)
            current_id = dump_leaf(value,current_id)
        return current_id
    dump_leaf(root,0)
    return '\n'.join(s)