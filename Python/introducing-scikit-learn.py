# -*- coding: utf-8 -*-
"""
Created on Sat Apr  6 20:46:11 2019

@author: bjwil
"""

import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
%matplotlib inline

iris = sns.load_dataset('iris')
iris.head()



sns.set()
sns.pairplot(iris, hue='species', size=1.5)

X_iris = iris.drop('species', 1)
X_iris.shape

y_iris = iris['species']
y_iris.shape




rng = np.random.RandomState(42)
x = 10 * rng.rand(50)
y = 2 * x - 1 + rng.randn(50)
plt.scatter(x, y)

from sklearn.linear_model import LinearRegression
model = LinearRegression(fit_intercept=True)
model
X = x[:, np.newaxis]
x.shape
X.shape
model.fit(X, y)
model.coef_
model.intercept_

xfit = np.linspace(-1, 11)
xfit.shape
Xfit = xfit[:, np.newaxis]
yfit = model.predict(Xfit)

plt.scatter(x, y)
plt.plot(Xfit, yfit);

from sklearn.model_selection import train_test_split
Xtrain, Xtest, ytrain, ytest = train_test_split(X_iris, y_iris,
                                               random_state=1)
from sklearn.naive_bayes import GaussianNB
model = GaussianNB()
model.fit(Xtrain, ytrain)
y_model = model.predict(Xtest)
from sklearn.metrics import accuracy_score
accuracy_score(ytest, y_model)

# Unsupervised PCA
from sklearn.decomposition import PCA
model = PCA(n_components=2)
model.fit(X_iris)
X_2D = model.transform(X_iris)
iris[['PCA1','PCA2']] = pd.DataFrame(X_2D)
sns.lmplot('PCA1', 'PCA2', hue='species', data=iris, fit_reg=False)


# Unsupervised GMM
from sklearn.mixture import GaussianMixture
model = GaussianMixture(n_components=3)
model.fit(X_iris)
y_gmm = model.predict(X_iris)
iris['cluster'] = y_gmm
#.rename(columns={'cluser':'cluster'}, inplace=True)
sns.lmplot('PCA1', 'PCA2', hue='species', 
           data=iris, col='cluster', fit_reg=False)


#Example
from sklearn.datasets import load_digits
import sklearn
digits = load_digits()
digits.images.shape

fig, axes = plt.subplots(10, 10, figsize=(8, 8),
                         subplot_kw={'xticks':[], 'yticks':[]},
                         gridspec_kw=dict(hspace=0.1, wspace=0.1))

for i, ax in enumerate(axes.flat):
    ax.imshow(digits.images[i], cmap='binary', interpolation='nearest')
    ax.text(0.05, 0.05, str(digits.target[i]),
            transform=ax.transAxes, color='green')
    
X = digits.data
X.shape

y = digits.target
y.shape

from sklearn.manifold import Isomap
iso = Isomap()
iso.fit(X)
data_projected = iso.transform(X)
data_projected.shape


plt.scatter(data_projected[:, 0], data_projected[:, 1], c=digits.target,
            edgecolor='none', alpha=0.5,
            cmap=plt.cm.get_cmap('twilight', 10))
plt.colorbar()

Xtrain, Xtest, ytrain, ytest = train_test_split(X, y, random_state=0)

from sklearn.naive_bayes import GaussianNB
model = GaussianNB()
model.fit(Xtrain, ytrain)
y_model = model.predict(Xtest)

from sklearn.metrics import accuracy_score
accuracy_score(ytest, y_model)

from sklearn.metrics import confusion_matrix
matrix_ = confusion_matrix(ytest, y_model)
sns.heatmap(matrix_, square=True, annot=True, cbar=False, cmap=sns.cm.rocket_r)
plt.xlabel("True")
plt.ylabel("Pred")
sum(ytest==1)
import pandas as pd
y_act = pd.Series(ytest, name='Actual')
y_pred = pd.Series(y_model, name='Predicted')
pd.crosstab(y_act, y_pred)


fig, axes = plt.subplots(10, 10, figsize=(10, 10),
                         subplot_kw={'xticks':[], 'yticks':[]},
                         gridspec_kw=dict(hspace=0.1, wspace=0.1))

test_images = Xtest.reshape(-1, 8, 8)

font = {'family': 'serif',
        'color':  'darkred',
        'weight': 'bold',
        'size': 11,
        }

for i, ax in enumerate(axes.flat):
    ax.imshow(test_images[i], cmap='binary', interpolation='nearest')
    ax.text(0.02, 0.05, str(y_model[i]),
            transform=ax.transAxes, 
            color='green' if (ytest[i]==y_model[i]) else 'red',
            fontdict=font)


from sklearn.datasets import load_iris
iris = load_iris()
X = iris.data
y = iris.target

from sklearn.neighbors import KNeighborsClassifier
model = KNeighborsClassifier(n_neighbors=1)
model.fit(X, y)
y_model = model.predict(X)
accuracy_score(y, y_model)


Xtrain, Xtest, ytrain, ytest = train_test_split(X, y, random_state=0, 
                                                train_size = .5)


model.fit(Xtrain, ytrain)

y2_model = model.predict(Xtest)
accuracy_score(ytest, y2_model)


