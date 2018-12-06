library(dplyr)
library(tidyr)


apps_position <- function(input="../../Outputs/PreProcessing/clean_data",
                          output="../../Outputs/PreProcessing/apps_position"){ 

  appdata <- readRDS(input)
  
  appdata <- appdata %>% select(-duration) %>% arrange(id, startTime)
  
  apps_condensed<- appdata %>%
    group_by(id, session) %>%
    mutate(app_num = row_number(startTime)) %>%
    ungroup()
  
  apps_condensed$app_num <- ifelse(apps_condensed$application == lag(apps_condensed$application) &
                                    apps_condensed$id == lag(apps_condensed$id) &
                                    apps_condensed$session == lag(apps_condensed$session),
                                  lag(apps_condensed$app_num),
                                  apps_condensed$app_num)
  
  apps_condensed$app_num <- ifelse(apps_condensed$application == lag(apps_condensed$application) &
                                      apps_condensed$id == lag(apps_condensed$id) &
                                      apps_condensed$session == lag(apps_condensed$session),
                                    lag(apps_condensed$app_num),
                                    apps_condensed$app_num)
  
    
  apps_position <- apps_condensed %>%
    group_by(id, session, application, app_num) %>%
    summarise(battery = mean(battery), notification = first(notification), notification_new = first(notification_new),
              startTime_str = first(startTime_str), startTime = min(startTime), startTimeMillis=min(startTimeMillis),
              endTime_str = max(endTime_str), endTime = min(endTime), endTimeMillis=min(endTimeMillis),
              duration_s = sum(duration_s)) %>%
    ungroup() %>%
    group_by(id, session) %>%
    mutate(app_num = row_number(startTime)) %>%
    mutate(relative_position = case_when(app_num == 1 & app_num == max(app_num) ~ "only",
                                         app_num != 1 & app_num == max(app_num) ~ "last",
                                         app_num == 1 & app_num != max(app_num) ~ "first",
                                         TRUE ~ "middle")) %>%
    ungroup()
  
  
  saveRDS(apps_position,output)
  write.csv(apps_position,paste0(output,".csv"), row.names = FALSE)
  
  return(apps_position)

}
