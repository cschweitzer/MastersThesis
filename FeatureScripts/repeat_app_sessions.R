library(dplyr)

repeat_app_sessions <- function(input="../Outputs/sessions_trains",
                                output="../Features/repeat_app_sessions",
                                notification = c(TRUE, FALSE),
                                type = c('orig','new')){ 

  sessions <- readRDS(input)
  
  
  if(!missing(notification) & !missing(type)){
    
    if(type == 'orig'){
      sessions <- filter(sessions, notification_start == notification)
      if(notification == TRUE){output <- paste0(output,"_notif_orig_true")}
      if(notification == FALSE){output <- paste0(output,"_notif_orig_false")}
    }
    
    if(type == 'new'){
      sessions <- filter(sessions, notification_start_new == notification)
      if(notification == TRUE){output <- paste0(output,"_notif_new_true")}
      if(notification == FALSE){output <- paste0(output,"_notif_new_false")}
    }
  }
  
  
  sessions_count <- sessions %>%
    count(id) %>% rename(total = n)
  
  
  repeats <- sessions %>% 
    filter(app_event_count > app_event_distinct_count) %>%
    count(id) %>% rename(repeats = n)
  
  
  repeat_apps <- sessions_count %>% 
    left_join(repeats,by = "id") %>%
    mutate(repeats = ifelse(is.na(repeats), 0, repeats),
           prop_repeat_sessions = (repeats / total)) %>%
    select(id, prop_repeat_sessions)
  
  
  saveRDS(repeat_apps,output)
  write.csv(repeat_apps,paste0(output,".csv"), row.names = FALSE)
  
  return(repeat_apps)
  
}