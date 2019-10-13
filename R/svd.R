set.seed(1234)
par(mar = c(2,2,2,2))
x <- rnorm(12, mean = rep(1:3, each = 4), sd = .2)
y <- rnorm(12, mean = rep(c(1,2,1), each = 4), sd = .2)

plot(x, y, col = "green", pch = 19)
text(x +.05, y + .05, labels = as.character(1:12))
dataFrame <- data.frame(x=x,y=y)
distXY <- dist(dataFrame)
hClustering <- hclust(distXY)
myplclust(hClustering, lab = rep(1:3, each = 4), lab.col = rep(1:3, each = 4))
set.seed(143)
dataMatrix <- as.matrix(dataFrame)[sample(1:12), ]
heatmap(dataMatrix)

kmeansObj <- kmeans(dataFrame, centers = 3)
names(kmeansObj)
kmeansObj$cluster
par(mar = rep(0.2, 4))
plot(x,y, col = kmeansObj$cluster, cex = 1)
points(kmeansObj$centers, col = 1:3, pch = 3, cex = 2)
?plot()
?cex
dataMatrix <- as.matrix(dataFrame)[sample(1:12),]
kmeansObj2 <- kmeans(dataMatrix, centers = 3)
par(mfrow = c(1,2), mar = c(2,4,.1,.1))
image(t(dataMatrix)[, 12:1], yaxt="n")
image(t(dataMatrix)[, order(kmeansObj$cluster)], yaxt="n")
