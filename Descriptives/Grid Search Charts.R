
library(ggplot2)
pca5results <- read.csv("../../Outputs/Clustering/r_db_clustering_summary_pca5_noiseadj_seed111_more.csv")
pca10results <- read.csv("../../Outputs/Clustering/r_db_clustering_summary_pca10_noiseadj_seed111_more.csv")
pca24results <- read.csv("../../Outputs/Clustering/r_db_clustering_summary_pca24_noiseadj_seed111.csv")

pca5results$n_clusters <- pca5results$n_clusters -1
pca5results$n_pca <- 5

pca10results$n_clusters <- pca10results$n_clusters -1
pca10results$n_pca <- 10

pca24results$n_clusters <- pca24results$n_clusters -1
pca24results$n_pca <- 24

combined <- rbind(pca5results,pca10results, pca24results)

###%%%

ggplot(combined, aes(x=Noise, y=SSE, cols= as.factor(n_pca), color = as.factor(n_pca))) +
  geom_line() + 
  labs(title = "Noise vs SSE for PCA Components", color="PCA Num")+
  theme_bw()+
  theme(axis.text = element_text(size=12),  
        axis.title = element_text(size=14),
        legend.text = element_text(size=12),
        legend.title = element_text(size=12))+
  theme(plot.title = element_text(hjust = 0.5))


ggplot(combined, aes(x=Noise, y=SSE, cols= as.factor(n_pca), color = as.factor(n_pca))) +
  geom_line() + 
  labs(title = "Noise vs SSE for PCA Components", color="PCA Num")+
  theme_bw()+
  theme(axis.text = element_text(size=12),  
        axis.title = element_text(size=14),
        legend.text = element_text(size=12),
        legend.title = element_text(size=12))+
  theme(plot.title = element_text(hjust = 0.5))
