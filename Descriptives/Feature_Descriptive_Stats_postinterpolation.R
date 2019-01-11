library(stats)
library(moments)

descriptives <- function(path, output){
  features <- read.csv("../../Outputs/Features/cluster_inputs/features_cont.csv",
                       stringsAsFactors = F, row.names = 1)
  stats <- data.frame()
  std <- c()
  kur <- c()
  skew <- c()
  
  
  for (i in 1:ncol(features)){
    data <- features[,i]
  
    stats <- rbind(stats, summary(data, na.rm = T))
    
    std <- c(std, sd(data, na.rm = T))
    kur <- c(kur, kurtosis(data, na.rm = T))
    skew <- c(skew, skewness(data, na.rm = T))
    }
  
  stats <- cbind(stats, std, kur, skew)
  
  row.names(stats) <- names(features)
  
  names(stats) <- c("Min", "Q1", "Med", "Mean", "Q3", "Max", "sd","kurtosis","skew")
  
  write.csv(stats,output)
  
  return(stats)

}

descriptives("../../Outputs/Features/cluster_inputs/features_cont.csv",
             "../../Outputs/Descriptives/descriptive_stats_table_postinterpolation.csv")