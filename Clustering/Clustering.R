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


features <-read.csv("../../Outputs/Features/cluster_inputs/features_z_pca5.csv",
                      header = FALSE)


d <- dist(features, method = "euclidean") # distance matrix

#######

get_clust_tendency(features,750)




###############
library(dbscan)

dbscan::kNNdistplot(d, k =  50)

kdistinfo <- dbscan::kNNdist(d, k =  50)
kdistsorted <- data.frame(1:length(kdistinfo), kdistinfo[order(kdistinfo)]) 
colnames(kdistsorted) <-c('points', "distance")

ggplot(kdistsorted, aes( x = points, y = distance))+
  geom_line()+
  labs(y = "X-Distance", x = "Points (sorted by distance)",
       title = "KNN Distance Plot")+
  coord_cartesian(xlim = c(145000,155000),
                  ylim = c(0,30))+
  theme_bw()+
  theme(plot.title = element_text(hjust = 0.5))


################DBCAN
#eps = c(.5, 1, 2,3,4,5,8,10, 15)
#minpts = c(3,5,10, 15, 20, 30, 50)
set.seed(111)

eps = c(4,5,6,7,8,9,10,11,12,13,14,15, 16, 17, 18)
minpts = c(20,25,30,40, 50)

dbsummary <- data.frame()
  
for (i in eps){
  for (j in minpts){
    dbcluster <- fpc::dbscan(features, i, j, method = "raw")
    
    dbcluster_noiseadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1)
    
    if(sum(dbcluster$cluster) ==0){next}
    
    stats <- cluster.stats(d, dbcluster_noiseadj, noisecluster = T)
      
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


write.csv(dbsummary,"../../Outputs/Clustering/r_db_clustering_summary_pca10_noiseadj_seed111_more.csv", row.names= F)

#dbsummary <- read.csv("../../Outputs/Clustering/r_db_clustering_summary_pca5_noiseadj.csv", row.names= F)


dbcluster <- fpc::dbscan(features, 2, 4, method = "raw")

db_stats <- cluster.stats(d,  dbcluster$cluster, noisecluster = T)


dbcluster_noiseadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1)
db_stats2 <- cluster.stats(d, dbcluster_noiseadj, noisecluster = T)

db_stats
db_stats2

write.csv(dbcluster$cluster, "../../Outputs/Clustering/cluster_indices_dbscan_3_4.csv", row.names = F)

temp <- c(6,15,
          stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, stats$noisen,
          stats$within.cluster.ss,stats$average.within, stats$average.between, 
          stats$avg.silwidth, stats$dunn2)
dbsummary <- rbind(dbsummary, temp)


fviz_cluster(dbcluster, features,geom = "point", stand = FALSE, 
             choose.vars = c("V2", "V3"),
             pointsize = 1.5, labelsize = 12, main = "DBSCAN Clusters",
             shape = 19, outlier.shape = 4,show.clust.cent = F,
             xlab = "PCA Component 1 (17.0%)",
             ylab = "PCA Component 2 (11.5%)",
             ggtheme = theme_bw(),legend.title = "Clusters")+
  theme(plot.title = element_text(hjust = 0.5))

"PCA Component 3: 9.9%"

plot_ly(x =features$V2,y = features$V3,
        type="scatter", mode="markers", color=factor(dbcluster_noiseadj))

plot_ly(x =features$V2,y = features$V3,  z=features$V4, 
        type="scatter3d", mode="markers", color=factor(dbcluster$cluster))



sildb <- silhouette(dbcluster$cluster, d)
fviz_silhouette(sildb)

#########

set.seed(111)
kvals <- c(2,3,4,5)
ksummary <- data.frame()

for (k in kvals){
  kcluster <- fpc::kmeans(features, k)
  
  stats <- cluster.stats(d, kcluster$cluster)
  
  #stats <- cluster.stats(d,  dbcluster$cluster)
  
  temp <- c(k, stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, stats$noisen,
            stats$within.cluster.ss,stats$average.within, stats$average.between, 
            stats$avg.silwidth, stats$dunn2, kcluster$tot.withinss,  kcluster$betweenss)
  ksummary <- rbind(ksummary, temp)

}
colnames(ksummary) <- c("k",
                         "n_clusters","max_cl_size","min_cl_size",'Noise',"SSE","avg_within","avg_btn",
                         "Sil","Dunn2", "kcl_withinss", "kclbetweenss")

write.csv(ksummary, "../../Outputs/Clustering/r_kmeans_summary_seed111.csv", row.names = F)



kcluster <- fpc::kmeans(features, 2)

fviz_cluster(kcluster, features,geom = "point", stand = FALSE, 
             choose.vars = c("V2", "V3"),
             pointsize = 1.5, labelsize = 12, main = "K-Means Clusters",
             xlab = "PCA Component 1 (17.0%)",
             ylab = "PCA Component 2 (11.5%)",
             shape = 19, outlier.shape = 4,show.clust.cent = F,
             ggtheme = theme_bw(),legend.title = "Clusters")+
  theme(plot.title = element_text(hjust = 0.5))

plot_ly(x =features$V2,y = features$V3,  z=features$V4, 
        type="scatter3d", mode="markers", color = kcluster$cluster)

"PCA Component 3: 9.9%"



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
