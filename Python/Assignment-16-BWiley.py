# -*- coding: utf-8 -*-
"""
Created on Wed Jul 11 15:36:53 2018

@author: bjwil
"""

import os
import pprint
from datetime import datetime

os.chdir('C:\\Users\\bjwil\\Python College Course')

def convert2ampm(time24: str) -> str:
    return datetime.strptime(time24, '%H:%M').strftime('%I:%M%p')

with open('buzzers.csv') as data:
    ignore = data.readline()
    flights = {}
    for line in data:
        k, v = line.strip().split(',')
        flights[k] = v
   


pprint.pprint(flights)
print()
fts = {convert2ampm(k) : v.title() for k, v in flights.items()}
pprint.pprint(flights)
print()
when = {dest : [k for k, v in fts.items() if v == dest] for dest in set(fts.values())}
pprint.pprint(when)