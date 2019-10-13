library(jsonlite)
library(rjson)
fromJS
mydata <- jsonlite::fromJSON("C:/Users/bjwil/Downloads/image_tsne_projections.json", flatten=TRUE)
plot(x, y, )
sam <- sample(1:nrow(mydata), 25)
par(mfrow=c(1,1))
plot(mydata$x[sam], mydata$y[sam], pch = 19)

X <- cbind(mydata$x[sam], mydata$y[sam])
install.packages("apcluster")
library(apcluster)
apcluster(negDistMat(X, r=2))
apcluster(negDistMat(r=2), X)
test_clust <- apcluster(negDistMat(r=2), X, details=T)
test_clust@clusters
plot(test_clust, X)
