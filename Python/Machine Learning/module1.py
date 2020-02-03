# -*- coding: utf-8 -*-
"""
Created on Mon Jan 27 02:27:34 2020

@author: bjwil
TESTING
"""

import numpy as np
import seaborn as sns; sns.set(style="ticks", color_codes=True)
import sklearn.datasets
import pandas as pd
import warnings
import matplotlib.pyplot as plt

iris = sklearn.datasets.load_iris()
iris_df = pd.DataFrame(data=np.c_[iris.data, [iris.target_names[v] for
                       v in iris.target]], 
                       columns=iris.feature_names + ['species'])
cols = iris_df.columns.drop('species')
iris_df[cols] = iris_df[cols].apply(pd.to_numeric)
#g = sns.pairplot(iris_df, hue='species', size=2)

boston = sklearn.datasets.load_boston()
boston_df = pd.DataFrame(data=np.c_[boston.data, pd.cut(boston.target,3)], 
                         columns=np.concatenate((boston.feature_names,
                                              np.array(['MEDV'], dtype='<U7')),
                                              axis=0))

cols = boston_df.columns.drop('MEDV')
boston_df[cols] = boston_df[cols].apply(pd.to_numeric)
boston_best_feat = boston_df[['RM','AGE','DIS','TAX','LSTAT','MEDV']]
sns.pairplot(boston_best_feat, hue='MEDV')

breast = sklearn.datasets.load_breast_cancer()
breast.feature_names
breast_df = pd.DataFrame(data=np.c_[breast.data, [breast.target_names[v] for
                                    v in breast.target]], 
                         columns=np.concatenate((breast.feature_names,
                                              np.array(['M_B'], dtype='<U23')),
                                              axis=0))
cols = breast_df.columns.drop('M_B')
breast_df[cols] = breast_df[cols].apply(pd.to_numeric)
from itertools import chain
breast_df_1_10 = breast_df.iloc[:,list(range(0,10)) + [len(breast_df.columns)-1]]
breast_df_11_20 = breast_df.iloc[:,list(range(10,20)) + [len(breast_df.columns)-1]]
breast_df_21_30 = breast_df.iloc[:,list(range(20,30)) + [len(breast_df.columns)-1]]
#breast_df_1_10 = breast_df.iloc[:,list(range(0,5)) + list(range(14,20)) + [len(breast_df.columns)-1]]

with warnings.catch_warnings():
    # ignore all caught warnings
    warnings.filterwarnings("ignore")
    g = sns.pairplot(breast_df, hue='M_B', size=2)
    # execute code that will generate warnings
    g = sns.pairplot(breast_df_1_10, hue='M_B', size=2)
    g = sns.pairplot(breast_df_11_20, hue='M_B', size=2)
    g = sns.pairplot(breast_df_21_30, hue='M_B', size=2)
#g = sns.pairplot(boston_df.iloc[:,[6,5,3,13]], hue='MEDV')
sns.pairplot(breast_df.iloc[:,np.concatenate([np.random.randint(0,len(breast.feature_names), size=4),
                                           [len(breast.feature_names)]], axis=0)], size=3) 
with warnings.catch_warnings():
    # ignore all caught warnings
    warnings.filterwarnings("ignore")
    # execute code that will generate warnings
    g = sns.pairplot(boston_df, size=1)

from mpl_toolkits.mplot3d import axes3d, Axes3D
fig = plt.figure(figsize=(8, 6))
ax = Axes3D(fig)
#sns.countplot(x='MEDV', data=boston_df)
xs = iris_df.iloc[:,2]
ys = iris_df.iloc[:,3]
zs = iris_df.iloc[:,1]
ax.scatter(xs, ys, zs, s=50, alpha=0.6, edgecolors='w')

ax.set_xlabel('petal length')
ax.set_ylabel('petal width')
ax.set_zlabel('sepal width')

plt.show()

from sklearn.decomposition import PCA
pca_boston = PCA(n_components=2)
_pca_boston = pca_boston.fit_transform(boston_df.iloc[:,0:-1])
_pca_boston_df = pd.DataFrame(data = _pca_boston, 
                              columns = ['pca1', 'pca2'])
plt.figure()
plt.figure(figsize=(10,10))
plt.xlabel('Principal Component - 1',fontsize=20)
plt.ylabel('Principal Component - 2',fontsize=20)
plt.scatter(_pca_boston_df['pca1'], _pca_boston_df['pca2'])
plt.show()

n_samples = len(iris.data)

from sklearn import naive_bayes, tree, metrics
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
import matplotlib.pyplot as plt

X_train, X_test, y_train, y_test = train_test_split(iris.data,
                                                    iris.target,
                                                    train_size=0.5,
                                                    random_state=0)
