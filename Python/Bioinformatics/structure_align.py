#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Jul 26 02:31:36 2020

@author: coyote

Examples in Chimera:
    runscript /home/coyote/pdb_files/structure_align.py /home/coyote/pdb_files/ -f 2d5rA.pdb,4b8cA.pdb -s -sec_frac 0.75
    runscript /home/coyote/pdb_files/structure_align.py /home/coyote/pdb_files/ -f 2d5rA.pdb,4b8cA.pdb

Example via Command Line:
    With Gui:
        chimera --script "structure_align.py /home/coyote/pdb_files/ -f 2d5rA.pdb,4b8cA.pdb -s --sec_frac 0.75"
    Without Gui:
    chimera --nogui --script "structure_align.py /home/coyote/pdb_files/ -f 2d5rA.pdb,4b8cA.pdb -s --sec_frac 0.75"

Help via Command Line:
    chimera --nogui --script "structure_align.py -h"

"""


import os
from chimera import runCommand as rc # use 'rc' as shorthand for runCommand
from chimera import replyobj # for emitting status messages

# change to folder with data files


if __name__ == "__main__":
    """ Chain Matchmaker """
    import sys
    import argparse
    
    parser = argparse.ArgumentParser(description="Get 2 PDB ID chains, \
                                     superimpose them and call Match > Align")
    parser.add_argument("dir", help="Required directory for PDB files")     
    parser.add_argument("-f", "--files", required=True,
                        help="Only 2 PDB chain files. \n \
                            Comma sperated List no spaces!")
    parser.add_argument("-s", "--sec_struct", action='store_true',
                        help="Use secondary structure") 
    
    parser.add_argument("--sec_frac",
                        help="Fraction is the relative weight of the \n \
                            secondary structure term and can range from 0 \n \
                            to 1 (default 0.3). Ignored if --sec_struct=False")
    args = parser.parse_args()
    os.chdir(args.dir)
    chain_files = args.files
    file_names = chain_files.split(",")

    
    if not len(file_names) == 2:
        print("Must enter 2 and only 2 PDB files with chains")
        sys.exit()
    
    for fn in file_names:
        print(fn)
        replyobj.status("Processing " + fn) # show what file we're working on
        rc("open " + fn)
    
    if args.sec_struct:
        if args.sec_frac:
            rc("mm #0 #1 ss {}".format(args.sec_frac))
        else:
            rc("mm #0 #1")
    else:
        rc("mm #0 #1 ss False")
            
from chimera.tkgui import saveReplyLog
## could probably strip extensions if you want shorter file name for reply log file
saveReplyLog("{}_{}_match.txt".format(file_names[0], file_names[1]))

"""
Not implemented Match > Align

1) Getting the list of open molecules:

from chimera import openModels, Molecule
mols = openModels.list(modelTypes=[Molecule])

2) Getting the list of chains to use.  This example code assumes they're chain A:

chains = [m.sequence('A') for m in mols]

3)  Call Match->Align to create the alignment.

from StructSeqAlign import makeAlignment
mav = makeAlignment(chains)

Note that the makeAlignment call will only return the Multalign Viewer instance starting with tomorrow's daily build (i.e. I made that change today!).  Also, the makeAlignment call has a lot of optional arguments to change the parameters used in computing the alignment (e.g. cutoff, iteration, reference chain).  Look at <your Chimera>/share/StructSeqAlign/__init__.py to see what the options are if you need to change the default behavior.  (On a Mac, "<your Chimera>" is Chimera.app/Contents/Resources).

4) Save the alignment to a FASTA format file (named "x.fa") and Quit the MAV instance:

f = open("x.fa", "w")
from MultAlignViewer.formatters.saveFASTA import save
save(f, mav, mav.seqs, mav.fileMarkups)
f.close()
mav.Quit()
"""
