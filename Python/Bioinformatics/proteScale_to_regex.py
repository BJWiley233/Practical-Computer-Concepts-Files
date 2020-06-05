# -*- coding: utf-8 -*-
"""
Created on Wed Jun  3 00:38:38 2020

@author: bjwil
"""


def prosite2regex(prosite):
    '''
    Converts Prosite PAttern to Regex
    @Link https://prosite.expasy.org/prosuser.html#conv_pa
    @TODO needs hydrophilic to any other terms/letters that represent group
    of amino acids
        
    Parameters
    ------------
    prosite : str
        Prosite PAttern
        
    Returns
    --------
    reg_pattern : str
        A regex pattern to compile with re.compile()
        
    Imports
    --------
    re
    
    Examples
    ---------
    >>> # pattern for PKA phoshorylation site motif
    >>> prosite_pat = 'x-R-[RL]-x-[ST]-Hydrophobic'
    >>> regex_pat = prosite2regex(prosite_pat)
    >>> regex_pat
    Out[]: '[A-Z]R[RL][A-Z][ST][AILMFWYV]'
    
    

    '''
    import re
    
    bracket = re.compile('\[')
    n_term =  re.compile('<')
    any_ = re.compile('x|X')
    c_term = re.compile('>')
    except_ = re.compile('{')
    paran = re.compile('\(')
    comma = re.compile('\,')
    ## for [ST](2) or [DE](3) which is 3 Neg
    close_bracket_paran = re.compile('\]\([0-9]')
    comma_between_brackets = re.compile('\[.*,.*\]')

    prosite_array = prosite.split('-')
    reg_pattern = ''
    if n_term.search(prosite_array[0]):
        reg_pattern += '^'
    for pat in prosite_array:
        # brackets []
        if bracket.match(pat):
            # [x(3),x(4)] and not [DE]{3,6}
            if (comma.search(pat.strip('[]')) and 
                comma_between_brackets.search(pat)):
                reg_pattern += '('
                pat_list = pat.strip('[]').split(',')
                # ProSite [x(3),x(4)] = Regex ([A-Z]{3}|[A-Z]{4}|)
                for p in pat_list:
                    if any_.match(p):
                        reg_pattern += '[A-Z]'
                        if paran.search(p) and re.search('\d', p):
                            reg_pattern += ('{' + re.search('\d', p).group() 
                                            + '}')
                    reg_pattern += '|'
                reg_pattern += ')'
            # [DE](3) multiple letters n amount of times
            # [DE](3,7) multiple letters from to amount of times
            elif close_bracket_paran.search(pat):
                new_pat = re.sub('\(', '{', pat)
                new_pat = re.sub('\)', '}', new_pat)
                reg_pattern += new_pat
            # [ACTL]
            else:
                reg_pattern += pat
        ## x(2,4) or T(4) n
        elif bracket.match(pat) is None and paran.search(pat):
            # x and not T set x to X
            pat = any_.sub('[A-Z]', pat)
            # basically now just switch out Prosite () for Regex {}
            new_pat = re.sub('\(', '{', pat)
            new_pat = re.sub('\)', '}', new_pat)
            reg_pattern += new_pat
        # doesn't include {}         
        elif except_.match(pat):
            new_pat = re.sub('{', '[^', pat)
            new_pat = re.sub('}', ']', new_pat)
            reg_pattern += new_pat
        # any hydrophobic residue [AILMFWYV]
        elif pat.lower() == 'hydrophobic':
            reg_pattern += '[AILMFWYV]'
        # else just single amino acid
        else:
            pat = any_.sub('[A-Z]', pat)
            reg_pattern += pat
    if c_term.search(prosite_array[-1]):
        reg_pattern += '?'           
            
    return reg_pattern
                    

##############################################################################

## Tests

##############################################################################
import re
protein = 'PPPALTAYVCCTMMW'
prosite = '[ACTL](2,4)-x-V-x(2,4)-{ED}-[x(3),x(4)]'
re.search(prosite2regex(prosite), protein)

## Test unambiguities as in lecture 2 discussion pos
protein = 'PPPALTAYVIGALMCCTMMW'
prosite = '[ACTL](2,4)-x-VIGALM-x(2,4)-{ED}-[x(3),x(4)]'
re.search(prosite2regex(prosite), protein)

## Actually this is incorrect for PROSITE [x(3),x(4)] you can't have this!
prosite = '[ACTL](2,4)-x-VIGALM-x(2,4)-{ED}-x(3,4)'  ## Can't have this either https://prosite.expasy.org/scanprosite/scanprosite_doc.html#mo_motifs_pattern_syntax
prosite = '[ACTL](2,4)-x-VIGALM-x(2,4)-{ED}-x(3,4)>'  ## Must have an anchor
## Now it works for option 3: https://prosite.expasy.org/cgi-bin/prosite/ScanView.cgi?scanfile=6875429115319.scan.gz&sig=[ACTL](2,4)-x-VIGALM-x(2,4)-{ED}-x(3,4)%3E
re.search(prosite2regex(prosite), protein)


