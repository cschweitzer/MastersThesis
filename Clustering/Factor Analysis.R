#install.packages("FactoMineR")
library(FactoMineR)
library(factoextra)
library(stats)

#library(dplyr)


features <-read.csv("../../Outputs/Features/cluster_inputs/features_cont_std.csv", row.names = 1)

catfeat <- read.csv("../../Outputs/Features/cluster_inputs/features_cat_cat.csv", row.names = 1)
contfeat_z <- read.csv("../../Outputs/Features/cluster_inputs/features_cont_std.csv", row.names = 1)
contfeat <- read.csv("../../Outputs/Features/cluster_inputs/features_cont.csv", row.names = 1)

FAMDres <- FAMD(features, ncp = 10)
MCAres <- MCA(catfeat)
PCAres1 <- PCA(contfeat_z, scale.unit = F)
PCAres2 <- PCA(contfeat_z)


loadings <- PCAres1$var
loadings$coord$
  

summary(PCAres1)

fviz_pca(PCAres1,geom= 'point', label = 'None')
fviz_pca_ind(PCAres1 )
fviz_pca_var(PCAres1)
