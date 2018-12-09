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
location = "..\Outputs\Features"
features = []
for file in os.listdir(location):
    if ".csv" in file:
        features.append(file.replace(".csv",""))
        path = os.path.join(location, file)
        if 'features_all_df' not in dir():
            features_all_df = pd.read_csv(path, index_col="id")
            features_all_df.columns = file.replace(".csv",": ") + features_all_df.columns
        else:
            df = pd.read_csv(path, index_col="id")
            df.columns = file.replace(".csv",": ") + df.columns
            features_all_df = features_all_df.merge(df, on = "id", how = "outer")
#%%
features_nona = features_all_df.copy(deep = True)

#%%
for i in features:
    if "between" in i:
        cols = features_nona.columns[features_nona.columns.str.contains(pat = 'between')]
        vals = features_nona.loc[:,cols].median()
        features_nona.loc[:,cols] = features_nona.loc[:,cols].fillna(vals)

    if "responsetime" in i:
        cols = features_nona.columns[features_nona.columns.str.contains(pat = 'responsetime')]
        vals = features_nona.loc[:,cols].median()
        features_nona.loc[:,cols] = features_nona.loc[:,cols].fillna(vals)

    if "trains" in i:
        cols = features_nona.columns[features_nona.columns.str.contains(pat = 'trains')]
        features_nona.loc[:,cols] = features_nona.loc[:,cols].fillna(0)
#%%
features_nona.isnull().any()
#%%
X = np.array(features_nona)

import pickle
pickle.dump( X, open( "../Outputs/features.pickle", "wb" ) )

#%%
pca = PCA(20)
pca.fit(X)
Xt = pca.transform(X)
#%%
pickle.dump( Xt, open( "../Outputs/features_pca.pickle", "wb" ) )
#%%
comps = pd.DataFrame(pca.components_, columns = features_all_df.columns)
#%%

