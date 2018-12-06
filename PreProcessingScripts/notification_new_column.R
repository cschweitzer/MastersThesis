notification_new_column <- function(appdata="../Outputs/PreProcessing/data_w_categories",
                                    notifications = "../Outputs/PreProcessing/newnotifcol.csv",
                                    output="../Outputs/data_cat_newnotif"){ 
  
  
  appdata <- readRDS(appdata)
  
  newcol <- read.csv(notifications)
  
  newcol$X <- NULL
  
  newcol$temp <- ifelse(newcol$notification_new == "True", "True", 'False')
  
  newcol$notification_new <- as.logical(newcol$temp)
  
  newcol$temp <- NULL
  
  data <- merge(appdata, newcol)
  
  saveRDS(data,output)
  write.csv(data,paste0(output,".csv"), row.names = FALSE)
  
  return(data)
  
}
