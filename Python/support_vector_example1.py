# -*- coding: utf-8 -*-
"""
Created on Sat Apr 20 23:40:16 2019

@author: bjwil
"""

import numpy as np
from algorithms.classifiers.loss_grad_logistic import *
from algorithms.classifiers.loss_grad_softmax import *
from algorithms.classifiers.loss_grad_svm import *


class LinearClassifier:
    
    def __init__(self):
        self.W = None
        
    def train(self, X, y, method='sgd', batch)