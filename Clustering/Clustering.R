library(factoextra)
library(cluster)
library(fpc)
library(NbClust)

features <-read.csv("../../Outputs/Features/cluster_inputs/features_z_pca10.csv", row.names = 1,
                    header = FALSE)


d <- dist(features, method = "euclidean") # distance matrix
hcluster <- eclust(d, "hclust", k = 5, method = "ward.D", graph = FALSE)

fviz_dend(hcluster, rect = TRUE, show_labels = FALSE) 
silh <- silhouette(hcluster$cluster, d)
fviz_silhouette(silh)
hc_stats <- cluster.stats(d, hcluster$cluster)




################DBCAN
dbcluster <- dbscan(features, 2, 3, method = "raw")
#dbcluster_d <- dbscan(d, 4, 3, method = 'dist')

fviz_cluster(dbcluster, features,geom = "point")

sildb <- silhouette(dbcluster$cluster, d)
fviz_silhouette(sildb)

db_stats <- cluster.stats(d,  dbcluster$cluster)
# within clusters sum of squares
db_stats #$within.cluster.ss

#########

# Cluster Plot against 1st 2 principal components

# vary parameters for most readable graph
clusplot(features, fit$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)

# Centroid Plot against 1st 2 discriminant functions
plotcluster(features, fit$cluster)