
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

