import csv
import pandas as pd
import time
import pickle
import numpy as np

#%%
with open('../Outputs/notifications_sessiontimecols_pd.pkl', 'rb') as file:
    notifdata = pickle.load(file)



#%%
notifdata['time_to_response'] = notifdata.next_session - notifdata.notification_time


#%%

notifdata.groupby("id")["time_to_response"].agg([mean(numeric_only = False)])

#%%

feature1 = notifdata.groupby("id")["time_to_response"].mean(numeric_only = False).reset_index()
feature2 = notifdata.groupby("id")["time_to_response"].median(numeric_only = False).reset_index()
