# -*- coding: utf-8 -*-
"""
Created on Sat Mar 28 17:30:15 2020

@author: bjwil
"""

import requests as r
from Bio import SeqIO
from Bio import Entrez
from Bio.SeqUtils.ProtParam import ProteinAnalysis
from io import StringIO
import time

Entrez.email = 'bwiley4@jh.edu'

cID={'b':'P02057', 'a':'P01948'}  ## subunit ids from Uniprot
prot_seqs = {}

## from https://stackoverflow.com/questions/52569622/protein-sequence-from-uniprot-protein-id-python
baseUrl="http://www.uniprot.org/uniprot/"

for subunit, id_ in cID.items():
    currentUrl=baseUrl+id_+".fasta"
    response = r.post(currentUrl)
    cData=''.join(response.text)
    time.sleep(3)

    Seq=StringIO(cData)
    pSeq=SeqIO.read(Seq,'fasta')
    prot_seqs[subunit] = pSeq
    

aa_count = sum([len(i.seq)*2 for i in prot_seqs.values()])
mol_weight = sum([ProteinAnalysis(str(i.seq)).molecular_weight()*2 for i in prot_seqs.values()])
avg_aa = (mol_weight / aa_count)

from collections import Counter
dimer_aa_content = {key:Counter(value.seq * 2) for (key, value) in prot_seqs.items()}
total_aa_content = sum([i for i in [value for (key, value) in dimer_aa_content.items()]], Counter())

print("Molecular weight = {}\n" \
      "Total amino acids = {}\n" \
      "Average aa molecular weight = {}\n" \
      "Top 5 amino acids by count = {}".format(mol_weight, aa_count, avg_aa,
                                               total_aa_content.most_common()[0:5]))

########################################################################

'''
## Another way...not annotated

def fetch2(ID):
    handle = Entrez.efetch(db='protein', id=ID, 
                           rettype='fasta', retmode='text')
    #seq_record_gen = SeqIO.parse(handle, 'fasta')
    #seq_record = SeqIO.read(handle, 'fasta')
    seq_records = [rec for rec in SeqIO.parse(handle, "fasta")]
    #seq_record = SeqIO.read(handle, 'fasta')
    #SeqIO.write(seq_record, 'out.fasta', 'fasta')
    SeqIO.write(seq_records, 'out.fasta', 'fasta')
    time.sleep(3)
    
    return seq_records

#ID = ['P01948.2', 'P02057.2']
ID = ['P01948', 'P02057']
sequences = fetch2(ID)
sum([len(i.seq)*2 for i in sequences])

from Bio.SeqUtils.ProtParam import ProteinAnalysis
sum([ProteinAnalysis(str(i.seq)).molecular_weight()*2 for i in sequences])
'''


