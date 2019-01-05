# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 12:22:49 2018

@author: schwe
"""
import numpy as np
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

    if "_times" in i:
        cols = features_cont.columns[features_cont.columns.str.contains(pat = '_times')]
        vals = features_cont.loc[:,cols].median()
        features_cont.loc[:,cols] = features_cont.loc[:,cols].fillna(vals)
#%%
features_cont.isnull().any()
#%%

features_cont.to_csv( "../Outputs/Features/cluster_inputs/features_cont.csv")
#%%
features_cat.to_csv( "../Outputs/Features/cluster_inputs/features_cat_cat.csv")

#%%
features_cont_std = features_cont.copy(deep = True)
#%%
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_cont_z = scaler.fit_transform(features_cont_std.values)

features_cont_std.loc[:,:] = X_cont_z
#%%
features_cont_std.to_csv( "../Outputs/Features/cluster_inputs/features_cont_std.csv")

#%%
features_combined = pd.merge(features_cont_std, features_cat,  left_index = True, right_index = True, how = 'outer')

features_combined.to_csv( "../Outputs/features_combined_cat.csv")
