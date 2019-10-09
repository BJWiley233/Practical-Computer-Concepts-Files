# -*- coding: utf-8 -*-
"""
Created on Sun Mar 18 18:03:31 2018

@author: bjwil
"""
import numpy as np
import os
os.getcwd()
import tensorflow as tf
Input=tf.placeholder('float', shape = [None,2], name="Input")
inputBias = tf.Variable(initial_value = tf.random_normal(shape = [3], stddev = 0.4), dtype = 'float', name = 'input_bias')

weights = tf.Variable(initial_value = tf.random_normal(shape = [2,3], stddev = 0.4), dtype = 'float', name = 'hidden_layer')
hiddenBias = tf.Variable(initial_value = tf.random_normal(shape = [1], stddev = 0.4), dtype = 'float', name = 'hidden_bias')

output = tf.Variable(initial_value = tf.random_normal(shape = [3,1], stddev = 0.4), dtype = 'float', name = 'hidden_bias')

hiddenLayer = tf.matmul(Input,weights)
hiddenLayer = hiddenLayer + hiddenBias