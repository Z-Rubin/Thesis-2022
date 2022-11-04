import os
import random
import csv

import numpy as np
import numpy.testing as npt
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.datasets import make_regression
from sklearn.neural_network import MLPRegressor
from sklearn.linear_model import Ridge
from sklearn import metrics
from sklearn import preprocessing
from sklearn.metrics import mean_absolute_error




# Getting current directory
dirPath = os.path.dirname(os.path.realpath(__file__))
dataPath = dirPath + "/1000070"

#reading raw input data
datafile = open(dataPath + '/X.csv', 'r')
datareader = csv.reader(datafile, delimiter=',')
rawX = []
for row in datareader:
    rawX.append(row)    

#reading raw output data
datafile = open(dataPath + '/Y.csv', 'r')
datareader = csv.reader(datafile, delimiter=',')
Y = []
for row in datareader:
    Y.append(row)    

X = rawX
#reading sample
dataPath = os.path.dirname(os.path.realpath(__file__))
#datafile = open(dataPath + '/Data/UG2Simulation.csv', 'r')
#datafile = open(dataPath + '/Data/GreatDykeSimulation.csv', 'r')
#datafile = open(dataPath + '/Data/test1.csv', 'r')


datareader = csv.reader(datafile, delimiter=',')
Xsample = []
for row in datareader:
    Xsample.append(row) 


#formatting and processing the data
X = np.array(X, dtype=object)
Y = np.array(Y, dtype=object)
scaler = preprocessing.StandardScaler()
X = scaler.fit_transform(X)
X = preprocessing.normalize(X, norm='l2')
Xsample = np.array(Xsample, dtype=object)
Xsample = scaler.transform(Xsample)
Xsample = preprocessing.normalize(Xsample, norm='l2')

#splitting the data
x_train, x_test, y_train, y_test = train_test_split(X, Y, test_size=1/3, random_state = 1)

#training the model
regr = MLPRegressor(random_state=2, alpha = 1e-4, hidden_layer_sizes=(130),activation='relu',tol=1e-7, max_iter=1000, n_iter_no_change=10).fit(x_train, y_train)

#calculating and printing MSE and R squared score
y_true = y_test
y_pred = regr.predict(x_test)
print(mean_absolute_error(y_true, y_pred, multioutput='raw_values'))
print(regr.score(x_test, y_test))

#printing prediction of test sample given
print(regr.predict(Xsample[[0]]))

#printing random prediction and corresponding true value
randomInt = random.randint(0,1000)
Ytest = regr.predict(X[[randomInt]])
print(Y[randomInt].astype(np.float64))
print(Ytest)





