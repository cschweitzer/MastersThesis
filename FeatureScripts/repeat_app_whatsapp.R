library(dplyr)

repeat_app_whatsapp <- function(input="../Outputs/apps_position",
                                output="../Features/repeat_app_whatsapp",
                                notification = c(TRUE, FALSE),
                                type = c('orig','new')){ 
  

  apps_position <- readRDS(input)
  
  apps_whatsapp <- apps_position %>% group_by(id, session) %>%
    summarise(whatsapp_cnt = sum(
      grepl('whatsapp',application, fixed = T)),
      notification_start = first(notification)) %>%
    ungroup()
  
  if(!missing(notification) & !missing(type)){
    
    if(type == 'orig'){
      sessions <- filter(apps_whatsapp, notification_start == notification)
      if(notification == TRUE){output <- paste0(output,"_notif_orig_true")}
      if(notification == FALSE){output <- paste0(output,"_notif_orig_false")}
    }
    
    if(type == 'new'){
      sessions <- filter(apps_whatsapp, notification_start_new == notification)
      if(notification == TRUE){output <- paste0(output,"_notif_new_true")}
      if(notification == FALSE){output <- paste0(output,"_notif_new_false")}
    }
  }
  

  #xtabs(~whatsapp_cnt, apps_whatsapp)
  
  whatsapp_sessions_count <- apps_whatsapp %>%
    count(id) %>% rename(total = n)
  
  
  repeats <- apps_whatsapp %>% 
    filter(whatsapp_cnt > 1) %>%
    count(id) %>% rename(repeats = n)
  
  
  whatsapp_repeats <- whatsapp_sessions_count %>% 
    left_join(repeats,by = "id") %>%
    mutate(repeats = ifelse(is.na(repeats), 0, repeats),
           prop_repeat_sessions = (repeats / total)) %>%
    select(id, prop_repeat_sessions)
  
  
  saveRDS(whatsapp_repeats,output)
  write.csv(whatsapp_repeats,paste0(output,".csv"), row.names = FALSE)
  
  return(whatsapp_repeats)
  
}