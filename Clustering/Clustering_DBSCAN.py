# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:03:08 2018

@author: schwe
"""

import numpy as np
from collections import Counter
import pandas as pd

from sklearn.metrics import silhouette_score, davies_bouldin_score
#%%

features = pd.read_csv("../Outputs/Features/cluster_inputs/features_z_pca5.csv")

#features = pd.read_csv("../Outputs/Features/cluster_inputs/features_cont_std.csv", index_col = 'id')

#%%

from numpy import linalg

distances1 = pd.DataFrame(np.linalg.norm(features, axis = 1))
np.mean(distances1)

#import scipy.spatial
#distances2 = pd.DataFrame(scipy.spatial.distance.pdist(features))


#%%

from sklearn.cluster import DBSCAN

epsilons = [1,2,3,4,5,10,15,20,25,30]
minpts = [1, 5,10,20,50]
dist = ['euclidean']
algo = ['auto', 'ball_tree', 'kd_tree', 'brute']

summary_db = []
for ep in epsilons:
    for mins in minpts:
        for alg in algo:
            clustermodel = DBSCAN(eps=ep,
                          min_samples=mins,
                          metric='euclidean',
                          algorithm=alg)
            clustermodel.fit(features)
            labels = clustermodel.labels_

            c_l = Counter(labels)
            c_nn = c_l
            del c_nn[-1]
            noise = c_l[-1]

            if len(c_l) > 1:
                avg = np.mean([j for i,j in c_l.items() if i != -1])
                lrgst = max([j for i,j in c_l.items() if i != -1])

                #if len(c_l) < len(X):
                with np.errstate(divide='ignore'):
                    silhouette = silhouette_score(features, labels)
                    db_score = davies_bouldin_score(features, labels)
                #else:
                    #silhouette = None
                    #db_score = None
            else:
                avg = max(noise,c_l[0])
                lrgst = max(noise,c_l[0])
                silhouette = None
                db_score = None


            summary_db.append((alg, ep, mins, len(c_nn),

                            avg, lrgst,noise,silhouette, db_score))

summary_db = pd.DataFrame(summary_db, columns = ['algo','ep','mins','n_clusters','avg_cl_size','lrgst_cl_size', 'noise_size', 'silhouette','davies_bouldin'])

summary_db.to_csv("../Outputs/Clustering/summary_dbscan_pca5.csv", index = False)


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