## Phosphorylation
    ## Aaa-Aaa-X-Aaa-Tyr = [ILVA](2)-x-[ILVA]-Y       :Aaa is aliphatic
prosite2 = '[ILVA](2)-x-[ILVA]-Y'
prosite2regex(prosite2)
re.search(prosite2regex(prosite2), protein)

def read_single_fa(file):
    seq = {}
    header = re.compile('^>')
    sequence = ''
    with open(file) as f:
        line = f.readline()
        if header.match(line):
            seq_name = line
        else:
            seq_name = None
        for line in f:
            sequence += line.strip()
        seq[seq_name] = sequence 
    
    return seq


file = 'C:\\Users\\*****\\JHU Classes\\Protein Bioinformatics\\Midterm\\CAC1A_1.fasta'
protein_CACNA1A = read_single_fa(file)
## get sequence
protein_CACNA1A_seq = [i for i in protein_CACNA1A.values()][0]
# Motif for phoshorylation by Protein Kinase A (PKA)
# Hydrophobic [AILMFWYV]
# x-R-[RK]-x-[ST]-[AILMFWYV]
prosite3 = 'x-R-[RK]-x-[ST]-Hydrophobic'
regex3 = prosite2regex(prosite3)
# TRDS S I      S1821
re.search(regex3, protein_CACNA1A_seq)
get_matches(prosite2regex('R-[DRK]-X-[S]'), protein_CACNA1A_seq)
# N-glycosylation
get_matches(prosite2regex('N-{P}-[ST]-{P}'), protein_CACNA1A_seq)
file_variantA712T = 'C:\\Users\\bjwil\\JHU Classes\\Protein Bioinformatics\\Midterm\\CAC1A_1_mutation_A712T.fasta'
protein_CACNA1A_A712 = read_single_fa(file_variantA712T)
protein_CACNA1A_seq_A712T = [i for i in protein_CACNA1A_A712.values()][0]
## protein_CACNA1A_seq_A712T[709:713]
get_matches(prosite2regex('N-{P}-[ST]-{P}'), protein_CACNA1A_seq_A712T)

# https://www.uniprot.org/uniprot/O00555
for m in re.compile(regex3).finditer(protein_CACNA1A_seq):
    print('start site: {}, end site: {}, pattern found: {}'.format(m.start(), 
                                                                   m.end(), 
                                                                   m.group()))

def get_matches(pattern, protein):
    for m in re.compile(pattern).finditer(protein):
        print('start site: {}, end site: {}, pattern found: {}'.format(m.start(), 
                                                                       m.end(), 
                                                                       m.group()))

## https://www.uniprot.org/uniprot/P46020#ptm_processing
file = 'C:\\Users\\*****\\JHU Classes\\Protein Bioinformatics\\Code\\PHKA1.fasta'
## get sequence
sequence_GPK_regulatory_subunit_alpha = [i for i in read_single_fa(file).values()][0]
get_matches(regex3, sequence_GPK_regulatory_subunit_alpha)
## this returns 1013-1018 with 0 index, i.e. residues 1014-1019
sequence_GPK_regulatory_subunit_alpha[1013:1019]
## prints phoshoserine site 1018 of GPK (aka Phoshorylase b kinase)
sequence_GPK_regulatory_subunit_alpha[1018-1]


file = 'C:\\Users\\*****\\JHU Classes\\Protein Bioinformatics\\Code\\PDE3.fasta'
## get sequence
sequence_PDE = [i for i in read_single_fa(file).values()][0]
get_matches(regex3, sequence_PDE)
## this returns 1013-1018 with 0 index, i.e. residues 1014-1019
sequence_PDE[1013:1019]
## prints phoshoserine site 1018 of GPK (aka Phoshorylase b kinase)
sequence_PDE[190-1]



from Bio import Entrez
from Bio import SeqIO
Entrez.email = '******@jh.edu'

def fetch2(ID):
    handle = Entrez.efetch(db='protein', id=ID, 
                           rettype='fasta', retmode='text')
    seq_records = [rec for rec in SeqIO.parse(handle, "fasta")]
    SeqIO.write(seq_records, 'out.fasta', 'fasta')
    
    return seq_records if len(ID) > 1 else seq_records[0]

ID = {'1':'P27815', '2':'AAU82096', '7': 'NP_001230050'}
ID_seqs = {}
sequences = fetch2(list(ID.values()))
if len(sequences) == len(ID):
    print("Got all sequences")
    for i, k in enumerate(ID.keys()):
        ID_seqs[k] = sequences[i]

for seq in [i.seq for i in sequences]:
    get_matches(regex3, str(seq))
    
prosite2regex(prosite3)
## It's actually MAPKAPK2 phosphorylation motif Hyd-X-R-X2-S for P27815 isoform 1
# https://www.uniprot.org/uniprot/P49137
get_matches(prosite2regex('Hydrophobic-X-R-X(2)-S'), str(sequences[0].seq))
str(sequences[0].seq)[152-1]
str(sequences[0].seq)[165-1]
