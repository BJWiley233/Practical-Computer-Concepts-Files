# -*- coding: utf-8 -*-
"""
Created on Mon May 14 16:28:04 2018

@author: bjwil
"""

Motifs = [
"TCGGGGGTTTTT",
"CCGGTGACTTAC",
"ACGGGGATTTTC",
"TTGGGGACTTTT",
"AAGGGGACTTCC",
"TTGGGGACTTCC",
"TCGGGGATTCAT",
"TCGGGGATTCCT",
"TAGGGGAACTAC",
"TCGGGTATAACC"
]

def functionColumnSumApply(matrix):
    i=0
    j=0
    matrixProb = matrix/10
    totalSum = 0
    subProb = 0
    colSum = 0
    for j in range(0,matrixProb.shape[1]):
        colSum = 0
        for i in range(0,matrixProb.shape[0]):
            if matrixProb[i,j] == 0:
                subProb = 0
            else: 
                subProb = matrixProb[i,j]*math.log(matrixProb[i,j],2)
            colSum += subProb 
        totalSum += (-(colSum))
    return '%.4f' % round(totalSum,4)


def scoreMatrix(array):
    matrix = np.zeros((4,len(Motifs[0])))
    aCount = 0
    cCount = 0
    gCount = 0
    tCount = 0
    for j in range(len(Motifs[0])):
        acgtArray = []
        aCount = 0
        cCount = 0
        gCount = 0
        tCount = 0
        for i in range(len(Motifs)):
            if Motifs[i][j] == 'A':
                aCount += 1
            elif Motifs[i][j] == 'C':
                cCount += 1
            elif Motifs[i][j] == 'G':
                gCount += 1
            elif Motifs[i][j] == 'T':
                tCount += 1
        acgtArray.extend([aCount, cCount, gCount, tCount])  
        for i in range(0,4):
            matrix[i][j] = acgtArray[i]


    return functionColumnSumApply(matrix)

scoreMatrix(Motifs)