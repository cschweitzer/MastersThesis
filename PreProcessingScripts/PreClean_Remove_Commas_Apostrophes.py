
#%%
file = open('../../BigData/core_appevents.csv', 'r')
output = open('../../Outputs/PreProcessing/core_appevents_stripped.csv', 'w')
#%%

for line in file:
    new = line.replace(',','').replace("'","")
    output.write(new)

file.close()
output.close()
#%%
