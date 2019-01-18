# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 12:22:49 2018

@author: schwe
"""
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
#%%
clusters = pd.read_csv("../Outputs/Clustering/cluster_indices_dbscan_4_5.csv")
#%%
kclusters = pd.read_csv("../Outputs/Clustering/cluster_indices_kmeans_8.csv")

#%% No noise

cl_nonoise = clusters.loc[clusters.cluster_val > 0]

#%%

#%%
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

#%%
fig1 = plt.figure(1,figsize=(10,7))
ax = Axes3D(fig1)

cdict = {1: ['green',"Cluster 1"], 2: ['blue', "Cluster 2"], 0: ['red',"Noise"]}

for g in np.unique(clusters.cluster_val):
    ix = np.where(clusters.cluster_val == g)
    ax.scatter(clusters.PC1.iloc[ix], clusters.PC2.iloc[ix], clusters.PC3.iloc[ix],
    c = cdict[g][0], label = cdict[g][1])
#ax.scatter(clusters.iloc[:,0], clusters.iloc[:,1], clusters.iloc[:,2],
#           c = clusters.cluster_val, label = clusters.cluster_val)
plt.legend(loc = 'upper left', fontsize=15)
plt.title('DBSCAN Clusters (3 PC)', fontsize = 20)
ax.set_xlabel(r'Component 1', fontsize=20)
ax.set_ylabel(r'Component 2', fontsize=20)
ax.set_zlabel(r'Component 3', fontsize=20)
plt.savefig("../Outputs/Plots/pca_vs_clustering_4_5_withnoise_v3.png")
plt.show()

#%%No Noise

fig2 = plt.figure(2, figsize=(10,7))
ax = Axes3D(fig2)

cdict2 = {1: ['green',"Cluster 1"], 2: ['blue', "Cluster 2"]}

for g in np.unique(cl_nonoise.cluster_val):
    ix = np.where(cl_nonoise.cluster_val == g)
    ax.scatter(cl_nonoise.PC1.iloc[ix], cl_nonoise.PC2.iloc[ix], cl_nonoise.PC3.iloc[ix],
    c = cdict2[g][0], label = cdict2[g][1])
#ax.scatter(clusters.iloc[:,0], clusters.iloc[:,1], clusters.iloc[:,2],
#           c = clusters.cluster_val, label = clusters.cluster_val)
plt.legend(loc = 'upper left', fontsize = 15)
plt.title('DBSCAN Clusters (3 PC)', fontsize = 20)
ax.set_xlabel(r'Component 1', fontsize=20)
ax.set_ylabel(r'Component 2', fontsize=20)
ax.set_zlabel(r'Component 3', fontsize=20)
plt.savefig("../Outputs/Plots/pca_vs_clustering_4_5_nonoise_v3.png")
plt.show()

#%% Kmeans

fig3 = plt.figure(3, figsize=(10,7))
ax = Axes3D(fig3)

#for g in np.unique(kclusters.cluster_val):
 #   i = np.where(kclusters.cluster_val == g)
     #ax.scatter(kclusters.PC1.iloc[i], kclusters.PC2.iloc[i], kclusters.PC3.iloc[i],
      #         c = g, label = g)
ax.scatter(kclusters.PC1, kclusters.PC2, kclusters.PC3, c = kclusters.cluster_val)
plt.legend(loc = 'upper left', fontsize = 15)
plt.title('K-Means 8 Clusters (3 PC)', fontsize = 20)
ax.set_xlabel(r'Component 1', fontsize=20)
ax.set_ylabel(r'Component 2', fontsize=20)
ax.set_zlabel(r'Component 3', fontsize=20)
plt.savefig("../Outputs/Plots/pca_vs_clustering_kmeans8_3d_all_v3.png")
plt.show()


#%% Kmeans remove outlier

data = kclusters.drop(index = 3039)
fig4 = plt.figure(4, figsize=(10,7))
ax = Axes3D(fig4)

#for g in np.unique(kclusters.cluster_val):
 #   i = np.where(kclusters.cluster_val == g)
     #ax.scatter(kclusters.PC1.iloc[i], kclusters.PC2.iloc[i], kclusters.PC3.iloc[i],
      #         c = g, label = g)
ax.scatter(data.PC1, data.PC2, data.PC3, c = data.cluster_val)
plt.legend( loc = 'lower right' , fontsize = 15)
plt.title('K-Means 8 Clusters (3 PC) (excl outlier)', fontsize = 20)
ax.set_xlabel(r'Component 1', fontsize=20)
ax.set_ylabel(r'Component 2', fontsize=20)
ax.set_zlabel(r'Component 3', fontsize=20)
plt.savefig("../Outputs/Plots/pca_vs_clustering_kmeans8_3d_removeout_v3.png")
plt.show()


