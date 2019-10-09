#!/usr/bin/env python

from __future__ import print_function, division
import sys
from sys import stdin, stderr, exit
import collections
from collections import Counter
import argparse
import string
import operator

'''
 I will require

a generator function using the "yield" statement,
using the argparse module to parse command-line arguments,
using the help-string features of argparse to provide user documentation,
a docstring at the beginning of the program explaining how to use the program (including this docstring in the argparse help can reduce the chance of conflicts between what the programmer is told and what the user is told),
a docstring for every function in the program,
meaningful, understandable names for all variables,
comments for every variable that has a scope of more than 5 lines (except iterator variables in for statements),
making the program be a UNIX executable with public execute permission, and
testing the program on a unix-like (Linux or Mac OS X) system.


I strongly recommend that the program be broken into four major functions:

a read_word generator function that takes a file-like object as a parameter and yields one word at a time,
a parse_arguments function that sets up the argparse command-line parser and calls it on the arguments to the program,
an output function that takes a "dict" hash table and a formatting argument and outputs the contents of the dict, and
a main function that calls the other three.
'''

def parse_args(args):
    parser = argparse.ArgumentParser(description='Get word count.')
    parser.add_argument("-a", "--ascend", help="prints in acending order by word count",
                        action="store_true")
    parser.add_argument("-d", "--descend", help="prints in decending order by word count",
                        action="store_true")
    parser.add_argument("-al", "--alpha", help="prints in alphabetical order by word",
                        action="store_true")
    args = parser.parse_args()
    if args.alpha and args.descend:
        return({"alpha", "descend"})
    elif args.ascend and args.descend:
        return({"ascend"})
    elif args.ascend:
        return({"ascend"})
    elif args.descend:
        return({"descend"})
    elif args.alpha:
        return("alpha")
    else:
        parser.print_help()
        exit(1)
   

   
def read_word(stdin):
    punc = string.punctuation.replace("'","")
    replace_punc = str.maketrans(punc, ' '*len(punc))
    text = stdin.read().translate(replace_punc).lower().split()
    #for word in text.split():
        #yield word.lower()
    return text

def print_output(stdout, counts, options):
    #print(type(options))
    #print([ops for ops in list(options)])
    if "alpha" in options and "descend" in options:
        for i, k in reversed(sorted(counts.items())):
            print(i, "\t", k)
    if all(ops == "descend" for ops in options):
        for i, k in sorted(counts.items(), key=lambda x: (-x[1], x[0])):
            print(i, "\t", k)
    if all(ops == "ascend" for ops in options):
        for i, k in sorted(counts.items(), key=lambda x: (x[1], x[0])):
            print(i, "\t", k)
    
            
        #print(options, counts)
    return


def main(args):
    options = parse_args(args)
    #print(options)
    #for word in read_word(sys.stdin):
        #print(word)
    wordCount = Counter(read_word(sys.stdin))
    #print(wordCount)
    print_output(sys.stdout, wordCount, options)
    
        
'''


def main(args):
    """parses command line arguments, reads text from stdin, and
    prints two-column word-count pairs to stdout in the order specified
    in the command line arguments
    """
    options = parse_args(args)
    counts = collections.defaultdict(int)
        # counts['abc'] is the number of times the word 'abc' occurs 
        # in the input.
        # defaultdict used to make counts of unseen words be 0
    for word in read_word(sys.stdin):
        counts[word] += 1
    print_output(sys.stdout, counts, options)
'''
if __name__ == "__main__" :
    sys.exit(main(sys.argv))
