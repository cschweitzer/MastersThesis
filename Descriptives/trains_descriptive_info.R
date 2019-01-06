library(dplyr)
library(tidyr)

  
  input="../../Outputs/PreProcessing/sessions_trains"
  
  sessions_trains <- readRDS(input)
  
  sessions_trains_filtered <- filter(sessions_trains, app_event_distinct_count >1)
  
  
  app_distinct_count <- as.data.frame(xtabs(~app_event_distinct_count, sessions_trains))
  app_totat_count <- as.data.frame(xtabs(~app_event_count, sessions_trains))
  app_counts <- merge(app_distinct_count, app_totat_count, by.x = "app_event_distinct_count", by.y = "app_event_count" ) %>%
    arrange(-Freq.x) %>% 
    rename(app_distinct_count = Freq.x, app_count = Freq.y) %>%
    mutate(prop_distinct = app_distinct_count/ sum(app_distinct_count),
           prop_apps = app_count/ sum(app_count))
  write.csv(app_counts, "../../Outputs/Descriptives/appcounts_freq.csv", row.names = F)
  
  totalusers <- n_distinct(sessions_trains$id)
  
  
  trains_feat <- readRDS("../../Outputs/Features/cont/trains_topoverall_freq_features")
  
  trains_top_summary <-  gather(trains_feat, key = 'train', value = 'value', -id, na.rm = TRUE) %>%
    group_by(train) %>%
    summarise(pct_users = n()/totalusers,
              mean_usage = mean(value),
              median_usage = median(value)) %>%
    ungroup() %>% arrange(-pct_users)
  
  write.csv(trains_top_summary, "../../Outputs/Descriptives/trains_top_summary.csv", row.names = F)
  