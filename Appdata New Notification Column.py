
# coding: utf-8

# In[]:
import csv
import pandas as pd
import time
import pickle
import numpy as np

# In[]:
with open('../Outputs/PreProcessing/notifications_sessiontimecols_pd.pkl', 'rb') as file:
    notifdata = pickle.load(file)

#%%

session_notif = notifdata[['id','session','application']].drop_duplicates()

#%%

session_notif.to_csv("../Outputs/PreProcessing/notifications_col_new.csv")