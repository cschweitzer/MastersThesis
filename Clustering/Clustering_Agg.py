# -*- coding: utf-8 -*-
"""
Created on Wed Dec  5 16:03:08 2018

@author: schwe
"""

from sklearn.cluster import DBSCAN, AgglomerativeClustering
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
clusters= [2,5,10,15,20, 25]
#affinity=’euclidean’
#memory=None
#connectivity=None
#compute_full_tree=’auto’
#linkage=’ward’
#pooling_func=’deprecated’

summary_agg = []
for n in clusters:

    clusteragg = AgglomerativeClustering(n_clusters=n, affinity='euclidean')
    clusteragg.fit(features)
    labels = clusteragg.labels_

    c_l = Counter(labels)
    noise = c_l[-1]

    if len(c_l) > 1:
        avg = np.mean([j for i,j in c_l.items() if i != -1])
        lrgst = max([j for i,j in c_l.items() if i != -1])
    else:
        avg = max(noise,c_l[0])
        lrgst = max(noise,c_l[0])

    silhouette = silhouette_score(features, labels)
    db_score = davies_bouldin_score(features, labels)

    summary_agg.append((n, np.unique(labels).size,
                        clusteragg.n_leaves_,
                            avg, lrgst,noise,silhouette, db_score))

summary_agg = pd.DataFrame(summary_agg, columns = ['clusters_n','clusters_out','leaves','avg_cl_size','lrgst_cl_size', 'noise_size', 'silhouette', 'davies_bouldin'])

summary_agg.to_csv("summary_agg_pca.csv", index = False)


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

