import csv
import pandas as pd
import time
import pickle
import numpy as np

from sklearn import preprocessing

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

appresponse = notifdata.groupby(["id",'application'])["response_time_session","response_time_app"].median().reset_index()


#%%

def topapp(data, time):
    if time == "session":
        top = data.nsmallest(5, "response_time_session").reset_index()
    if time == "app":
        top = data.nsmallest(5, "response_time_app").reset_index()
    return top


#%%

top_apps_session = appresponse.groupby('id')['application','response_time_session'].apply(lambda x: topapp(x, "session")).reset_index()

top_app_apps = appresponse.groupby('id')['application','response_time_app'].apply(lambda x: topapp(x, "app")).reset_index()

#%%

topapps_response_session_names = top_apps_session.pivot(index = 'id', columns = 'level_1', values = 'application')

topapps_response_app_names = top_app_apps.pivot(index = 'id', columns = 'level_1', values = 'application')


topapps_response_session= topapps_response_session_names.copy(deep = True)

topapps_response_app= topapps_response_app_names.copy(deep = True)

#%%
topapps_response_session.fillna("None", inplace = True)
topapps_response_app.fillna("None", inplace = True)


#%%
apps = appresponse.application.append(pd.Series("None"))
#%%
le = preprocessing.LabelEncoder()

le.fit(apps)
#%%
le.classes_.shape
#%%

for i in topapps_response_session.columns:
    topapps_response_session[i] = le.transform(topapps_response_session[i])

for i in topapps_response_app.columns:
    topapps_response_app[i] = le.transform(topapps_response_app[i])

#%%

topapps_response_session.to_csv("../../Outputs/Features/topapps_response_session.csv")


topapps_response_app.to_csv("../../Outputs/Features/topapps_response_app.csv")