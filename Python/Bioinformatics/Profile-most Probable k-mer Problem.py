# -*- coding: utf-8 -*-
"""
Created on Wed May 23 02:05:57 2018

@author: bjwil
"""

import re 
import numpy as np
from scipy import stats
import collections
import random

# THIS score() is for the original greedy and worked but not for the random greedy
def score(Motifs):
    score = 0
    totalScore = 0
    mostFrequent = stats.mode(Motifs)[0][0]
    for text in Motifs:
        score = hamming_distance(mostFrequent, text)
        totalScore += score
    return totalScore

# This is the score required for
def newScore(initial_motifs, k):
    c = Counter()
    score = 0
    testList = [list(item) for item in initial_motifs]
    for i in range(0, len(testList[0])):
        c.clear()
        for j in range(0, len(testList)):
            c += Counter(testList[j][i])
            mostCommon = c.most_common(1)[0][1]
        score += len(testList) - mostCommon
    return score


def window(s, k):
    for i in range(1 + len(s) - k):
        yield s[i:i+k]
        
def chunks(l, n):
    # For item i in a range that is a length of l,
    for i in range(0, len(l), n):
        # Create an index range for l of n items:
        yield l[i:i+n]

def hamming_distance(pattern, seq):
    return sum(c1 != c2 for c1, c2 in zip(pattern, seq))


def profileMostProbably(Dna, k, matrix):  
    answer = ''
    maxSum = -1
    textSum = 0
    for text in window(Dna,k):
        multiplyRange = []
        textSum = 0
        for i in range(0,len(text)):
            multiplyRange.append(matrix[text[i]][i])
        textSum = np.prod(multiplyRange)
        if textSum > maxSum:
            maxSum = textSum
            answer = text
    return answer

def profileScore(profileList):
    Profile = {}  
    for k in range(0,len(profileList[0])):
        countA = 0
        countC = 0
        countG = 0
        countT = 0
        for ii in range(0,len(profileList)):
            if profileList[ii][k] == 'A':
                countA+=1
            if profileList[ii][k] == 'C':
                countC+=1  
            if profileList[ii][k] == 'G':
                countG+=1
            if profileList[ii][k] == 'T':
                countT+=1 
        Profile.setdefault('A',[]).append(countA/len(profileList))
        Profile.setdefault('C',[]).append(countC/len(profileList))
        Profile.setdefault('G',[]).append(countG/len(profileList))
        Profile.setdefault('T',[]).append(countT/len(profileList))
    
    return Profile

def profileScorePsuedo(profileList):
    Profile = {}  
    for k in range(0,len(profileList[0])):
        countA = 1
        countC = 1
        countG = 1
        countT = 1
        for ii in range(0,len(profileList)):
            if profileList[ii][k] == 'A':
                countA+=1
            if profileList[ii][k] == 'C':
                countC+=1  
            if profileList[ii][k] == 'G':
                countG+=1
            if profileList[ii][k] == 'T':
                countT+=1 
        Profile.setdefault('A',[]).append(countA/(len(profileList)+4))
        Profile.setdefault('C',[]).append(countC/(len(profileList)+4))
        Profile.setdefault('G',[]).append(countG/(len(profileList)+4))
        Profile.setdefault('T',[]).append(countT/(len(profileList)+4))

    return Profile

def Motif(Dna, k, matrix):  
    answer = []
    for DNA in Dna:
        maxSum = -1
        textSum = 0
        bestInLine = ''
        for text in window(DNA,k):
            multiplyRange = []
            textSum = 0
            for i in range(0,len(text)):
                multiplyRange.append(matrix[text[i]][i])
            textSum = np.prod(multiplyRange)
            if textSum > maxSum:
                maxSum = textSum
                bestInLine = text
        answer.append(bestInLine)
    return answer

## This uses the original score() definition that worked for the original greedy
## but doesn't work for teh random greedy
def Greedy(Dna_Input, k, t):
    lowestScoreMotif = float('inf')
    lowestScoreMotifStrings = []  
    for text in window(Dna_Input[0],k):
        currentScore = 0
        Profile = []
        # How to create motif profile
        Profile.append(text)       
        for i in range(1,t):
            motifProfile = profileScore(Profile)
            motifI = profileMostProbably(Dna_Input[i], k, motifProfile)
            Profile.append(motifI)
        currentScore = score(Profile)
        if currentScore < lowestScoreMotif:
            lowestScoreMotif = currentScore
            lowestScoreMotifStrings = Profile

    return lowestScoreMotifStrings


def random_kmer_selection(k,t,Dna_Input):

    l = len(Dna_Input[0])
    kmers = []
    for dna in Dna_Input:
        n = random.randrange(l-k)
        kmers.append(dna[n:n+k])
    return kmers

def random_motifs(k,t,Dna_Input):

    bestmotifs = random_kmer_selection(k,t,Dna_Input)
    initial_motifs = random_kmer_selection(k,t,Dna_Input)
    while True:
        motifList = []
        profileBrian = profileScorePsuedo(initial_motifs)
        for i in range(0,t):
            motifI = profileMostProbably(Dna_Input[i], k, profileBrian)
            motifList.append(motifI)
        if newScore(motifList, k) < newScore(bestmotifs, k):    
            bestmotifs = motifList
            initial_motifs = motifList # why do we need this?
        else:
            yield bestmotifs
            break      

def GreedyPsuedo(Dna_Input, k, t):
    lowestScoreMotif = float('inf')
    lowestScoreMotifStrings = []  
    i = 0
    while True:
        bestMotifs = list(random_motifs(k, t, Dna_Input))[0]
        bestScore = newScore(bestMotifs, k)
        if bestScore < lowestScoreMotif:
            lowestScoreMotif = bestScore
            lowestScoreMotifStrings = bestMotifs
            i = 0
        else:
            i += 1
        if i > 1000:
            break
    return lowestScoreMotifStrings


DNA = ['CGCCCCTCTCGGGGGTGTTCAGTAAACGGCCA',
       'GGGCGAGGTATGTGTAAGTGCCAAGGTGCCAG',
       'TAGTACCGAGACCGAAAGAAGTATACAGGCGT',
       'TAGATCAAGTTTCAGGTGCACGTCGGTGAACC',
       'AATCCACCAGCTCCACGTGCAATGTTGGCCTA']

k = 8
t = 5

print(*GreedyPsuedo(DNA, k, t), sep = '\n')

'''with open ('dataset_161_5 (7).txt', 'r') as in_file:
    lines = in_file.read().splitlines()
    Dna_Input = lines[1:]
    k, t = str.split(lines[0])
    k = int(k)
    t = int(t)
print(*GreedyPsuedo(Dna_Input, k, t), sep = '\n')'''




## this was for the one where it was putting dna on two or more lines so
## we had to use regular expression to get it to combine to 1 DNA string.
'''with open ('most_Probable1.txt', 'r') as in_file:
    lines = ''
    for line in in_file:
        if re.match(r'^[A-Za-z]', line):
            lines = re.sub('\n$', '', lines)
        lines = ''.join([lines, line])
    
    newLines = lines.split()   
      
    Dna = newLines[0]
    k = int(newLines[1])
    profile = list(map(float, newLines[2:]))
    #W = np.mat(profile)
    #newW = profile.reshape(4,k)
    new_Profile = list(chunks(profile, k))
    final_Profile = {

    'A': new_Profile[0],
    'C': new_Profile[1],
    'G': new_Profile[2],
    'T': new_Profile[3]
     }



profileMostProbably(Dna, k, final_Profile)
'''



  

      








