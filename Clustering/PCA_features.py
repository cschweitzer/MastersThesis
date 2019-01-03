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
feature_dict = dict()
#%%
def features_combine(location, datatype):
    for file in os.listdir(location):
        if ".csv" in file:
            feature_dict[file.replace(".csv","")] = datatype
            path = os.path.join(location, file)
            if 'features_df' not in dir():
                features_df = pd.read_csv(path, index_col="id")
                features_df.columns = file.replace(".csv",": ") + features_df.columns
            else:
                df = pd.read_csv(path, index_col="id")
                df.columns = file.replace(".csv",": ") + df.columns
                features_df = features_df.merge(df, on = "id", how = "outer")
    return features_df.copy(deep = True)

#%%

features_cont = features_combine("..\Outputs\Features\cont",'cont')
#%%
features_cat = features_combine("..\Outputs\Features\cat",'cat')

#%%
for i in features_cont.columns:
    if "between" in i:
        cols = features_cont.columns[features_cont.columns.str.contains(pat = 'between')]
        vals = features_cont.loc[:,cols].median()
        features_cont.loc[:,cols] = features_cont.loc[:,cols].fillna(vals)

    if "responsetime" in i:
        cols = features_cont.columns[features_cont.columns.str.contains(pat = 'responsetime')]
        vals = features_cont.loc[:,cols].median()
        features_cont.loc[:,cols] = features_cont.loc[:,cols].fillna(vals)

    if "trains" in i:
        cols = features_cont.columns[features_cont.columns.str.contains(pat = 'trains')]
        features_cont.loc[:,cols] = features_cont.loc[:,cols].fillna(0)
#%%
features_cont.isnull().any()
#%%
X = np.array(features_nona)
#%%

from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_z = scaler.fit_transform(X)

#%%
import pickle
pickle.dump( X_z, open( "../Outputs/features_std.pickle", "wb" ) )

#%%
#X = pickle.load( Xt, open( "../Outputs/features.pickle", "rb" ) )
#X_z = pickle.load( Xt, open( "../Outputs/features_std.pickle", "rb" ) )

pca = PCA(20)
pca.fit(X_z)
Xt = pca.transform(X_z)
#%%
pickle.dump( Xt, open( "../Outputs/features_z_pca.pickle", "wb" ))

#%%
comps = pd.DataFrame(pca.components_, columns = features_all_df.columns)
#%%
test = pca.components_
