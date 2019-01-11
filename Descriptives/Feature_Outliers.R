library(stats)
library(moments)

outliers <- function(file, output){
  outlier_info <- data.frame()
  
  features <- read.csv(file,stringsAsFactors = F, row.names = 1)
  
  for (i in 1:ncol(features)){
    data <- features[,i]
    outs <- boxplot.stats(data)$out
    
    num_low_outliers <- sum(outs < mean(data))
    avg_low_outliers <- mean(outs[outs < mean(data)])
    
    num_high_outliers <- sum(outs > mean(data))
    avg_high_outliers <- mean(outs[outs > mean(data)])

      
    temp <-c(length(outs), length(outs)/length(data), 
             num_low_outliers, avg_low_outliers,
             num_high_outliers, avg_high_outliers)
    
    outlier_info <- rbind(outlier_info, temp, stringsAsFactors = F)
    }
  
  row.names(outlier_info) <- names(features)
  
  names(outlier_info) <- c("num_outliers","proportion_outliers", 
                           "num_low_outliers", "avg_low_outliers",
                           "num_high_outliers", "avg_high_outliers")
  write.csv(outlier_info,output)
  
  return(outlier_info)
}


outliers("../../Outputs/Features/cluster_inputs/features_cont.csv",
         "../../Outputs/Descriptives/outlier_info.csv")
