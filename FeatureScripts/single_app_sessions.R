library(dplyr)


single_app_sessions <- function(input="../Outputs/PreProcessing/sessions_trains",
                               output="../Outputs/Features/single_app_sessions",
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
  
  single <- sessions %>% 
    filter(app_event_count == 1) %>%
    count(id) %>% rename(single = n)
  
  single_app_sessions <- sessions_count %>% 
    left_join(single,by = "id") %>%
    mutate(single = ifelse(is.na(single), 0, single),
           prop_single_sessions = (single / total)) %>%
    select(id, prop_single_sessions)
  
  
  saveRDS(single_app_sessions, output)
  write.csv(single_app_sessions,paste0(output,".csv"),
            row.names = FALSE)
  
  return(single_app_sessions)
  
}