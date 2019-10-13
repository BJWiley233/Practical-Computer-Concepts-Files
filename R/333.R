# K-Means Cluster Analysis

# load data into R
# you can download data from Google Analytics API or download the sample dataset
# source('ga-connection.R')

# download and preview the sample dataset
download.file(url="https://raw.githubusercontent.com/michalbrys/R/master/users-segmentation/sample-users.csv",
              "sample-users.csv",
              method="curl")
gadata <- data  ## read.csv(file="sample-users.csv", header=T, row.names = 1)
head(gadata)

# clustering users into 3 groups
fit <- kmeans(gadata, 3)

# get the cluster means 
aggregate(gadata,by=list(fit$cluster),FUN=mean)


y <- replicate(10000, {
        mm <- sample(0:1, size = 20, replace = TRUE)
        (mean(mm)-.5)/sqrt(.5^2/20)
        
        
})
par(mfrow = c(1,1))
dens = density(y)
plot(dens$x,length(data)*dens$y,type="l",xlab="Value",ylab="Count estimate")
curve(dnorm, col = 2, add = TRUE)

x <- rnorm(1000)
hist(y, freq = FALSE, col = "grey")
lines(density(y, adjust=2), lwd = 4)
plot(density(y), lwd = 4)
curve(dnorm, col=alpha("red", 0.5), add = TRUE, lwd = 4)


?rep
# append and preview the cluster's assignment
clustered_users <- data.frame(gadata, fit$cluster)
head(clustered_users)

# visualize the results in 3D chart

sqrt(2.92)
f <- list(
        ##family = "Courier New, monospace",
        size = 14,
        color = "black",
        face = "bold"
)
x <- list(
        title = "Day # Leads Baked",
        titlefont = f
)
y <- list(
        title = "L2O %",
        titlefont = f,
        tickformat = ".1%",
        ticklen = 1
)
#install.packages("plotly")
library(plotly)
m <- plot_ly()

for(d in 2:31){
        m <- add_trace(m, clustered_users, x=clustered_users[,1], y=clustered_users[,d], name = paste(names(gadata)[d+1]), type = "scatter", mode = "markers",
                       color=factor(clustered_users$fit.cluster), evaluate = TRUE)
}
m <- m %>% layout(title = "L2O Baking % Whoop Whoop!!", titlefont=list(face = "bold-italic"), xaxis = x, yaxis = y, margin = m)
m
plot_ly(clustered_users, 
        x = clustered_users$Day, y = clustered_users$X2017.09.07,
        type = "scatter", 
        mode = "markers", 
        color=factor(clustered_users$fit.cluster)
)

samples = 100
Z = rlnorm(samples, mu, sigma)
X = rnorm(samples, Z, delta)

u = 1110
sd = 75
n= 144
se = 75/sqrt(144)
qnorm(.10, 1110,se)

set.seed(12345)
par(mar = rep(0.2, 4))
dataMatrix <- matrix(rnorm(400), nrow = 40)
image(1:10, 1:40, t(dataMatrix)[, nrow(dataMatrix):1])

set.seed(678910)
for (i in 1:40) {
        coinFlip <- rbinom(1,size = 1, prob = .5)
        if (coinFlip) {
              dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,3), each = 5)  
        }
}

par(mar = c(5,5,5,5))
image(1:10, 1:40, t(dataMatrix)[,nrow(dataMatrix):1])

heatmap(dataMatrix)
hh <- clust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order, ]
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(rowMeans(dataMatrixOrdered), 40:1 ,xlab = "Rowmean", ylab = "Row", pch = 19)
plot(colMeans(dataMatrixOrdered),xlab = "Column", ylab = "Colmean", pch = 19)


svd1 <- svd(scale(dataMatrixOrdered))
par(mfrow=c(1,3))
image(t(dataMatrixOrdered)[,nrow(dataMatrixOrdered):1])
plot(svd1$u[,1],40:1, , xlab = "ROw", ylab = "First left singular vector", pch = 19)
?svd
plot(svd1$v[,1], xlab = "COlumn", ylab = "First right singular vector", pch = 19)

par(mfrow = c(1,1))
plot(svd1$d, xlab = "Column", ylab = "Singular value", pch = 19)
plot(svd1$d^2/sum(svd1$d^2), xlab = "Column", ylab = "Prop. of variance explained", pch=19)

pca1 <- prcomp(dataMatrixOrdered, scale = TRUE)
plot(pca1$rotation[,1], svd1$v[,1], pch = 19, xlab = "principal component 1", ylab = "right singular vector 1")
abline(0,1)

contstantMatrix <- dataMatrixOrdered*0
for (i in 1:dim(dataMatrixOrdered)[1]){constantMatrix[i,] <-
        rep(c(0,1), each = 5)}
svd1 <- svd(constantMatrix)
svd1$d
par(mfrow=c(1,3))
image(t(constantMatrix)[,nrow(contstantMatrix):1])
plot(svd1$d, pch = 19)
(svd1$d^2)/sum(svd1$d^2)
1.414214^2

set.seed(678910)
for (i in 1:40) {
        coinFlip1 <- rbinom(1, size = 1, prob = .5)
        
        coinFlip2 <- rbinom(1, size = 1, prob = .5)
        if (coinFlip1) {
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5), each = 5)
        }
        if (coinFlip2) {
                dataMatrix[i,] <- dataMatrix[i,] + rep(c(0,5), 5)
        }
        
}
hh <- hclust(dist(dataMatrix))
dataMatrixOrdered <- dataMatrix[hh$order,]
svd2 <- svd(scale(dataMatrixOrdered))
par(mfrow = c(1,3))
image(t(dataMatrixOrdered)[, nrow(dataMatrixOrdered):1])
plot(svd2$v[,1], pch = 19)
plot(svd2$v[,2], pch = 19)
