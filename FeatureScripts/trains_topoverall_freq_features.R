library(dplyr)
library(tidyr)


trains_topoverall_freq_features <- function(input="../Outputs/sessions_trains",
                                     output="../Features/trains_topoverall_freq_features.csv",
                                 notification = c(TRUE, FALSE),
                                 type = c('orig','new')){ 
  
  
  sessions_trains <- readRDS(input)
  
  sessions_trains_filtered <- filter(sessions_trains, app_event_distinct_count >1)

  if(!missing(notification) & !missing(type)){
    
    if(type == 'orig'){
      sessions <- filter(sessions_trains, notification_start == notification)
      if(notification == TRUE){output <- paste0(output,"_notif_orig_true")}
      if(notification == FALSE){output <- paste0(output,"_notif_orig_false")}
    }
    
    if(type == 'new'){
      sessions <- filter(sessions_trains, notification_start_new == notification)
      if(notification == TRUE){output <- paste0(output,"_notif_new_true")}
      if(notification == FALSE){output <- paste0(output,"_notif_new_false")}
    }
  }
  
  
  
  trains_freq <-   sessions_trains_filtered %>% 
    group_by(trains) %>%
    summarise(freq_train = n(),
              freq_user = n_distinct(id)) %>%
    mutate(freq_diff = freq_train - freq_user) %>%
    arrange(-freq_train, -freq_user) %>%
    ungroup()
  
  user_trains <- inner_join(select(sessions_trains_filtered, id, session, trains), 
                            top_n(trains_freq, 150, freq_train), by = 'trains')
  
  trains_freq_features <- user_trains %>%
    group_by(id, trains) %>%
    summarise(train_freq = n()) %>%
    left_join(count(user_trains, id), by = 'id') %>%
    ungroup() %>%
    mutate(freq = train_freq / n) %>%
    select(-train_freq, -n) %>%
    spread(trains, freq)
  
  
  saveRDS(trains_freq_features,output)
  write.csv(trains_freq_features,paste0(output,".csv"),
            row.names = FALSE)
  
  return(trains_topoverall_freq_features)
  
}