
# coding: utf-8

# In[]:
import csv
import pandas as pd
import time
import pickle
import numpy as np


# ### Import Appdata

# In[]:

app_pos_data = pd.read_csv("../../Outputs/PreProcessing/apps_position.csv")


# In[]: Change Select Date column to proper format

appdata = app_pos_data.copy(deep=True)

appdata['startTime'] = pd.to_datetime(appdata.startTime_str)
appdata['endTime'] = pd.to_datetime(appdata.endTime_str)


# In[]: Beware of which time column to use because of issues with Milli vs ISO

appdata["event_time"] = appdata.startTime


# In[]: Check if all are in newest clean data

appdata.drop(columns = ['battery','duration', 'duration_s', 'startTime_str', 'endTime_str'], inplace= True)



# ### Import Notification data, Clean, and Export

# In[]:

notif = pd.read_csv("../../BigData/core_notifications.csv", delimiter=";")

# In[]:
notif.drop(columns = ["Unnamed: 0","data_version", "notificationID"], inplace = True)

notif.drop(notif.loc[notif.application.isin(['com.android.systemui','android', 'com.android'])].index,inplace = True)


notif = notif[notif.posted == True]

notif.drop(columns = ["posted"], inplace = True)


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


alldata['session'] = alldata['session'].fillna(method = "bfill")

# In[]: Next Session Use

alldata['event_num'] = alldata.groupby(["id",'session', 'event_type']).cumcount()


# In[]:

temp = alldata.loc[(alldata.event_type == 'app_event') & (alldata.event_num == 0), ['id','session','startTime','notification', 'application']].rename(columns={"startTime": "next_session", "notification":"session_start_notif", "application":"session_start_application"})

# In[]:
alldata = alldata.merge(temp, on = ['id', 'session'], how = "outer")


#%% Drop notifications that are inter-session
alldata.drop(alldata.loc[alldata.notification_time > alldata.next_session].index, inplace = True)

#%%

session_notif = alldata.loc[alldata.event_type == 'notification',['id','session','application', 'next_session']].drop_duplicates()
#%%
session_notif['notification_new'] = pd.notna(session_notif['next_session'])
#%%
session_notif = session_notif.drop(columns = "next_session").drop_duplicates()

#%%

appdata = app_pos_data.merge(session_notif, how = 'left', on = ['id', 'session','application'])

#%%

notification_col = app_pos_data[['id','session','application','startTimeMillis','notification_new']]


#%%
notification_col.to_csv("../../Outputs/PreProcessing/newnotifcol.csv")