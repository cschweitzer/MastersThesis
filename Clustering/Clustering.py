# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:03:08 2018

@author: schwe
"""

import pickle
from sklearn.cluster import DBSCAN
import numpy as np
from collections import Counter
import pandas as pd
#%%

features_pca = pickle.load(open("../Outputs/features_z_pca.pickle","rb"))
features = pickle.load(open("../Outputs/features_std.pickle","rb"))
#%%

from numpy import linalg

distances = np.linalg.norm(features_pca, axis = 1)

np.mean(distances)
#%%

epsilons = range(1,45,4)
minpts = [1, 5,10,20,50]
dist = ['euclidean']
algo = ['auto', 'ball_tree', 'kd_tree', 'brute']

summary = []
for ep in epsilons:
    for mins in minpts:
        for alg in algo:
            clustermodel = DBSCAN(eps=ep,
                          min_samples=mins,
                          metric='euclidean',
                          algorithm=alg)
            clustermodel.fit(features)

            c_l = Counter(clustermodel.labels_)
            noise = c_l[-1]

            if len(c_l) > 1:
                avg = np.mean([j for i,j in c_l.items() if i != -1])
                lrgst = max([j for i,j in c_l.items() if i != -1])
            else:
                avg = max(noise,c_l[0])
                lrgst = max(noise,c_l[0])

            summary.append((alg, ep, mins, np.unique(clustermodel.labels_).size,
                            avg, lrgst,noise))

summary = pd.DataFrame(summary, columns = ['algo','ep','mins','clusters','avg_cl_size','lrgst_cl_size', 'noise_size'])

#%%
clustermodel = DBSCAN(eps=10,
                      min_samples=1,
                      metric='euclidean',
                      algorithm='auto')
clustermodel.fit(features_pca)
c_l = Counter(clustermodel.labels_)
noise = c_l[-1]

if len(c_l) > 1:
    avg = np.mean([j for i,j in c_l.items() if i != -1])
    lrgst = max([j for i,j in c_l.items() if i != -1])
else:
    avg = max(noise,c_l[0])
    lrgst = max(noise,c_l[0])

print(avg, lrgst)

#%%
from sklearn.metrics import silhouette_score

silhouette_score(features_pca, clustermodel.labels_)