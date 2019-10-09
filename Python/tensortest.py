# -*- coding: utf-8 -*-
"""
Created on Mon Feb 18 17:39:17 2019

@author: bjwil
"""

import tensorflow as tf
import os
import skimage
from skimage import io, transform
import numpy as np
import matplotlib.pyplot as plt 
from pylab import plot, gcf
from skimage.color import rgb2gray


def load_data(data_directory):
    directories = [d for d in os.listdir(data_directory) 
                   if os.path.isdir(os.path.join(data_directory, d))]
    labels = []
    images = []
    for d in directories:
        label_directory = os.path.join(data_directory, d)
        file_names = [os.path.join(label_directory, f) 
                      for f in os.listdir(label_directory) 
                      if f.endswith(".ppm")]
        for f in file_names:
            images.append(skimage.data.imread(f))
            labels.append(int(d))
    return images, labels

ROOT_PATH = "C:/Users/bjwil/Downloads/"
train_data_directory = os.path.join(ROOT_PATH, "TrafficSigns/Training")
test_data_directory = os.path.join(ROOT_PATH, "TrafficSigns/Testing")

images, labels = load_data(train_data_directory)

print(np.asarray(images).ndim)
print(np.asarray(labels).ndim)
print(np.asarray(images).size)
print(np.asarray(labels).size)
images[0]

plt.hist(labels, 62)

t_signs = [300, 2250, 3650, 4000]

for i in range(len(t_signs)):
    plt.subplot(2, 2, i+1)
    plt.axis('off')
    plt.imshow(images[t_signs[i]])
    plt.subplots_adjust(wspace=0.5, hspace=0.5)
    plt.show()
    print("shape: {}, min: {}, max {}".format(images[t_signs[i]].shape,
                                              images[t_signs[i]].min(),
                                              images[t_signs[i]].max()))

plot([0.5, 0.5], [0, 1], color='red',
lw=5,transform=gcf().transFigure, clip_on=False)
plot([0, 1], [0.5, 0.5], color='red',
lw=5,transform=gcf().transFigure, clip_on=False)

unique_labels = set(labels)
plt.figure(figsize=(15, 15))

for i, k in enumerate(unique_labels):
    image = images[labels.index(k)]
    plt.subplot(8, 8, i+1)
    plt.axis('off')
    plt.title("Label {} ({})".format(k, labels.count(k)))
    plt.imshow(image)
    
images28 = [transform.resize(image, (28,28)) for image in images]
print(np.array(images28).shape)

for i in range(len(t_signs)):
    plt.subplot(2, 2, i+1)
    plt.axis('off')
    plt.imshow(images28[t_signs[i]])
    plt.subplots_adjust(wspace=0.5, hspace=0.5)
    plt.show()
    print("shape: {}, min: {}, max {}".format(images28[t_signs[i]].shape,
                                              images28[t_signs[i]].min(),
                                              images28[t_signs[i]].max()))

images28gray = rgb2gray(np.array(images28))

for i in range(len(t_signs)):
    plt.subplot(1, 4, i+1)
    plt.axis('off')
    plt.imshow(images28gray[t_signs[i]], cmap="gray")
    plt.subplots_adjust(wspace=0.5, hspace=0.5)
    #plt.show()
    #print("shape: {}, min: {}, max {}".format(images28gray[t_signs[i]].shape,
                                              #images28gray[t_signs[i]].min(),
                                              #images28gray[t_signs[i]].max()))

x = tf.placeholder(dtype = tf.float32, shape = [None, 28, 28])
y = tf.placeholder(dtype = tf.int32, shape = [None])


images_flat = tf.contrib.layers.flatten(x)

logits = tf.contrib.layers.fully_connected(images_flat, 62, tf.nn.relu)

loss = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(labels = y,
                                                                     logits = logits))


train_op = tf.train.AdamOptimizer(learning_rate=0.001).minimize(loss)
correct_pred = tf.arg_max(logits, 1)
accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))

print("images_flat: ", images_flat)
print("logits: ", logits)
print("loss: ", loss)
print("predicted_labels: ", correct_pred)

tf.set_random_seed(1234)
sess = tf.Session()

