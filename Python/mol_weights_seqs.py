#!/usr/bin/env python
# -*- coding: utf-8 -*-


'''====
Program must have a file to run!
===='''

import os
from argparse import ArgumentParser, FileType
from collections import Counter
import sys
#from sys import stdin, stdout, stderr

   
def print_weights(file):
    reads = []
    #with open(file, 'r') as f:
    for line in file:
        reads.append(line.strip())
    for read in reads:
        nucleotide_dict = Counter(read)
        print(round(nucleotide_dict['A'] * 313.21 + \
              nucleotide_dict['C'] * 289.18 + \
              nucleotide_dict['G'] * 329.21 + \
              nucleotide_dict['T'] * 304.2 - 61.96, 1))
       
def codon_window(text, k = int(3)):
    for i in range(len(text) - k + 1):
        yield text[i:i+k]
        
if __name__ == '__main__':
    parser = ArgumentParser(
            description = 'get weights from DNA sequence')
    parser.add_argument('-r','--read-file',
                        nargs='?',
                        dest='read_file',
                        type=FileType('r'),
                        help='input READS file')
    '''parser.add_argument('-f', '--file',
                        nargs='?',
                        type=FileType('r'),
                        help='input READS file',
                        required=True)
    '''
    args = parser.parse_args()
    if not args.read_file:
        print('\n\n')
        parser.print_help()
        print(__doc__, file=sys.stderr)
        sys.exit(0)
    print_weights(args.read_file)
#codon_dict = Counter([codon for codon in codon_window(text)])

#print(codon_dict['TAG'], codon_dict['TAA'], codon_dict['TGA'])










      
fin = open('seq.txt', 'r')

reads=[]
for line in fin.readlines():
    reads.append(line.replace('\n',''))
    
    
fout=open('output7.txt', 'w')