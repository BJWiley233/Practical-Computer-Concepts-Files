# -*- coding: utf-8 -*-
"""
Created on Sat Jul 28 21:36:02 2018

@author: bjwil
"""

import MySQLdb

# Open database connection
db = MySQLdb.connect(host='BJWiley23.mysql.pythonanywhere-services.com',
                     user='BJWiley23', passwd='Brian_MySQL23',
                     db='BJWiley23$SCC-SUM18-CIS156-BWiley')

sql = """INSERT INTO recipes (recipe_id, recipe_name, recipe_calories)
      VALUES (%d, %s, %d)""", [
      (12, "Eggs Benedict", 275),
      (13, "Hamburgers", 350),
      (14, "Ice Cream", 250)
      ]
      
sql ="""INSERT INTO breakfast (name, spam, eggs, sausage, price)
      VALUES (%s, %s, %s, %s, %s)""",
      [
      ("Spam and Sausage Lover's Plate", 5, 1, 8, 7.95 ),
      ("Not So Much Spam Plate", 3, 2, 0, 3.95 ),
      ("Don't Wany ANY SPAM! Plate", 0, 4, 3, 5.95 )
      ]
      
from Bio.PDB import InterfaceBuilder

parser = PDBParser()

structure = parser.get_structure('test', 'p38.pdb')

interface = InterfaceBuilder.InterfaceBuilder(structure[0]).get_interface()

from prody import *
from pylab import *
ion()
p38 = parsePDB('1p38')
p38

import matplotlib
#matplotlib.use('qt5agg')
import matplotlib.pyplot as plt
import scipy
from scipy.fftpack import fftshift
import numpy as np
from IPython import get_ipython

x = np.arange(-3, 3, 0.01)
y = np.zeros(len(x))
y[150:450] = 1
plt.plot(x, y) # plot of the step function

yShift = fftshift(y) # shift of the step function
Fourier = scipy.fft(yShift) # Fourier transform of y implementing the FFT
Fourier = fftshift(Fourier) # inverse shift of the Fourier Transform
plt.plot(Fourier) # plot of the Fourier transform
