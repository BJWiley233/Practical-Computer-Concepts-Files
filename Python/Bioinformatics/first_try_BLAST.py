# -*- coding: utf-8 -*-
"""
Created on Thu Apr  5 00:24:09 2018

@author: bjwil

Trying to learn how to imeplement a BLAST.  This is old.
"""


stringToMatchAgainst = 'TGTTTTATATACTGTCA'
sequenceString = 'AGTTACTG'


min_Sum = 0
cum_Sum = 0
max_Sum = float("-inf")
diffMaxMin = 0
highestDiffMaxMin = 0
placeOfMin = 0
placeOfMax = float("inf")
arrayStartFinishScore = [0, 0, 0, 0] # jWindow, Score, Start Index, End Index
arrayStartToFinishLettersToMatchAgainst = ''
arrayWhereLettersToMatchAgainst = [0,0]
arrayStartToFinishSequenceString = ''
highestDiffMaxMin = 0

for j in range(len(stringToMatchAgainst)-len(sequenceString)+1):
    min_Sum = 0
    cum_Sum = 0
    max_Sum = float("-inf")
    diffMaxMin = 0
    placeOfMin = 0
    placeOfMax = float("inf")
    pattern = stringToMatchAgainst[j:j+len(sequenceString)]
    for i in range(len(sequenceString)):
        if sequenceString[i] == pattern[i]:
            cum_Sum += 1
            max_Sum = cum_Sum - min_Sum
            if max_Sum > diffMaxMin:
                diffMaxMin = max_Sum
        else:
            cum_Sum -= 1
            if cum_Sum > max_Sum:
                max_Sum = cum_Sum
            if cum_Sum < min_Sum:
                min_Sum = cum_Sum
                placeOfMin = i + 1
                if placeOfMin < placeOfMax and diffMaxMin >= highestDiffMaxMin:
                    arrayStartFinishScore[2] = placeOfMin
        if diffMaxMin > highestDiffMaxMin:
                placeOfMax = i
                highestDiffMaxMin = diffMaxMin
                arrayStartFinishScore[0] = j
                arrayStartFinishScore[1] = highestDiffMaxMin
                arrayStartFinishScore[2] = placeOfMin
                arrayStartFinishScore[3] = i
                arrayStartToFinishSequenceString = sequenceString[arrayStartFinishScore[2]:arrayStartFinishScore[3]+1]
                arrayWhereLettersToMatchAgainst[0] = j + placeOfMin
                arrayWhereLettersToMatchAgainst[1] = j + i
                arrayStartToFinishLettersToMatchAgainst = pattern[arrayStartFinishScore[2]:arrayStartFinishScore[3]+1]
        #print('CumSum ', cum_Sum)
        #print('MinSum ', min_Sum)
        #print('MaxSum ', max_Sum)
        #print('Diff ', diffMaxMin)
        #print(arrayStartFinishScore, arrayStartToFinishLetters)

print(arrayStartFinishScore, arrayStartToFinishSequenceString, arrayWhereLettersToMatchAgainst, arrayStartToFinishLettersToMatchAgainst)


    
def combination(k):
    return (''.join(p) for p in itertools.product('ATCG', repeat=k))
    
