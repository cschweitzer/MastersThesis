import csv
import pandas as pd
import time
import pickle
import numpy as np
#%%
with open('../../Outputs/PreProcessing/notifications_sessiontimecols_pd.pkl', 'rb') as file:
    notifdata = pickle.load(file)


#%%
notifdata.sort_values(by=['id', 'notification_time'], inplace = True)
#%%
notifdata['response_time_session'] = (notifdata.next_session - notifdata.notification_time).dt.total_seconds()

#notifdata['response_time_session_app'] = (notifdata.next_session_app_use - notifdata.notification_time).dt.total_seconds()

notifdata['response_time_app'] = (notifdata.next_app_use - notifdata.notification_time).dt.total_seconds()

#%%

features1 = notifdata.groupby("id")["response_time_session"].agg([np.median, np.std]).rename(columns={"median": "response_time_session_median", "std": "response_time_session_std"})

features2 = notifdata.groupby("id")["response_time_app"].agg([np.median, np.std]).rename(columns={"median": "response_time_app_median", "std": "response_time_app_std"})

features = features1.merge(features2, how = 'outer', on = 'id')


#%%

features.to_csv("../../Outputs/Features/notification_responsetime.csv")