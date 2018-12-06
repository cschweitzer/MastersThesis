# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:03:08 2018

@author: schwe
"""

import pickle
from sklearn.cluster import DBSCAN
import numpy as np
from collections import Counter

#%%

features_pca = pickle.load(open("../Outputs/features_pca.pickle","rb"))
features = pickle.load(open("../Outputs/features.pickle","rb"))

#%%

epsilons = [1,3,5,10,50]
minpts = [5,10,20,50]
dist = ['euclidean']
algo = ['auto', 'ball_tree', 'kd_tree', 'brute']

summary = []
for ep in epsilons:
    for mins in minpts:
        clustermodel = DBSCAN(eps=ep,
                      min_samples=mins,
                      metric='euclidean')
        clustermodel.fit(features)
        summary.append((ep, mins, np.unique(clustermodel.labels_).size))
summary = np.array(summary)
#%%
clustermodel = DBSCAN(eps=50,
                      min_samples=3,
                      metric='euclidean')
clustermodel.fit(features_pca)
labels = clustermodel.labels_
#%%
output = clustermodel.fit_predict(features_pca)
#labels = clustermodel.labels_