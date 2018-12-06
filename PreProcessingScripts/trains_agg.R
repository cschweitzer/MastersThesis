library(dplyr)
library(tidyr)

trains_agg <- function(input_apps="../Outputs/apps_position",
                       input_sessions="../Outputs/sessions",
                          output="../Outputs/sessions_trains"){ 

  
  apps_position <- readRDS(input_apps)
  sessions <- readRDS(input_sessions)
  
  apps_position <- apps_position %>% arrange(id, startTime)
  
  apps_trains_string <- apps_position %>% select(id, session, application) %>%
    group_by(id, session) %>%
    summarise(trains = paste0(application, collapse = " - ")) %>%
    ungroup()

  
  sessions_trains <- full_join(sessions, apps_trains_string, by = c("id", "session"))
  
  saveRDS(sessions_trains, output)
  write.csv(sessions_trains, paste0(output,".csv"),
            row.names = FALSE)
  
  return(sessions_trains)

}

