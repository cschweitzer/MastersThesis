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

features = pd.read_csv("../Outputs/Features/cluster_inputs/features_z_pca.csv", header = None )

#features = pd.read_csv("../Outputs/Features/cluster_inputs/features_cont_std.csv", index_col = 'id')

#%%

from numpy import linalg

distances = np.linalg.norm(features, axis = 1)

np.mean(distances)


#%%
from sklearn.cluster import AffinityPropagation

dampings= [.5,.75,.95]
max_iters = [50,100, 150, 200, 250]
conv_iters = [5,10,15,20]

summary = []
for d in dampings:
    for mi in max_iters:
        for ci in conv_iters:
            cluster = AffinityPropagation(damping=d, max_iter=mi, convergence_iter=ci)
            cluster.fit(features)
            labels = cluster.labels_

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

            summary.append((d, mi, ci, len(c_l),avg, lrgst,noise,silhouette, db_score))

summary = pd.DataFrame(summary, columns = ['damping','max_iter','convergence_iter','n_clusters','avg_cl_size','lrgst_cl_size', 'noise_size', 'silhouette', 'davies_bouldin'])

summary.to_csv("../Outputs/Clustering/summary_affinity_pca5.csv", index = False)


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

