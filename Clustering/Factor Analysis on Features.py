# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 12:22:49 2018

@author: schwe
"""
import numpy as np
from sklearn.decomposition import PCA
import os
import pandas as pd

#%%
features_cont = pd.read_csv("../Outputs/Features/cluster_inputs/features_cont_std.csv",  index_col = 'id')
#features_cat = pd.read_csv("../Outputs/features_cat.csv")

#%%

pca = PCA(5).fit(features_cont)

#%%
comps = pd.DataFrame(pca.components_, columns = features_cont.columns)

var = pca.explained_variance_ratio_
noise = pca.noise_variance_
#%%
Xt = pca.transform(features_cont)
#%%
np.savetxt( "../Outputs/Features/cluster_inputs/features_z_pca5.csv", Xt, delimiter=',')


#%% https://scikit-learn.org/stable/auto_examples/datasets/plot_iris_dataset.html#sphx-glr-auto-examples-datasets-plot-iris-dataset-py

import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from sklearn import datasets
from sklearn.decomposition import PCA

fig2 = plt.figure(2)
plt.scatter(Xt[:, 0], Xt[:, 1])
plt.show()

#%%
fig1 = plt.figure(1)
ax = Axes3D(fig1)
ax.scatter(Xt[:, 0], Xt[:, 1], Xt[:, 2])
plt.scatter(Xt[:, 0], Xt[:, 1])
plt.show()



