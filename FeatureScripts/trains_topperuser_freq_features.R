library(dplyr)
library(tidyr)


trains_topperuser_freq_features <- function(input="../../Outputs/PreProcessing/sessions_trains",
                                     output_feat="../../Outputs/Features/trains_topperuser_freq_features",
                                     output_desc="../../Outputs/Descriptives/trains_topperuser",
                                     notification = c(TRUE, FALSE),
                                     type = c('orig','new')){
  
  
  sessions_trains <- readRDS(input)
  
  sessions_trains_filtered <- filter(sessions_trains, app_event_distinct_count >1)

  if(!missing(notification) & !missing(type)){
    
    if(type == 'orig'){
      sessions <- filter(sessions_trains, notification_start == notification)
      if(notification == TRUE){
        output_feat <- paste0(output_feat,"_notif_orig_true")
        output_desc <- paste0(output_desc,"notif_orig_true")}
      if(notification == FALSE){
        output_feat <- paste0(output_feat,"_notif_orig_false")
        output_desc <- paste0(output_desc,"notif_orig_false")}
    }
    
    if(type == 'new'){
      sessions <- filter(sessions_trains, notification_start_new == notification)
      if(notification == TRUE){
        output_feat <- paste0(output_feat,"_notif_new_true")
        output_desc <- paste0(output_desc,"notif_new_true")}
      if(notification == FALSE){
        output_feat <- paste0(output_feat,"_notif_new_false")
        output_desc <- paste0(output_desc,"notif_new_false")}
    }
  }
  
  
  total_trains <- sessions_trains_filtered %>%
    count(id) %>% rename(total_trains = n)
  
  
  trains_freq <- sessions_trains_filtered %>% 
    group_by(id, trains) %>%
    summarise(train_freq = n()) %>% ungroup()
  
  write.csv(trains_freq, paste0(output_desc,".csv"), row.names = F)
    
  trains_top <- trains_freq %>% 
    arrange(id, -train_freq) %>%
    group_by(id) %>%
    mutate(rank = row_number()) %>%
    filter(rank < 6) %>%
    ungroup()

  
  trains_top_prop <- total_trains %>% 
    left_join(trains_top,by = "id") %>%
    mutate(prop_top_train = (train_freq / total_trains)) %>%
    select(id, rank, prop_top_train) %>%
    spread(key = rank, value = prop_top_train)

  
  saveRDS(trains_top_prop,output_feat)
  write.csv(trains_top_prop,paste0(output_feat,".csv"),
            row.names = FALSE)
  
  return(trains_top_prop)
  
}