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
import re
protein = 'PPPALTAYVCCTMMW'
prosite = '[ACTL](2,4)-x-V-x(2,4)-{ED}-[x(3),x(4)]'
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


file = 'C:\\Users\\<home>\\JHU Classes\\Protein Bioinformatics\\Midterm\\CAC1A_1.fasta'
protein_CACNA1A = read_single_fa(file)
## get sequence
protein_CACNA1A_seq = [i for i in protein_CACNA1A.values()][0]
# Motif for phoshorylation by Protein Kinase A (PKA)
# Hydrophobic [AILMFWYV]
prosite3 = 'x-R-[RL]-x-[ST]-Hydrophobic'
regex3 = prosite2regex(prosite3)
re.search(regex3, protein_CACNA1A_seq)

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
file = 'C:\\Users\\<home>\\JHU Classes\\Protein Bioinformatics\\Code\\PHKA1.fasta'
## get sequence
sequence_GPK_regulatory_subunit_alpha = [i for i in read_single_fa(file).values()][0]
get_matches(regex3, sequence_GPK_regulatory_subunit_alpha)
## this returns 1013-1018 with 0 index, i.e. residues 1014-1019
sequence_GPK_regulatory_subunit_alpha[1013:1019]
## prints phoshoserine site 1018 of GPK (aka Phoshorylase b kinase)
sequence_GPK_regulatory_subunit_alpha[1018-1]