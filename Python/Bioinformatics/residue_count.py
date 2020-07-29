# -*- coding: utf-8 -*-
"""
Created on Wed Jul 29 16:00:21 2020

@author: bjwil

Usage:
    Must add hypen or comma between begin and end of subsequence
    Range is inclusive of end index.  No spaces
    
    $ python residue_count.py TET2.fasta --sub 591–969
    $ python residue_count.py TET2.fasta --sub 591,969
    # Gets entire sequence residue count
    $ python residue_count.py TET2.fasta
    # Residues 1500 to C-terminal
    $ python residue_count.py TET2.fasta --s 1500,
"""

import argparse
from collections import OrderedDict
from collections import Counter

parser = argparse.ArgumentParser(description="Returns dictionary for residue \
                                 count for specific subsequence of protein. \
                                 \nOnly takes fasta files.  By default will \
                                 \nonly do first sequence of file if more than\
                                 one sequence")

parser.add_argument("fasta", help="Required fasta file")
parser.add_argument("-s", "--sub", help="The subsequence to parse")


args = parser.parse_args()
#args = parser.parse_args('TET2.fasta --sub ,20'.format(file).split())

def read_fasta(file):
    import re
    seq = OrderedDict()
    header = re.compile('^>')
    with open(file) as f:
        for line in f.readlines():
            if header.match(line):
                seq_name = line
            else:
                if seq_name in seq.keys():
                    seq[seq_name] += line.strip("\n")
                else:
                    seq[seq_name] = line
    
    return seq


sequence = read_fasta(args.fasta)
protein_seq = list(sequence.values())[0]

def make_int(s):
    s = s.strip()
    return int(s) if s else 0

if args.sub:
    import re
    ## needs em dash '−' since many research texts use it 
    subseq = [make_int(i) for i in re.split("-|,|−", args.sub)]
    print(subseq)
    ## C-terminal
    if subseq[1] == 0:
        length = len(protein_seq[subseq[0]-1:])
        count = Counter(protein_seq[subseq[0]-1:])
    ## N-terminal
    elif subseq[0] == 0:
        length = len(protein_seq[:subseq[1]])
        count = Counter(protein_seq[:subseq[1]])
    ## Normal sub-sequence
    else:
        length = len(protein_seq[subseq[0]-1:subseq[1]])
        count = Counter(protein_seq[subseq[0]-1:subseq[1]])    
else:
    length = len(protein_seq)
    count = Counter(protein_seq)

#print(count.most_common())
for residue in count.most_common():
    print(f'{residue[0]}  {residue[1]:>5} {round(residue[1]/length*100, 3):>9}%')
