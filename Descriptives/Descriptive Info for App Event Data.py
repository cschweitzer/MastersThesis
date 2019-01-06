
# coding: utf-8

# In[1]:


import csv
import pandas as pd
import numpy as np
get_ipython().run_line_magic('config', 'IPCompleter.greedy=True')
from datetime import datetime
import matplotlib as plt
get_ipython().run_line_magic('matplotlib', 'inline')
import pickle
from datetime import timedelta


data = pd.read_csv("../../Outputs/PreProcessing/apps_position.csv")
# ## Time period per user

# In[94]:

data.startTime = pd.to_datetime(data.startTime)
data.endTime = pd.to_datetime(data.endTime)


#%%

user_timeperiods = data.groupby(["id"],group_keys=False)["startTime","endTime"].apply(lambda x: x.endTime.max() - x.startTime.min())


# In[95]:


print(user_timeperiods.describe())
#user_timeperiods.values


# ## Sessions per User

# In[96]:
user_sessions = data.groupby(["id"])['session'].count()


# In[97]:

user_sessions.describe()
