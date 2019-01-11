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




################DBCAN
eps = c(2,3,4,5,8,10)
minpts = c(2,3,4,5,8,10)

dbsummary <- data.frame()
  
for (i in eps){
  for (j in minpts){
    dbcluster <- fpc::dbscan(features, i, j, method = "raw")
    
    dbcluster_noiseadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1)
    
    stats <- cluster.stats(d, dbcluster_noiseadj, noisecluster = T)
    
    #stats <- cluster.stats(d,  dbcluster$cluster)
    
    temp <- c(i,j, stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, 
              stats$within.cluster.ss,stats$average.within, stats$average.between, 
              stats$avg.silwidth, stats$dunn2)
    dbsummary <- rbind(dbsummary, temp)
    }
}

colnames(dbsummary) <- c("eps","minpts",
                         "n_clusters","max_cl_size","min_cl_size","SSE","avg_within","avg_btn",
                         "Sil","Dunn2")
write.csv(dbsummary,"../../Outputs/Clustering/r_db_clustering_summary_pca5_noiseadj.csv", row.names= F)



dbcluster <- fpc::dbscan(features, 2, 4, method = "raw")

db_stats <- cluster.stats(d,  dbcluster$cluster, noisecluster = T)
db_stats

dbcluster_noiseadj <- replace(dbcluster$cluster, dbcluster$cluster==0, max(dbcluster$cluster)+1)
db_stats2 <- cluster.stats(d, dbcluster_noiseadj, noisecluster = T)
db_stats2

write.csv(dbcluster$cluster, "../../Outputs/Clustering/cluster_indices_dbscan_3_4.csv", row.names = F)

temp <- c(2,4,
          stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, 
          stats$within.cluster.ss,stats$average.within, stats$average.between, 
          stats$avg.silwidth, stats$dunn2)
dbsummary <- rbind(dbsummary, temp)


fviz_cluster(dbcluster, features,geom = "point", stand = FALSE, 
             choose.vars = c("V2", "V3"))


plot_ly(x =features$V2,y = features$V3,  z=features$V4, 
        type="scatter3d", mode="markers", color=factor(dbcluster$cluster))


sildb <- silhouette(dbcluster$cluster, d)
fviz_silhouette(sildb)

#########


library(dbscan)

kNNdistplot(features, k=4)
abline(h=0.4, col="red")

db_cluster_alt = dbscan::dbscan(features, 3, 4)

hullplot(features, db_cluster_alt$cluster)
db_cluster_alt$cluster






# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
clusplot(features, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
plotcluster(features, fit$cluster)


##########

kcluster <- kmeans(features, 5)
fviz_cluster(kcluster, features, stand = F, repel = T)

####################3




###%%%

ggplot(dbsummary, aes(x=dbsummary$eps, y=c(), color=highest_ev_chosen)) +
  geom_line(aes(y = dbsummary$SSE, col = "SSE")) + 
  #geom_line(aes(y = y2, col = "y2"))
  facet_grid(.~dbsummary$minpts)