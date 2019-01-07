library(factoextra)
library(cluster)
library(fpc)
library(NbClust)

citation("factoextra")
citation("cluster")
citation("fpc")
citation("NbClust")


features <-read.csv("../../Outputs/Features/cluster_inputs/features_z_pca5.csv", row.names = 1,
                      header = FALSE)


d <- dist(features, method = "euclidean") # distance matrix

##########################3

hcluster <- eclust(d, "hclust", k = 5, method = "ward.D", graph = FALSE)

fviz_dend(hcluster, rect = TRUE, show_labels = FALSE) 
silh <- silhouette(hcluster$cluster, d)
fviz_silhouette(silh)

hcop <- cophenetic(hcluster)

cor(d, hcop)

hc_stats <- cluster.stats(d, hcluster$cluster)
hc_stats

################DBCAN
eps = c(2,3,4,5,8,10)
minpts = c(2,3,4,5,8,10)

dbsummary <- data.frame()
  
for (i in eps){
  for (j in minpts){
    dbcluster <- dbscan(features, i, j, method = "raw")
    
    stats <- cluster.stats(d,  dbcluster$cluster)
    temp <- c(i,j, stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, 
              stats$within.cluster.ss,stats$average.within, stats$average.between, 
              stats$avg.silwidth, stats$dunn2)
    dbsummary <- rbind(dbsummary, temp)
    }
}

colnames(dbsummary) <- c("eps","minpts",
                         "n_clusters","max_cl_size","min_cl_size","SSE","avg_within","avg_btn",
                         "Sil","Dunn2")
write.csv(dbsummary,"../../Outputs/Clustering/db_clustering_summary_pca5.csv", row.names= F)



dbcluster <- dbscan(features, 2, 4, method = "raw")

stats <- cluster.stats(d,  dbcluster$cluster)
temp <- c(1,1,
          stats$cluster.number, max(stats$cluster.size), stats$min.cluster.size, 
          stats$within.cluster.ss,stats$average.within, stats$average.between, 
          stats$avg.silwidth, stats$dunn2)
dbsummary <- rbind(dbsummary, temp)


fviz_cluster(dbcluster, features,geom = "point")

sildb <- silhouette(dbcluster$cluster, d)
fviz_silhouette(sildb)

#########

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
clusplot(features, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
plotcluster(features, fit$cluster)


####################3

ggplot(dbsummary, aes(x=dbsummary$eps, y=c(), color=highest_ev_chosen)) +
  geom_line(aes(y = dbsummary$SSE, col = "SSE")) + 
  #geom_line(aes(y = y2, col = "y2"))
  facet_grid(.~dbsummary$minpts)