citation("factoextra")
citation("cluster")
citation("fpc")
citation("NbClust")


library(factoextra)
library(cluster)
library(fpc)
library(NbClust)
library(ggplot2)
library(plotly)
library("gg3D")


features <-read.csv("../../Outputs/Features/cluster_inputs/features_z_pca5.csv",
                      header = FALSE)


d <- dist(features, method = "euclidean") # distance matrix

#######

get_clust_tendency(features,750)




###############
library(dbscan)

dbscan::kNNdistplot(d, k =  9)

kdistinfo <- dbscan::kNNdist(d, k = 9)
kdistsorted <- data.frame(1:length(kdistinfo), kdistinfo[order(kdistinfo)]) 
colnames(kdistsorted) <-c('points', "distance")

ggplot(kdistsorted, aes( x = points, y = distance))+
  geom_line()+
  labs(y = "9-Distance", x = "Points (sorted by distance)",
       title = "5 PC: KNN Distance Plot (Minpts: 10)")+
  coord_cartesian(xlim = c(24000,28000),
                  ylim = c(0,30))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))


################DBCAN


set.seed(111)

#minpts = c(24, 48, 50, 60, 75, 100)
#eps = c( 3,4,5,6,7,8,9,10,11,12,13,14, 15,16,17,18,19,20)

minpts = c(5, 10, 15, 30)
eps = c(.5,1,4)


dbsummary <- data.frame()
  
for (i in eps){
  for (j in minpts){
    dbcluster <- fpc::dbscan(features, i, j, method = "raw")
    
    dbcluster_noiseadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1)
    
    if(sum(dbcluster$cluster) ==0){next}
    
    stats <- cluster.stats(d, dbcluster_noiseadj, noisecluster = T,  sepwithnoise = F)
      
    #stats <- cluster.stats(d,  dbcluster$cluster)
      
    temp <- c(i,j, stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, stats$noisen,
                stats$within.cluster.ss,stats$average.within, stats$average.between, 
                stats$avg.silwidth, stats$dunn2)
    dbsummary <- rbind(dbsummary, temp)
    }
}

colnames(dbsummary) <- c("eps","minpts",
                         "n_clusters","max_cl_size","min_cl_size",'Noise',"SSE","avg_within","avg_btn",
                         "Sil","Dunn2")


write.csv(dbsummary,"../../Outputs/Clustering/r_db_clustering_summary_pca24_noiseadj_seed111_more.csv", row.names= F)

#dbsummary <- read.csv("../../Outputs/Clustering/r_db_clustering_summary_pca5_noiseadj.csv", row.names= F)

####################
dbcluster <- fpc::dbscan(features, 4, 5, method = "raw")

db_stats <- cluster.stats(d,  dbcluster$cluster, noisecluster = T)


dbcluster_noiseadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1)
db_stats2 <- cluster.stats(d, dbcluster_noiseadj, noisecluster = T)

dbcluster_altadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1) -1
db_stats3 <- cluster.stats(d, dbcluster_altadj, noisecluster = T, alt.clustering = kcluster$cluster)

db_stats
db_stats2
db_stats3

clusterdf <- cbind(features, dbcluster$cluster, 
                   factor(dbcluster$cluster, labels = c("Noise", "Cluster 1", "Cluster 2")))

colnames(clusterdf) <- c("PC1",
                         "PC2",
                         "PC3",
                         "PC4",
                         "PC5",
                         "cluster_val",
                         "Cluster")

write.csv(clusterdf, "../../Outputs/Clustering/cluster_indices_dbscan_4_5.csv", row.names = F)

temp <- c(6,15,
          stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, stats$noisen,
          stats$within.cluster.ss,stats$average.within, stats$average.between, 
          stats$avg.silwidth, stats$dunn2)
dbsummary <- rbind(dbsummary, temp)


fviz_cluster(dbcluster, features,geom = "point", stand = FALSE, 
             choose.vars = c("V1", "V2"),
             pointsize = 1.5, labelsize = 12, main = "DBSCAN Clusters (2 PC)",
             shape = 19, outlier.shape = 5,
             show.clust.cent = F,
             xlab = "PCA Component 1 (17.0%)",
             ylab = "PCA Component 2 (11.5%)",
             ggtheme = theme_bw(),legend.title = "Clusters")+
  theme(plot.title = element_text(hjust = 0.5))


ggplot(filter(clusterdf, cluster_val > 0), aes(x = PC1, y = PC2, color = Cluster))+
  geom_point()+
  labs(x = "PCA Component 1 (17.0%)",
       y = "PCA Component 2 (11.5%)",
       legend.title = "Clusters",
       title = "DBSCAN Clusters - Without Noise")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))

ggplot(clusterdf, aes(x = PC1, y = PC2, color = Cluster))+
  geom_point()+
  labs(x = "PCA Component 1 (17.0%)",
       y = "PCA Component 2 (11.5%)",
       legend.title = "Clusters",
       title = "DBSCAN Clusters (2 PC)")+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))