from sklearn.model_selection import cross_val_score
cross_val_score(model, X, y, cv=49)
cross_val_score(model, X, y, cv=5).mean()
from sklearn.model_selection import KFold
cross_val_score(model, X, y, cv=KFold(150, shuffle=True)).mean()

from sklearn.model_selection import LeaveOneOut
scores = cross_val_score(model, X, y, cv=LeaveOneOut())
scores
scores.mean()


from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import make_pipeline

def PolynomialRegression(degree=2, **kwargs):
    return make_pipeline(PolynomialFeatures(degree),
                         LinearRegression(**kwargs))

import numpy as np
def make_data(N, err=1.0, rseed=1):
    rng = np.random.RandomState(rseed)
    X = rng.rand(N, 1) ** 2
    y = 10 - 1. / (X.ravel() + 0.1)
    if err > 0:
        y += err * rng.rand(N)
    return X, y
    
X,y = make_data(40)    
    
%matplotlib inline    
import matplotlib.pyplot as plt
import seaborn; seaborn.set()    

X_test = np.linspace(-0.2, 1.0, 500)[:, None]

plt.scatter(X.ravel(), y, color='black')
axis = plt.axis()
for degree in (1, 3, 5):
    y_test = PolynomialRegression(degree).fit(X,y).predict(X_test)
    plt.plot(X_test.ravel(), y_test, label='degree={0}'.format(degree))
plt.xlim(-0.1,1.1)
plt.ylim(-2, 12)
plt.legend(loc='best')




from sklearn.model_selection import validation_curve
import pandas as pd
degree = np.arange(0, 21)
train_score, val_score = validation_curve(PolynomialRegression(), X, y,
                                          'polynomialfeatures__degree', degree, cv=7)
#np.amax(np.median(val_score, 1))
df = pd.DataFrame({"poly":degree, "score":np.median(val_score, 1)})
best = df.iloc[df.score.idxmax(), ].poly
%matplotlib qt

plt.plot(degree, np.median(train_score, 1), color='blue', label='training score')
plt.plot(degree, np.median(val_score, 1), color='red', label='validation score')
plt.legend(loc='best')
plt.ylim(0, 1.2)
plt.xlabel('degree')
plt.ylabel('score');
plt.axvline(best, color='black', linestyle='-.')

plt.scatter(X.ravel(), y, color='black')
for degree in (3,6):

    lim = plt.axis()
    y_test = PolynomialRegression(degree).fit(X, y).predict(X_test)
    plt.plot(X_test.ravel(), y_test,label='degree={0}'.format(degree));
    plt.axis(lim);
plt.legend(loc='best')

plt.scatter(X.ravel(), y)
lim = plt.axis()
y_test = PolynomialRegression(6).fit(X, y).predict(X_test)
plt.plot(X_test.ravel(), y_test);
plt.axis(lim);

#learning curves
X2, y2 = make_data(200)
plt.scatter(X2.ravel(), y2)

degree = np.arange(0, 21)
train_score2, val_score2 = validation_curve(PolynomialRegression(), X2, y2,
                                          'polynomialfeatures__degree', degree, cv=7)

plt.plot(degree, np.median(train_score, 1), color='blue', linestyle="--", alpha=0.3)
plt.plot(degree, np.median(val_score, 1), color='red', linestyle="--", alpha=0.3)
plt.plot(degree, np.median(train_score2, 1), color='blue', label='training score')
plt.plot(degree, np.median(val_score2, 1), color='red', label='validation score')
plt.legend(loc='best')
plt.ylim(0, 1.0)
plt.xlabel('degree')
plt.ylabel('score');
#plt.axvline(best, color='black', linestyle='-.')

from sklearn.model_selection import validation_curve, learning_curve
#X, y = make_data(40)
fig, ax = plt.subplots(1, 3, figsize=(8, 6))
fig.subplots_adjust(left=0.0625, right=0.95, wspace=0.2)

for i, degree in enumerate([2,9,14]):
    N, train_lc, val_lc = learning_curve(PolynomialRegression(degree), X, y, cv=7,
                                         train_sizes=np.linspace(0.3, 1.0, 25))
    
    ax[i].plot(N, np.mean(train_lc, 1), color='blue', label='training score')
    ax[i].plot(N, np.mean(val_lc, 1), color='red', label='val score')
    ax[i].hlines(y=np.mean([train_lc[-1], val_lc[-1]]), xmin = N[0], xmax = N[-1],
      color = "grey", linestyle="--")

    ax[i].set_ylim(0, 1.05)
    ax[i].set_xlim(N[0], N[-1])
    ax[i].set_xlabel('training size')
    ax[i].set_ylabel('score')
    ax[i].set_title('degree = {0}'.format(degree), size=14)
    ax[i].legend(loc='lower right')
    
from sklearn.model_selection import GridSearchCV

param_grid = {'polynomialfeatures__degree': np.arange(21),
              'linearregression__fit_intercept': [True, False],
              'linearregression__normalize': [True, False]}

grid = GridSearchCV(PolynomialRegression(), param_grid, cv=7)

grid.fit(X, y)

grid.best_params_
grid.best_estimator_
model = grid.best_estimator_
type(model)
plt.scatter(X.ravel(), y)
lim = plt.axis()
y_test = model.fit(X, y).predict(X_test)
plt.plot(X_test.ravel(), y_test)
plt.axis(lim)