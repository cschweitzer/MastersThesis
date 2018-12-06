library(dplyr)


multi_app_sessions <- function(input="../Outputs/sessions_trains",
                               output="../Features/multi_app_sessions",
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
  
  multiple <- sessions %>% 
    filter(app_event_count > 2) %>%
    count(id) %>% rename(multi = n)
  
  multi_app_sessions <- sessions_count %>% 
    left_join(multiple,by = "id") %>%
    mutate(multi = ifelse(is.na(multi), 0, multi),
           prop_multi_sessions = (multi / total)) %>%
    select(id, prop_multi_sessions)
  
  
  saveRDS(multi_app_sessions, output)
  write.csv(multi_app_sessions,paste0(output,".csv"),
            row.names = FALSE)
  
  return(multi_app_sessions)
  
}