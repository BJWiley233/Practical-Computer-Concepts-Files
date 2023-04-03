### Assignments for "[ESR 1: Development of a computational methodology to detect allosteric pathways in proteins and application in drug discovery](https://euraxess.ec.europa.eu/worldwide/india/europe-14-phd-positions-available-msca-itn-project-allodd-drug-discovery)"

##### Assignment 3
You are going to test your skills in a machine learning classification problem. You are going
to use the breast cancer dataset, which is a classic and very easy binary classification
dataset. Information about the dataset and how to load it are here
https://scikit-learn.org/stable/modules/generated/sklearn.datasets.load_breast_cancer.html
. You have to split you dataset into a training set (70%) and a test set (30%) and train 5
different machine learning algorithms. From the sklearn package the linear discriminant
analysis, the logistic regression, the support vector machines, and the extremely
randomized trees and from the XGBoosts package the XGBClassifier. In order to improve
the predictive power of these algorithms you need to tune their hyper-parameters. Take a
close look in the API documentation of each algorithm and the parameters their
parameters and for each one of these 5 classifiers do a randomized search with 5-fold
cross-validation for 300 iterations using a big enough range of values for the parameters
that are tunable, and afterwards, perform a grid search 5-fold cross-validation in a small
range of values around the best parameters found from the randomized search. As a
metric for the randomized and grid searches use the f1 score. Input the final best models of
your 5 classifiers using the mlxtend package to the second level classifiers, voting
classifier and stacking classifier. For the stacking classifier use the logistic regression as a
meta-classifier with the default parameters. Calculate the accuracy, the f1 score, and the
ROC AUC score for the initial 5 best models and the 2 second-level classifiers and
comment on the results.


##### Assignment 4
You are provided with a dataset with twitter profiles containing the user’s gender, description, 
favorite number, and number of tweets. You are called to create a machine learning algorithm that 
can predict the user’s gender based on the user’s description only. The gender can be male, female, 
or brand. Take a close inspection of the dataset and take care of any missing or irrelevant values. 
Split the dataset into training and test sets and try multiple classification algorithms. Optimize 
them and find the best possible classifier. Afterwards, for the favorite number, and number of tweets 
in your feature space, plot histograms based on the gender and perform statistical tests to check if 
there is a significant statistical difference. Include these features to your previous classification 
models. Do you see any improvement?
