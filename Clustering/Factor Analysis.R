#install.packages("FactoMineR")
library(FactoMineR)

library(dplyr)


features <-read.csv("../../Outputs/features_combined.csv", row.names = 1)

catfeat <- read.csv("../../Outputs/features_cat_cat.csv", row.names = 1)
contfeat <- read.csv("../../Outputs/features_cont_std.csv", row.names = 1)

FAMDres <- FAMD(features)
MCAres <- MCA(catfeat)
PCAres <- PCA(contfeat)

summary(MCAres)

