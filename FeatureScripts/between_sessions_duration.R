library(dplyr)

between_sessions_duration <- function(input="../Outputs/sessions",
                                      output="../Features/between_sessions_duration",
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
  
  
  between_sessions <- sessions %>% 
    filter(between_sessions_secs >= 0) %>%
    group_by(id) %>%
    summarise(med = median(between_sessions_secs, na.rm = T))
  
  
  saveRDS(between_sessions,output)
  write.csv(between_sessions,paste0(output,".csv"), row.names = FALSE)
  
  return(between_sessions)
  
}