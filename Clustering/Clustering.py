# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:03:08 2018

@author: schwe
"""

import pickle
from sklearn.cluster import DBSCAN, AgglomerativeClustering
import numpy as np
from collections import Counter
import pandas as pd

from sklearn.metrics import silhouette_score, davies_bouldin_score
#%%

features_pca = pickle.load(open("../Outputs/features_z_pca.pickle","rb"))
features = pickle.load(open("../Outputs/features_std.pickle","rb"))
#%%

from numpy import linalg

distances = np.linalg.norm(features, axis = 1)

np.mean(distances)

#%%

X = np.copy(features)

#%%

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
            clustermodel.fit(X)

            c_l = Counter(clustermodel.labels_)
            c_nn = c_l
            del c_nn[-1]
            noise = c_l[-1]

            if len(c_l) > 1:
                avg = np.mean([j for i,j in c_l.items() if i != -1])
                lrgst = max([j for i,j in c_l.items() if i != -1])

                '''if len(c_l) < len(X):
                    silhouette = silhouette_score(X, clustermodel.labels_)
                    db_score = davies_bouldin_score(X, clustermodel.labels_)
                else:
                    silhouette = None
                    db_score = None'''
            else:
                avg = max(noise,c_l[0])
                lrgst = max(noise,c_l[0])
                silhouette = None


            summary_db.append((alg, ep, mins, len(c_nn),
                            avg, lrgst,noise,silhouette, db_score))

summary_db = pd.DataFrame(summary_db, columns = ['algo','ep','mins','clusters','avg_cl_size','lrgst_cl_size', 'noise_size'])

summary_db.to_csv("summary_dbscan.csv", index = False)


#%%
clustermodel = DBSCAN(eps=4,
                      min_samples=5,
                      metric='euclidean',
                      algorithm='auto')
clustermodel.fit(X)
#%%
silhouette = silhouette_score(X, clustermodel.labels_)
db_score = davies_bouldin_score(X, clustermodel.labels_)

#%%

clusters= [2,5,10,15]
#affinity=’euclidean’
#memory=None
#connectivity=None
#compute_full_tree=’auto’
#linkage=’ward’
#pooling_func=’deprecated’

summary_agg_pca = []
for n in clusters:

    clusteragg = AgglomerativeClustering(n_clusters=n, affinity='euclidean')
    clusteragg.fit(features_pca)

    c_l = Counter(clusteragg.labels_)
    noise = c_l[-1]

    if len(c_l) > 1:
        avg = np.mean([j for i,j in c_l.items() if i != -1])
        lrgst = max([j for i,j in c_l.items() if i != -1])
    else:
        avg = max(noise,c_l[0])
        lrgst = max(noise,c_l[0])

    silhouette = silhouette_score(features_pca, clusteragg.labels_)

    summary_agg_pca.append((n, np.unique(clusteragg.labels_).size,
                        clusteragg.n_leaves_,
                            avg, lrgst,noise,silhouette))

summary_agg_pca = pd.DataFrame(summary_agg_pca, columns = ['clusters_n','clusters_out','leaves','avg_cl_size','lrgst_cl_size', 'noise_size', 'silhouette'])

summary_db.to_csv("summary_agg.csv", index = False)