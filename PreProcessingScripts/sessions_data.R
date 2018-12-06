library(dplyr)


sessions_data <- function(input="../../Outputs/PreProcessing/apps_position",
                          output="../../Outputs/PreProcessing/sessions"){ 


  apps_position <- readRDS(input)
  
  if(typeof(apps_position$startTime) == "character") {
    apps_position$startTime <- as.POSIXct(apps_position$startTime_str, tz = "",
                                    format = "%Y-%m-%d %H:%M:%S")
    apps_position$endTime <- as.POSIXct(apps_position$endTime_str, tz = "",
                                  format = "%Y-%m-%d %H:%M:%S")
    
  }
  
  apps_position <- apps_position %>% arrange(id, startTime)
   
  sessions <- apps_position %>% arrange(id, startTime) %>%
    group_by(id, session) %>%
    summarise(app_event_count = n(),
              app_event_distinct_count = n_distinct(application),
              notification_start = first(notification),
              notification_start_new = first(notification_new),
              session_start = min(startTime),
              session_end = max(endTime),
              session_dur = as.numeric(max(endTime)-min(startTime)),
              session_active_dur = sum(duration_s)) %>% 
    ungroup() %>% 
    arrange(id, session_start)
    
    sessions$last_session_time <- ifelse(sessions$id == lag(sessions$id),lag(sessions$session_end), NA)
    sessions$between_sessions_secs <- ifelse(sessions$id == lag(sessions$id), 
                                              as.numeric(sessions$session_start - lag(sessions$session_end)),
                                                         NA)
  
  saveRDS(sessions, output)
  write.csv(sessions, paste0(output,".csv"), row.names = FALSE)
  
  return(sessions)

}
