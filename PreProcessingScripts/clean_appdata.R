library(dplyr)
#library(lubridate)
##timeR package

##### Excludes Android UI



clean_appdata <- function(input="../Outputs/core_appevents_stripped_sample",
                          output="../Outputs/clean_data"){   
  
  appdata_org <- read.table(paste0(input,".csv"), header = TRUE, sep = ";", stringsAsFactors = FALSE)
  
  
  appdata <- select(appdata_org, -X, -latitude, -longitude, -data_version, -model, -app_genre_id, -app_name)
  
  appdata <- filter(appdata, !application %in% c('com.android.systemui','android', 'com.android'))
  
  appdata <- distinct(appdata)
  
  #make ids as factors
  appdata$id <- as.factor(appdata$id)
  
  ##rename original string columns to denote that
  appdata <- rename(appdata, startTime_str = startTime, endTime_str = endTime)
  
  appdata$notification <- as.logical(appdata$notification)
  
  
  ## convert timestamps to POSIXct with 3 decimals - CURRENTLY DOESN"T WORK
  #options(digit.secs = 3)
  appdata$startTime <- as.POSIXct(appdata$startTime_str, tz = "",
                                  format = "%Y-%m-%d %H:%M:%S")
  appdata$endTime <- as.POSIXct(appdata$endTime_str, tz = "",
                                  format = "%Y-%m-%d %H:%M:%S")
  
  
  ##Order events by person and then Time
  appdata <- arrange(appdata, id, startTime)
  
  
  ## remove all sessions that are not continuous, i.e have another between them
  appdata$session_order = row(appdata)[,1]
  
  badsessions <- appdata %>% group_by(id, session) %>% 
    summarise(max = last(session_order),
              min = min(session_order),
              num = (n())) %>% 
    mutate(test = ((max-min+1)/num)) %>%
    filter(test > 1) %>%
    ungroup()
  
  appdata <- appdata %>% anti_join(badsessions, by = c('id','session'))
  
  appdata <- appdata %>% select(-session_order)

  
  saveRDS(appdata, file=output)
  write.csv(appdata, file=paste0(output,".csv"), row.names = FALSE)
  
  return(appdata)
  
  
}
 
  