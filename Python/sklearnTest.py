# -*- coding: utf-8 -*-
"""
Created on Sat Jun  9 04:08:24 2018

@author: bjwil
"""

from sklearn import datasets
import numpy as np

digits = datasets.load_digits()

import pandas as pd

digits = pd.read_csv("http://archive.ics.uci.edu/ml/machine-learning-databases/optdigits/optdigits.tra", header = None)
digits.ix[:,0:1].head(10)

np.sqrt((8/3-2)**2 + 2/3**2 + (4-8/3-2/3)**2)
