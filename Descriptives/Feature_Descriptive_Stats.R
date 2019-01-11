library(moments)

descriptives <- function(path, files, output){
  stats <- data.frame()
  std <- c()
  kur <- c()
  skew <- c()
  
  
  for (i in 1:length(files)){
    file <- paste0(path, files[i])
    data <- read.csv(file, stringsAsFactors = F)
  
    stats <- rbind(stats, summary(data[,2]))
    
    std <- c(std, sd(data[,2], na.rm = T))
    kur <- c(kur, kurtosis(data[,2], na.rm = T))
    skew <- c(skew, skewness(data[,2], na.rm = T))
    }
  
  stats <- cbind(stats, std, kur, skew)
  
  row.names(stats) <- files
  
  names(stats) <- c("Min", "Q1", "Med", "Mean", "Q3", "Max", "sd","kurtosis","skew")
  
  write.csv(stats,output)
  
  return(stats)

}

descriptives("../../Outputs/Features/cont/",c("multi_app_sessions.csv",
                                         "single_app_sessions.csv",
                                         "notification_responsetime.csv",
                                         "repeat_app_sessions.csv",
                                         "repeat_app_whatsapp.csv",
                                         "between_sessions_duration.csv",
                                         "topapps_response_app_times.csv",
                                         "topapps_response_session_times.csv"),
             "../../Outputs/Descriptives/descriptive_stats_table2.csv")