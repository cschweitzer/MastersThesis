

import csv
import pandas as pd
import time
import pickle
import numpy as np
import datetime

#%%
with open('../Outputs/PreProcessing/notifications_sessiontimecols_pd.pkl', 'rb') as file:
    notifdata = pickle.load(file)

#%%
with open('../Outputs/PreProcessing/appdata_notifications_sessiontimecols_pd.pkl', 'rb') as file:
    alldata = pickle.load(file)



#%% Look at how many sessions start with the app vs say they start with a notification

sess_start_xtab = pd.crosstab(notifdata['session_start_app'], columns=notifdata['session_start_notif'], colnames=["Session starts with Notif Flag"],
                rownames=["This App starts a Session"])


#%%
sess_exists_xtab = pd.crosstab(pd.isna(notifdata['next_app_use']), columns=notifdata['app_use_notif'], colnames=["App from Notif"],
                rownames=["This App in Session"])

#%% Look at notifications that were "answered" vs just used

#app_notif_xtab = pd.crosstab(notifdata['app_use_notif'], columns = 'App Has Notif Flag', values=notifdata['next_app_use'], aggfunc = , colnames=["App used in Session"])

#%% Look at usage events that start with a notif app but that appevent isn't marked as a notif

session = alldata.loc[(alldata.use_start_app == True) & (alldata.use_start_notif == False) & (alldata.event_type == "notification" ), "session"]

#%%

mismatch = alldata.loc[alldata.session.isin(session)]


#%%
notifdata.sort_values(by=['id', 'notification_time'], inplace = True)

notifdata['response_time_session'] = notifdata.next_session - notifdata.notification_time


notifdata['response_time_app'] = notifdata.next_app_use - notifdata.notification_time

#%%

#notifdata.sort_values(by = ['time_to_response'], inplace = True)

neg_rows = notifdata.loc[(notifdata.response_time_session < 0) |(notifdata.response_time_app< pd.Timedelta(0))]