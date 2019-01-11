library(stats)

descriptives <- function(path, files, output){
  features <- read.csv("../../Outputs/Features/cluster_inputs/features_cont.csv",stringsAsFactors = F)
  std <- c()
  kur <- c()
  skew <- c()
  
  
  for (i in 1:ncol(data)){
    data <- data[,i]
  
    stats <- rbind(stats, summary(data))
    
    std <- c(std, sd(data))
    kur <- c(kur, kurtosis(data))
    skew <- c(skew, skewness(data))
    }
  
  stats <- cbind(stats, std, kur, skew)
  
  row.names(stats) <- files
  
  names(stats) <- c("Min", "Q1", "Med", "Mean", "Q3", "Max", "sd","kurtosis","skew")
  
  write.csv(stats,output)
  
  return(stats)

}

descriptives("../../Outputs/Features/cluster_inputs/features_cont.csv",
             "../../Outputs/Descriptives/descriptive_stats_table2.csv")