# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 12:22:49 2018

@author: schwe
"""
import numpy as np
from sklearn.decomposition import PCA
import os
import pandas as pd
import matplotlib.pyplot as plt
#%%
features_cont = pd.read_csv("../Outputs/Features/cluster_inputs/features_cont_std.csv",  index_col = 'id')
#features_cat = pd.read_csv("../Outputs/features_cat.csv")


#%%

pca = PCA().fit(features_cont)

#%%
comps = pd.DataFrame(pca.components_, columns = features_cont.columns).transpose()
#comps.to_csv("../Outputs/Descriptives/pca_components.csv")
var = pca.explained_variance_ratio_
noise = pca.noise_variance_

loadings = pd.DataFrame(pca.components_.T * np.sqrt(pca.explained_variance_),
                         index= features_cont.columns)
loadings.to_csv("../Outputs/Descriptives/pca_factorloadings.csv")
#%%
x = np.arange(1, len(var)+2, 2)
xl = np.arange(2, len(var)+2, 2)

plt.figure(figsize=(10,7))
plt.plot(np.cumsum(var))
plt.plot(24,np.cumsum(var)[24], 'ro')
plt.xticks(x, xl)
SIZE = 20
plt.title("Cumulative % Variance vs Principal Components")
plt.xlabel('Number of Components')
plt.ylabel('Cumulative % Variance Explained')
plt.rc('font', size=SIZE)
plt.rc('axes', titlesize=SIZE)
plt.legend()

plt.savefig("../Outputs/Plots/pca_vs_variance_2.png")

#%%
Xt = pca.transform(features_cont)
#%%
np.savetxt( "../Outputs/Features/cluster_inputs/features_z_pca24.csv", Xt, delimiter=',')


#%% https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html#sphx-glr-auto-examples-datasets-plot-iris-dataset-py

Xt = np.loadtxt( "../Outputs/Features/cluster_inputs/features_z_pca10.csv", delimiter=',')

#%%
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

#%%
fig2 = plt.figure(2)
plt.scatter(Xt[:, 0], Xt[:, 1])
plt.title('PCA Components', fontsize = 20)
plt.xlabel(r'Component 1', fontsize=15)
plt.ylabel(r'Component 2', fontsize=15)
plt.show()

#%%
fig1 = plt.figure(1)
ax = Axes3D(fig1)
ax.scatter(Xt[:, 0], Xt[:, 1], Xt[:, 2])
plt.title('PCA Components', fontsize = 20)
ax.set_xlabel(r'Component 1', fontsize=15)
ax.set_ylabel(r'Component 2', fontsize=15)
ax.set_zlabel(r'Component 3', fontsize=15)
plt.show()