plot_ly(x =features$V3,y = features$V4,
        type="scatter", mode="markers", color=factor(dbcluster_noiseadj))

plot_ly(x =features$V1,y = features$V2,  z=features$V3, 
        type="scatter3d", mode="markers", color=factor(dbcluster$cluster)) %>%
  layout(
    title = "Clusters over Principle Components",
    scene = list(
      xaxis = list(title = "PCA Component 1 (17.0%)"),
      yaxis = list(title = "PCA Component 2 (11.5%)"),
      zaxis = list(title = "PCA Component 3: 9.9%")
    ))


ggplot(clusterdf, aes(x = PC1, y = PC2, z = PC3, color = Cluster))+
  axes_3D() +
  labs_3D(label = c("PCA Component 1 (17.0%)","PCA Component 2 (11.5%)","PCA Component 3: 9.9%"))+
  stat_3D()+
  theme_void()+
  legend()


sildb <- silhouette(dbcluster$cluster, d)
fviz_silhouette(sildb)

#########

set.seed(111)
kvals <- c(2,3,4,5,6,7,8,9,10,11,12, 13,14,15, 16, 17, 18, 19, 20)
#kvals <- c(16, 17, 18, 19, 20)
ksummary <- data.frame()

for (k in kvals){
  kcluster <- kmeans(features, k)
  
  stats <- cluster.stats(d, kcluster$cluster)
  
  temp <- c(k, stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, stats$noisen,
            stats$within.cluster.ss,stats$average.within, stats$average.between, 
            stats$avg.silwidth, stats$dunn2, kcluster$tot.withinss,  kcluster$betweenss, 
            kcluster$iter, kcluster$ifault)
  ksummary <- rbind(ksummary, temp)

}
colnames(ksummary) <- c("k",
                         "n_clusters","max_cl_size","min_cl_size",'Noise',"SSE","avg_within","avg_btn",
                         "Sil","Dunn2", "kcl_withinss", "kclbetweenss",
                        "iter","ifault")

write.csv(ksummary, "../../Outputs/Clustering/r_kmeans_summary_seed111.csv", row.names = F)

ksummary <- ksummary %>% filter(n_clusters < 16)

ggplot(ksummary, aes(x=n_clusters, y = SSE))+
  geom_line()+
  labs(x = "k",
       y = "SSE",
       title = "K-Means: Clusters vs Error")+
  ylim(0,45000)+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))

ksumadj <- filter(ksummary, n_clusters > 2)

ggplot(ksumadj, aes(x=n_clusters, y = min_cl_size))+
  geom_line()+
  labs(x = "k",
       y = "Minimum Cluster Size",
       title = "K-Means: Clusters vs Min Cluster Size")+
  scale_x_continuous(breaks=c(4,6,8,10, 12, 14))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))


set.seed(111)
kcluster <- kmeans(features, 8)

fviz_cluster(kcluster, features,geom = "point", stand = FALSE, 
             choose.vars = c("V2", "V3"),
             pointsize = 1.5, labelsize = 12, main = "K-Means 8 Clusters (2 PC)",
             xlab = "PCA Component 1 (17.0%)",
             ylab = "PCA Component 2 (11.5%)",
             shape = 19, outlier.shape = 4,show.clust.cent = F,
             ggtheme = theme_bw(),legend.title = "Clusters")+
  theme(plot.title = element_text(hjust = 0.5))

plot_ly(x =features$V2,y = features$V3,  z=features$V4, 
        type="scatter3d", mode="markers", color = kcluster$cluster)

"PCA Component 3: 9.9%"



clusterdf_k <- cbind(features, kcluster$cluster)

colnames(clusterdf_k) <- c("PC1",
                         "PC2",
                         "PC3",
                         "PC4",
                         "PC5",
                         "cluster_val")

write.csv(clusterdf_k, "../../Outputs/Clustering/cluster_indices_kmeans_8.csv", row.names = F)



# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
clusplot(features, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
plotcluster(features, fit$cluster)

####################3



##########################3

hcluster <- hclust(d, method = "ward.D")
hclust3 <- cutree(hcluster, k=3)

fviz_dend(hcluster, rect = TRUE, k =3, show_labels = FALSE)

silh <- silhouette(hcluster$cluster, d)
fviz_silhouette(silh)

hcop <- cophenetic(hcluster)
cor(d, hcop)

hc_stats <- cluster.stats(d, hclust3)
hc_stats

#### https://stackoverflow.com/questions/11462901/cluster-presentation-dendrogram-alternative-in-r


hclust3_toplot <- data.frame(features[,1:3], factor(hclust3))
names(hclust3_toplot) <- c("PCA 1","PCA 2", "Cluster")

ggplot(hclust3_toplot, aes(`PCA 1`, `PCA 2`))+
  geom_point(aes(colour=Cluster), size=3)


plot_ly(x =hclust3_toplot$V2,y = hclust3_toplot$V3,  z=hclust3_toplot$V4, 
        type="scatter3d", mode="markers", color=factor(hclust3))
