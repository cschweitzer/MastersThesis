import csv
import pandas as pd
import time
import pickle
import numpy as np

#%%
with open('../Outputs/PreProcessing/notifications_sessiontimecols_pd.pkl', 'rb') as file:
    notifdata = pickle.load(file)


#%%
notifdata.sort_values(by=['id', 'notification_time'], inplace = True)
#%%
notifdata['response_time_session'] = (notifdata.next_session - notifdata.notification_time).apply(lambda x: x.total_seconds())

notifdata['response_time_app'] = (notifdata.next_app_use - notifdata.notification_time).apply(lambda x: x.total_seconds())

#%%
def mean_med(group):
    group.mean(numeric_only=False)

#%%

feature1 = notifdata.groupby("id")["response_time_session"].mean(numeric_only = False).reset_index

feature2 = notifdata.groupby("id")["response_time_session"].median(numeric_only = False).reset_index()


feature3 = notifdata.groupby("id")["response_time_app"].mean(numeric_only = False).reset_index()
feature4 = notifdata.groupby("id")["response_time_app"].median(numeric_only = False).reset_index()
