# -*- coding: utf-8 -*-
"""
Created on Wed Jul 11 15:36:53 2018

@author: bjwil
"""

import os
import sys
import pprint
from datetime import datetime
import csv

# get user's current path  
current_path = os.path.dirname(__file__)
# create a relative path 
rel_path = "/buzzers.csv"

# create list of data in HeadFirst
my_data = [['TIME',
           '09:35',
           '17:00',
           '09:55',
           '19:00',
           '10:45',
           '12:00',
           '11:45',
           '17:55'], 
          ['DESTINATION',
           'FREEPORT', 
           'FREEPORT', 
           'WEST END',
           'WEST END',
           'TREASURE CAY',
           'TREASURE CAY',
           'ROCK SOUND',
           'ROCK SOUND']]

# transpose to write in same format as HeadFirst
transpose_Data = map(list, zip(*my_data))

# write data to csv file
with open(current_path+rel_path, 'w', newline ='') as myFile:  
   writer = csv.writer(myFile)
   writer.writerows(transpose_Data)
   
# change path to folder where CSV is created or in the open statement below call full path for buzzers which I did
# os.chdir('C:\\Users\\bjwil\\Python College Course')

# function to strip and string shift %H to %I for 24 to 12 hour format and %p gives the AM/PM format.  Pretty nice that R does same thing.
def convert2ampm(time24: str) -> str:
    return datetime.strptime(time24, '%H:%M').strftime('%I:%M%p')

# read in data from csv
with open(current_path+rel_path) as data:
    # ignore column headers
    ignore = data.readline()
    # create blank dictionary
    flights = {}
    # for each line in data from csv split the time and destination by comma for csv format
    for line in data:
        k, v = line.strip().split(',')
        # for each time key add the destination as value
        flights[k] = v
   
# print flight data from csv
pprint.pprint(flights)
print()

# manipulate data for time to time string format (12 hour AM/PM) and change case in destination
flights2 = {}
for k, v in flights.items():
    flights2[convert2ampm(k)] = v.title()

pprint.pprint(flights2)

# manipulate data same way as above for flights2 but does in 1 line list comprehension
# creates disctionary where times are the keys and destinations are the values
fts = {convert2ampm(k) : v.title() for k, v in flights.items()}
pprint.pprint(fts)
print()

# rearrange data so that destination are the keys and times are the values
# outside in list comprehension:
    # dest for dest in set(fts.values()) creates a key for every destination -- was values in fts
    # k, v gets the times and destination respectively and puts the k-times variable as values for destination if the v is the dest
when = {dest : [k for k, v in fts.items() if v == dest] for dest in set(fts.values())}
pprint.pprint(when)

