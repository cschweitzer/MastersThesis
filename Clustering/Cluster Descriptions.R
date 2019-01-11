library(dplyr)


cluster_indices <- read.csv("../../Outputs/Clustering/cluster_indices_dbscan_3_4.csv")


user_features <- read.csv("../../Outputs/Features/cluster_inputs/features_cont.csv",row.names = "id", header = T)

combi <- cbind(user_features, cluster_indices)

xtabs(~x, combi)

cluster1 <- filter(combi, x == 2)

cluster2 <- filter(combi, x == 3)

summary <- summarise_all(cluster1 ,funs(mean, median, sd))

summary <- rbind(summary, summarise_all(cluster2 ,funs(mean, median, sd)))

write.csv(summary, "../../Outputs/Descriptives/cluster_summary_info.csv")
