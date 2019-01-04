# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:03:08 2018

@author: schwe
"""

from sklearn.cluster import Birch
import numpy as np
from collections import Counter
import pandas as pd

from sklearn.metrics import silhouette_score, davies_bouldin_score
#%%

features = pd.read_csv("../Outputs/features_z_pca.csv", header = None )

#features = pd.read_csv("../Outputs/features_cont_Std.csv", index_col = 'id')

#%%

from numpy import linalg

distances = np.linalg.norm(features, axis = 1)

np.mean(distances)


#%%
thresholds= [.5,1,1.5,2,3,4,5]
branches = [20,50,100, 150]


summary_birch = []
for th in thresholds:
    for br in branches:

        clusterbirch = Birch(threshold=th, branching_factor=br, n_clusters=None)
        clusterbirch.fit(features)
        labels = clusterbirch.labels_

        c_l = Counter(labels)
        noise = c_l[-1]

        if len(c_l) > 1:
            avg = np.mean([j for i,j in c_l.items() if i != -1])
            lrgst = max([j for i,j in c_l.items() if i != -1])
            silhouette = silhouette_score(features, labels)
            db_score = davies_bouldin_score(features, labels)
        else:
            avg = max(noise,c_l[0])
            lrgst = max(noise,c_l[0])
            silhouette = None
            db_score = None

        summary_birch.append((th, br, len(c_l),
                                avg, lrgst,noise,silhouette, db_score))

summary_birch = pd.DataFrame(summary_birch, columns = ['threshold','branchfactor','clusters_out','avg_cl_size','lrgst_cl_size', 'noise_size', 'silhouette', 'davies_bouldin'])

summary_birch.to_csv("summary_birch_pca.csv", index = False)


#%%
clustermodel = DBSCAN(eps=1,
                      min_samples=5,
                      metric='euclidean',
                      algorithm='auto')
clustermodel.fit(X)
#%%
#labels = clustermodel.labels_

silhouette = silhouette_score(X, clustermodel.labels_)
db_score = davies_bouldin_score(X, clustermodel.labels_)

#%%