sess.run(tf.global_variables_initializer())

for i in range(201):
    print('EPOCH', i)
    _, accuracy_val = sess.run([train_op, accuracy], feed_dict={x: images28gray, y: labels})
    if i % 10 == 0:
        print("Loss: ", loss)
        print('DONE')

import random
# Pick 10 random images
sample_indexes = random.sample(range(len(images28gray)), 10)
sample_images = [images28gray[i] for i in sample_indexes]
sample_labels = [labels[i] for i in sample_indexes]

# Run the "correct_pred" operation
predicted = sess.run([correct_pred], feed_dict={x: sample_images})[0]
                        
# Print the real and predicted labels
print(sample_labels)
print(predicted)

# Display the predictions and the ground truth visually.
fig = plt.figure(figsize=(10, 10))
for i in range(len(sample_images)):
    truth = sample_labels[i]
    prediction = predicted[i]
    plt.subplot(5, 2,1+i)
    plt.axis('off')
    color='green' if truth == prediction else 'red'
    plt.text(40, 10, "Truth:        {}\nPrediction: {}".format(truth, prediction), 
             fontsize=12, color=color)
    plt.imshow(sample_images[i],  cmap="gray")
    
blah = 'CCAATTGTTGGCAACAAAGAATCGCTTATGCTAGGGTGACGTGCCAATCG'
len(blah)
string = 'CCAATTGTTGGCAACAAAGAATCGCTTATGCTAGGGTGACGTGCCAATCGACTGATTTGACTGGCCGGGGGATCGGCTGCGTAAAACCGGTGTCAGAATAAATAGTCATGGCCGGCGTCGACAGGCGCCCCGAGGGATAGGTAACGGGCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGTCAACTACGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGAGCCTGAGGCCCGTGAAGAAGCCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGGTTCTGGGTGCATAGCCGCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGACGCCACGAAGTGTCAACTAGTGTTGTCATGAGAGAGTTATTATAGCAGGCCTACTTGTAGGTAAATACACTCTAGGTTATTCGCTCTGCTCCCCTCCTGCGTAACCCCTACCGTGAAGAAGCGGTCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGTGTTACTACCCATAGCGTCGGCCTCGTGAAGAAGCGGTTCTGGGCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTTGCATAGCCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGACGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTAGTGTCAACTCGGACGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTCGCCACGAAGTGTCAACTACGTGGCAATCATCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGTACTAGTTTAGCTGTAGGGCTTGAGGCAATTCCACGATCAGCGGGAACAGCGATATAACCCTTACATATCTAAACGCTGGACTGCATAAAGTAAGCAAGGAAATTGACTGAGGCGCTTACCCCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTCCAGTATCAAGCCGCAACCGGGCCCGTGACTCATCCTCCTGCATACCCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGAACGGGGCCTGGTCCCGTTTTCGAAGGGTGAGTTCTGCTTAGCGTTGTCTTTCATTCGCTCAAAAGTCCCGCGTAAGAGCATCCTGGATTGTTCGCCCTGTAAGCGGGACTACGCGTGCCGATGGTGGGCTTGCAATTATCATAGCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTTCCTGTTCCGTCAATTCCTCTCTAAATACTATCTAACCTGGTCGCAGAACTCGAAGAACTACCGGCCGTCAGCAATTCTAGCTTAATACCTCGTCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTTGAATAGTGCGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTGCCCCTCGGAACGGTATGTACTGCAAGCGTAGAAACCCTGATAGCTTGGATGACGAAACTGTTAGATGTACTGCCAACGGTTAGTCGCGCTGTCGGTTTCGTTAACGATGCATTAAGTCGAACTCGTACCTAGAAACGTGAAGAAGCGGTTCTGGGTGCATAGCCGGACGCCACGAAGTGTCAACTAGTGGGATATTGGTGAAGCAGAGGACGAATTGCGATATCCAAGATGAGAACTGTTTGTCAGTCGGGGAAGACCCAGCTGACTACGCTCAGAGCCCGGTCATGTGTCTGAATCAATCTAAAAACGTATAGTTTGGCTACTGGGGCGCTAGGTGC'
len(string)
