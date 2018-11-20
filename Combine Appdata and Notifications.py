
# coding: utf-8

# In[]:
import csv
import pandas as pd
import time
import pickle
import numpy as np


# ### Import Appdata

# In[]:

appdata = pd.read_csv("../Outputs/PreProcessing/clean_data.csv")


# In[]: Change Select Date column to proper format

appdata['startTime'] = pd.to_datetime(appdata.startTime_str)
appdata['endTime'] = pd.to_datetime(appdata.endTime_str)


# In[]: Beware of which time column to use because of issues with Milli vs ISO

appdata["event_time"] = appdata.startTime


# In[]: Check if all are in newest clean data

appdata.drop(columns = ['battery','duration', 'duration_s', 'startTime_str', 'endTime_str'], inplace= True)



# ### Import Notification data, Clean, and Export

# In[]:

notif = pd.read_csv("../OrigData/core_notifications_randsample.csv", delimiter=";")

# In[]:
notif.drop(columns = ["Unnamed: 0","data_version", "notificationID"], inplace = True)

notif = notif[notif.posted == True]

notif.drop(columns = ["posted"], inplace = True)


# In[]

with open('../Outputs/notifications_postedtrue_clean.pkl', 'wb') as file:
    pickle.dump(notif, file)

notif.to_csv('../Outputs/notifications_postedtrue_clean.csv', index=False)

# ## Combine Appdata and Notifications

# In[]: load notification data

#with open('../Outputs/notifications_postedtrue_clean.pkl', 'rb') as file:
 #   notif_clean = pickle.load(file)


# In[]:

notif['notification_time'] = pd.to_datetime(notif.time)

notif.drop(columns = 'time', inplace = True)

notif['event_time'] = notif.notification_time


# In[]: Merge Data Frames and Export

alldata = notif.append(appdata, sort = True)


# In[]:Manipulate Alldata

alldata.loc[pd.notna(alldata.startTime), "event_type"] = "app_event"
alldata.loc[pd.isna(alldata.startTime), "event_type"] = "notification"


#%%
alldata = alldata.sort_values(by = ["id", "event_time"]).reset_index(drop=True)


# In[]: Save All data combined to file

with open('../Outputs/PreProcessing/appdata_notifications_pd.pkl', 'wb') as file:
    pickle.dump(alldata, file)


#%% Fill in Session Column for all

alldata['session'] = alldata['session'].fillna(method = "bfill")

# In[]: Next Session Use

alldata['event_num'] = alldata.groupby(["id",'session', 'event_type']).cumcount()


# In[]:

temp = alldata.loc[(alldata.event_type == 'app_event') & (alldata.event_num == 0), ['id','session','startTime','notification', 'application']].rename(columns={"startTime": "next_session", "notification":"session_start_notif", "application":"session_start_application"})

# In[]:
alldata = alldata.merge(temp, on = ['id', 'session'], how = "outer")


#%% Drop notifications that are inter-session
alldata.drop(alldata.loc[alldata.notification_time > alldata.next_session].index, inplace = True)

#%% Use start flag

alldata.loc[alldata.session_start_application == alldata.application, "session_start_app"] = True
alldata.loc[alldata.session_start_application != alldata.application, "session_start_app"] = False

alldata.drop(columns = "session_start_application", inplace = True)


# In[]: Next App Use for that Application

alldata['app_event_num'] = alldata.groupby(["id",'session',"event_type", "application"]).cumcount()


# In[]:

temp2 = alldata.loc[(alldata.event_type=='app_event') & (alldata.app_event_num ==0), ['id','session','application','startTime','notification']].rename(columns={"startTime": "next_app_use", "notification":"app_use_notif"})


# In[]:

alldata = alldata.merge(temp2, on = ['id', 'session', 'application'], how = "outer")
#%%
alldata.sort_values(['id','event_time'], inplace = True)

#%% Remove Unnecessary columns

alldata.drop(columns = ['event_num','app_event_num'], inplace = True)

# In[]: Save all data to file

with open('../Outputs/PreProcessing/appdata_notifications_sessiontimecols_pd.pkl', 'wb') as file:
    pickle.dump(alldata, file)


#%% Isolate only notification data
notifdata = alldata.loc[alldata.event_type == 'notification']

#%% Drop unnecessary rows
notifdata = notifdata.drop(columns = ['startTime','startTimeMillis','endTime','endTimeMillis','notification', 'event_type','event_time'])


#%%Save Only notification data to file

with open('../Outputs/PreProcessing/notifications_sessiontimecols_pd.pkl', 'wb') as file:
    pickle.dump(notifdata, file)

