
library(factoextra)
library(cluster)
library(fpc)
library(NbClust)
library(ggplot2)
library(plotly)


features <-read.csv("../../Outputs/Features/cluster_inputs/features_z_pca3select.csv", 
                    header = FALSE)


d <- dist(features, method = "euclidean") # distance matrix

#######

get_clust_tendency(features,500)
