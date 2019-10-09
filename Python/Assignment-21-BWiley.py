# -*- coding: utf-8 -*-
"""
Created on Thu Jul 12 11:33:17 2018

@author: bjwil
"""

# import url request and Counter libraries
import urllib.request
from collections import Counter
import string

# set url
url = 'https://norvig.com/big.txt'

# retrieve url and save it to current working directory.    
urllib.request.urlretrieve(url, 'Sherlock_Holmes.txt')

# request word from user
#word = input('What word should I search for? ')
word = "whatever"
# set word to lower case for later search
wordLower = word.lower()

# set punctuation for replacement during reading
''' example when searching for 'pocket' should return 7 but because pocket
is followed by puncuation 6 out of 7 times it only returns 1.  Also if you just remove
punctuation and don't replace with a ' ' it will only return pocket 5 times because 'waistcoat-pocket'
appears twice and removing punctuation only returns 'waistcoatpocket' instead of 'waistcoat' and 'pocket'.
Alice actually appears 403 times in the text.
See below for source of code:
https://github.com/StevenCHowell/type_token_ratio/issues/3
'''
punc = string.punctuation
replace_punc = str.maketrans(punc, ' '*len(punc))

if any(set(punc).intersection(set(word))):
    with open('Sherlock_Holmes.txt', 'x+') as f:
        # read in text file and tranlate all punctuation to 1 white space
        text = f.read()
        # create Counter dictionary and coerce to lower case
        wordCount = Counter(text.lower().split())    

else:
# open downloaded .txt file.  Initial during testing needed encoding to be utf-8 but works without it
    with open('Sherlock_Holmes.txt', 'r') as f:
        # read in text file and tranlate all punctuation to 1 white space
        text = f.read().translate(replace_punc)
        # create Counter dictionary and coerce to lower case
        wordCount = Counter(text.lower().split())

# print statment of word searched in original case and how many times it was found
print('I found the word "{}" {} time(s).'.format(word,wordCount[wordLower]))

