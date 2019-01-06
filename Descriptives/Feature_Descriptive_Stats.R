
descriptives <- function(path, files, output){
  stats <- data.frame()
  std <- c()
  
  
  for (i in 1:length(files)){
    file <- paste0(path, files[i])
    data <- read.csv(file, stringsAsFactors = F)
  
    stats <- rbind(stats, summary(data[,2]))
    std <- c(std, sd(data[,2]))
    }
  
  stats <- cbind(stats, std)
  
  row.names(stats) <- files
  
  names(stats) <- c("Min", "Q1", "Med", "Mean", "Q3", "Max", "sd")
  
  write.csv(stats,output)
  
  return(stats)

}

descriptives("../../Outputs/Features/cont/",c("multi_app_sessions.csv",
                                         "single_app_sessions.csv",
                                         "notification_responsetime.csv",
                                         "repeat_app_sessions.csv",
                                         "repeat_app_whatsapp.csv",
                                         "between_sessions_duration.csv"),
             "../../Outputs/Descriptives/descriptive_stats_table.csv")