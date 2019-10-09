# -*- coding: utf-8 -*-
"""
Created on Wed Feb 27 20:56:42 2019

@author: bjwil
"""

import pyteomics
from pyteomics import parser
parser.is_modX('pTx')
parser.is_modX('K')
parser.parse('AcPEPTIDE', split=True)
