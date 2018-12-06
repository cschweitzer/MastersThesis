
# coding: utf-8

# In[]:
import csv
import pandas as pd
import time
import pickle
import numpy as np

# In[]: Save All data combined to file

with open('../../Outputs/PreProcessing/appdata_notifications_pd.pkl', 'rb') as file:
   alldata = pickle.load(file)


#%% Fill in Session Column for all

alldata['session'] = alldata['session'].fillna(method = "bfill")

# In[]: Next Session Use

alldata['event_num'] = alldata.groupby(["id",'session', 'event_type']).cumcount()

temp = alldata.loc[(alldata.event_type == 'app_event') & (alldata.event_num == 0), ['id','session','startTime','notification', 'application']].rename(columns={"startTime": "next_session", "notification":"session_start_notif", "application":"session_start_application"})

alldata = alldata.merge(temp, on = ['id', 'session'], how = "outer")


#%% Drop notifications that are inter-session
alldata.drop(alldata.loc[alldata.notification_time > alldata.next_session].index, inplace = True)

#%% Session start flag

alldata.loc[alldata.session_start_application == alldata.application, "session_start_app"] = True
alldata.loc[alldata.session_start_application != alldata.application, "session_start_app"] = False

alldata.drop(columns = "session_start_application", inplace = True)


# In[]: Next App Use in Session for that Application

alldata['app_event_num'] = alldata.groupby(["id",'session',"event_type", "application"]).cumcount()


temp2 = alldata.loc[(alldata.event_type=='app_event') & (alldata.app_event_num ==0), ['id','session','application','startTime','notification']].rename(columns={"startTime": "next_session_app_use", "notification":"session_app_use_notif"})

alldata = alldata.merge(temp2, on = ['id', 'session', 'application'], how = "outer")


# In[]: Next App Use overall for that Application
alldata.sort_values(['id','event_time'], inplace = True)

alldata['next_app_use'] = alldata.loc[alldata.event_type=='app_event', 'startTime']

alldata['next_app_use'] = alldata.groupby(['id','application'])['next_app_use'].fillna(method = 'bfill')


#%%
alldata.sort_values(['id','event_time'], inplace = True)

#%% Remove Unnecessary columns

alldata.drop(columns = ['event_num','app_event_num'], inplace = True)

# In[]: Save all data to file

with open('../../Outputs/PreProcessing/appdata_notifications_responsecols_pd.pkl', 'wb') as file:
    pickle.dump(alldata, file)


#%% Isolate only notification data
notifdata = alldata.loc[alldata.event_type == 'notification']

#%% Drop unnecessary rows
notifdata = notifdata.drop(columns = ['startTime','startTimeMillis','endTime','endTimeMillis','notification', 'event_type','event_time'])

#%%
notifdata.sort_values(['id','notification_time'], inplace= True)


#%%Save Only notification data to file

with open('../../Outputs/PreProcessing/notifications_sessiontimecols_pd.pkl', 'wb') as file:
    pickle.dump(notifdata, file)

