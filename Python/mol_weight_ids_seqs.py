#!/usr/bin/env python
# -*- coding: utf-8 -*-


'''==============================
Program must have a file to run!
=============================='''

import os
from argparse import ArgumentParser, FileType
from collections import Counter
import sys

#print(os.getcwd())
#os.chdir('C:/Users/bjwil/Bioinformatics')

def print_weights(file):
    reads = []
    sequence_dict = {}
    for line in file:
        reads.append(line.strip())
    for read in reads:
        #print(read.split('\t'))
        sequence_dict[read.split('\t')[0]] = Counter(read.split('\t')[1])
    for k, v in sequence_dict.items():
        print(k, '\t', round(v['A'] * 313.21 + \
              v['C'] * 289.18 + \
              v['G'] * 329.21 + \
              v['T'] * 304.2 - 61.96, 1))
        #nucleotide_dict = Counter(read)
        
       
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
        print('\n')
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