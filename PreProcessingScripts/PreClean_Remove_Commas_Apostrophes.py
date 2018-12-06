
#%%
file = open('../../BigData/core_appevents.csv', 'r', encoding = 'utf-8')
output = open('../../Outputs/PreProcessing/core_appevents_stripped.csv', 'w',encoding = 'utf-8')
#%%

for line in file:
    new = line.replace(',','').replace("'","")
    output.write(new)

file.close()
output.close()
#%%
