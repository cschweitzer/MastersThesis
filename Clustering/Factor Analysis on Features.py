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
features_cont = pd.read_csv("../Outputs/features_cont.csv")
features_cat = pd.read_csv("../Outputs/features_cat.csv")

#%%

pca = PCA(20)
pca.fit(X_z)
Xt = pca.transform(X_z)
#%%
pickle.dump( Xt, open( "../Outputs/features_z_pca.pickle", "wb" ))

#%%
comps = pd.DataFrame(pca.components_, columns = features_all_df.columns)
#%%
test = pca.components_
