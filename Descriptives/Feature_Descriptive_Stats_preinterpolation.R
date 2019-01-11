library(moments)

descriptives <- function(path, output){
  stats <- data.frame()
  std <- c()
  kur <- c()
  skew <- c()
  rows <- c()
  
  files <- dir(path, pattern =".csv")
  
  for (file in files){
    feature <- paste0(path,file)
    data <- read.csv(feature, stringsAsFactors = F, row.names = 1, header = T)
    
    for (i in 1:ncol(data)){
    
      rows <- c(rows, paste0(sub(".csv",": ",file),names(data[i])))
      stats <- rbind(stats, summary(data[,i]))
      
      std <- c(std, sd(data[,i], na.rm = T))
      kur <- c(kur, kurtosis(data[,i], na.rm = T))
      skew <- c(skew, skewness(data[,i], na.rm = T))
    }
  }
  
  stats <- cbind(stats, std, kur, skew)
  
  row.names(stats) <- rows
  
  names(stats) <- c("Min", "Q1", "Med", "Mean", "Q3", "Max", "sd","kurtosis","skew")
  
  write.csv(stats,output)
  
  return(stats)

}

descriptives("../../Outputs/Features/cont/",
             "../../Outputs/Descriptives/descriptive_stats_table_preinterpolation.csv")