'''naive_bayes.CategoricalNB
classifier = naive_bayes.CategoricalNB()
classifier.fit(X=X_train, y= y_train)
predicted = classifier.predict(X_test)
print(metrics.classification_report(y_test, predicted))
'''
classifier = naive_bayes.GaussianNB()
classifier.fit(X=X_train, y= y_train)
predicted = classifier.predict(X_test)
print(metrics.classification_report(y_test, predicted))
print("Number of mislabeled points out of a total %d points : %d"
      % (iris.data[n_samples // 2:].shape[0], (y_test != predicted).sum()))
print(accuracy_score(y_test, predicted))


percentages = np.arange(0.05, 0.95, 0.05)
BernoulliNB_accuracy = []
#CategoricalNB_accuracy = []
ComplementNB_accuracy = []
GaussianNB_accuracy = []
MultinomialNB_accuracy = []

DecisionTreeClassifier_accuracy = []
DecisionTreeRegressor_accuracy = []
ExtraTreeClassifier_accuracy = []
ExtraTreeRegressor_accuracy = []

'''
iris.data
iris_df
iris_one_hot = pd.get_dummies(iris_df)

iris_df.iloc[:,:-1].apply(pd.cut, bins=5)
iris_cat = pd.DataFrame(np.c_[iris_df.iloc[:,:-1].apply(pd.cut, bins=5, labels=[1,2,3,4,5]), 
                              iris_df.iloc[:,-1]],
                        columns=iris_df.columns)

for i in percentages:
    X_train, X_test, y_train, y_test = train_test_split(iris_cat.iloc[:,:-1],
                                                    iris_cat.iloc[:,-1],
                                                    train_size=.15,
                                                    random_state=0)
    classifier = naive_bayes.CategoricalNB()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    CategoricalNB_accuracy.append(accuracy_score(y_test, predicted))
'''   

for i in percentages:
    X_train, X_test, y_train, y_test = train_test_split(iris.data,
                                                    iris.target,
                                                    train_size=i,
                                                    random_state=0)
    
    classifier = naive_bayes.BernoulliNB()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    BernoulliNB_accuracy.append(accuracy_score(y_test, predicted))
    '''
    classifier = naive_bayes.CategoricalNB()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    CategoricalNB_accuracy.append(accuracy_score(y_test, predicted))
    '''
    classifier = naive_bayes.ComplementNB()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    ComplementNB_accuracy.append(accuracy_score(y_test, predicted))
       
    classifier = naive_bayes.GaussianNB()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    GaussianNB_accuracy.append(accuracy_score(y_test, predicted))

    classifier = naive_bayes.MultinomialNB()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    MultinomialNB_accuracy.append(accuracy_score(y_test, predicted))
    
    ## DTs
    classifier = tree.DecisionTreeClassifier()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    DecisionTreeClassifier_accuracy.append(accuracy_score(y_test, predicted))
  
    classifier = tree.DecisionTreeRegressor()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    DecisionTreeRegressor_accuracy.append(accuracy_score(y_test, predicted))
    
    classifier = tree.ExtraTreeClassifier()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    ExtraTreeClassifier_accuracy.append(accuracy_score(y_test, predicted))
    
    classifier = tree.ExtraTreeRegressor()
    classifier.fit(X=X_train, y= y_train)
    predicted = classifier.predict(X_test)
    ExtraTreeRegressor_accuracy.append(accuracy_score(y_test, predicted))

'''    
percentages = np.arange(0.05, 0.95, 0.05)
BernoulliNB_accuracy = []
#CategoricalNB_accuracy = []
ComplementNB_accuracy = []
GaussianNB_accuracy = []
MultinomialNB_accuracy = []

DecisionTreeClassifier_accuracy = []
DecisionTreeRegressor_accuracy = []
ExtraTreeClassifier_accuracy = []
ExtraTreeRegressor_accuracy = []
'''

df = pd.DataFrame(data=np.c_[percentages,
                        BernoulliNB_accuracy,
                        ComplementNB_accuracy,
                        GaussianNB_accuracy,
                        MultinomialNB_accuracy,
                        DecisionTreeClassifier_accuracy,
                        DecisionTreeRegressor_accuracy,
                        ExtraTreeClassifier_accuracy,
                        ExtraTreeRegressor_accuracy],
    columns=['percentages',
          'BernoulliNB_accuracy',
          'ComplementNB_accuracy',
          'GaussianNB_accuracy',
          'MultinomialNB_accuracy',
          'DecisionTreeClassifier_accuracy',
          'DecisionTreeRegressor_accuracy',
          'ExtraTreeClassifier_accuracy',
          'ExtraTreeRegressor_accuracy'])

pd.set_option('display.max_columns', None)
df.loc[df['percentages'] == 0.5].max(axis=1)  
df.idxmax(axis=1)

fig, axs = plt.subplots(2, 4, figsize=(12,8))
xlim = (0, 1)
ylim = (0, 1)
plt.setp(axs, xlim=xlim, ylim=ylim)
fig.suptitle('Increasing training set size NaiveBayes/DecisionTrees')
axs[0,0].plot(percentages, BernoulliNB_accuracy)
axs[0,0].set_title('BernoulliNB')
axs[0,0].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[0,1].plot(percentages, ComplementNB_accuracy)
axs[0,1].set_title('ComplementNB')
axs[0,1].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[0,2].plot(percentages, GaussianNB_accuracy)
axs[0,2].set_title('GaussianNB')
axs[0,2].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[0,3].plot(percentages, MultinomialNB_accuracy)
axs[0,3].set_title('MultinomialNB')
axs[0,3].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[1,0].plot(percentages, DecisionTreeClassifier_accuracy)
axs[1,0].set_title('DecisionTreeClassifier')
axs[1,0].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[1,1].plot(percentages, DecisionTreeRegressor_accuracy)
axs[1,1].set_title('DecisionTreeRegressor')
axs[1,1].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[1,2].plot(percentages, ExtraTreeClassifier_accuracy)
axs[1,2].set_title('ExtraTreeClassifier')
axs[1,2].axvspan(0.49, 0.51, alpha=0.5, color='yellow')
axs[1,3].plot(percentages, ExtraTreeRegressor_accuracy)
axs[1,3].set_title('ExtraTreeRegressor')
axs[1,3].axvspan(0.49, 0.51, alpha=0.5, color='yellow')

for ax in axs.flat:
    ax.set(xlabel='training set size', ylabel='accurracy')

for ax in axs.flat:
    ax.label_outer()
    


