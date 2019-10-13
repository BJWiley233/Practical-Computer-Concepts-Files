load("~/data/samsungData.rda")
unzip("~/DataScienceSpecialization/04_ExploratoryAnalysis/clusteringExample/clusteringEx_data.zip")
names(samsungData)[1:12]
table(samsungData$activity)
par(mfrow= c(1,2), mar = c(5,4,1,1))
samsungData1 <- transform(samsungData, activity = factor(activity))
?transform
sub1 <- subset(samsungData1, subject == 1)
head(sub1)
summary(samsungData1)
samsungData$subject
table(sub1$activity)
colnames(sub1)
?colnames
par(mfrow= c(1,2), mar = c(5,4,1,1))
plot(sub1[,1], col = sub1$activity, ylab = names(sub1)[1])
plot(sub1[,2], col = sub1$activity, ylab = names(sub1)[1])
legend("bottomright", legend = unique(sub1$activity), col = unique(sub1$activity), pch = 1)
par(mfrow= c(1,1), mar = c(5,4,1,1))
distanceMatrix <- dist(sub1[,c(10:12, maxContrib)])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))
?mar
par(mfrow = c(1,1), mar = c(5,4,1,1))

par(mfrow = c(1, 2))
plot(sub1[, 10], pch = 19, col = sub1$activity, ylab = names(sub1)[10])
plot(sub1[, 11], pch = 19, col = sub1$activity, ylab = names(sub1)[11])

svd1 = svd(scale(sub1[, -c(562, 563)]))
par(mfrow = c(1, 2))
plot(svd1$u[, 1], col = sub1$activity, pch = 19)
plot(svd1$u[, 2], col = sub1$activity, pch = 19)
names(sub1[,562:563])
names(sub1, 562:563)
names(sub1)
svd1$u[1,]
plot(svd1$v[, 2], pch = 19)

maxContrib <- which.max(svd1$v[, 347])
distanceMatrix <- dist(sub1[, c(10:12, maxContrib)])
hclustering <- hclust(distanceMatrix)
myplclust(hclustering, lab.col = unclass(sub1$activity))
kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)
kmeansObj$cluster
