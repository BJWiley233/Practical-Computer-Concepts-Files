#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 25 23:49:07 2020

@author: coyote

Example:
    $ python pdb_chains.py 2d5r -c A,B
    $ python pdb_chains.py 4b8c -c C,F
"""


from Bio.PDB import Select, PDBIO, PDBList
from Bio.PDB.PDBParser import PDBParser
import subprocess


class ChainSelect(Select):
        def __init__(self, chain):
            self.chain = chain

        def accept_chain(self, chain):
            if chain.get_id() == self.chain:
                return 1
            else:          
                return 0

def line_prepender(filename, secondary):
    with open(filename, 'r+') as f:
        content = f.read()
        f.seek(0, 0)
        f.write(secondary + content)
         
            
def get_pdb(pdb_code):
    p = PDBParser()
    structure = p.get_structure(pdb_code, pdb_code)
    structure.header
    return structure


if __name__ == "__main__":
    """ Parses PDB id's desired chains, and creates new PDB structures. """
    import argparse
    
    parser = argparse.ArgumentParser(description="Get PDB filed from PDB ID\n \
                                     and optional chain selection to write\n \
                                     chains to seperate PDB files")
    parser.add_argument("pdb_id", help="required pdb id")     
    parser.add_argument("-c", "--chains", help="optional chains to parse\n \
                        if missing will parse all chains\n \
                        input must be comma seperated list no spaces!")                            
    args = parser.parse_args()
    pdb_id = args.pdb_id


    # download pdb
    pdb_list = PDBList()
    pdb_file = pdb_list.retrieve_pdb_file(pdb_id, file_format="pdb", 
                                          obsolete=False)
    
    structure = get_pdb(pdb_file)

    if args.chains:
        chains = args.chains.split(",")
    else:
        print("No chains given, parsing all chains!")
        chains = [structure.header['compound'][c]["chain"] for \
                  c in structure.header['compound']]
    
    # sometimes PDB chains are in form: COMPND   3 CHAIN: A, C, E, F;
    if any([i.find(",") >=0 for i in chains]):
        new_chains = [c.split(",") for c in chains]
        chains = [c.strip() for l in new_chains for c in l]
    
    for chain in chains:
        chain = chain.upper()
        
        pdb_chain_file = "{}{}{}".format(pdb_id, chain, ".pdb")
        io_w_no_h = PDBIO()
        io_w_no_h.set_structure(structure)
        io_w_no_h.save(pdb_chain_file, ChainSelect(chain))
        
        ## ugh we need the secondary structures
        COMMAND = "awk '($1~/^(HELIX)/ && $5~/{}$/) \
            || ($1~/^(SHEET)/ && $6~/{}$/)' \
            {}".format(chain, chain, pdb_file)
        secondary = subprocess.check_output(COMMAND, shell=True).decode("utf-8") 
        
        
        line_prepender(pdb_chain_file, secondary)
       