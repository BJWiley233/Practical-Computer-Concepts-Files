set.seed(5)
x <- rnorm(200)
y <- 25 - 22*x + 5*x^2 + rnorm(200)

png("layout1.png")
par(mfrow=c(2,2))
par(mar=c(0.5, 4.5, 0.5, 0.5))
boxplot(x, horizontal=TRUE, axes=FALSE)
plot(0, type="n", xlab="", ylab="", axes=FALSE)
par(mar=c(4.5, 4.5, 0.5, 0.5))
plot(x, y)
text(0.5, 85, "par(mfrow)", cex=2)
par(mar=c(4.5, 0.5, 0.5, 0.5))
boxplot(y, axes=FALSE)

for (i in 1:3){
        print(i)
}

####################################################################
library(datasets)
head(iris)
library(ggplot2)
ggplot(iris, aes(Petal.Length, Petal.Width, color = Species)) + geom_point()
set.seed(20)
irisCluster <- kmeans(iris[, 3:4], 3, nstart = 20)

table(irisCluster$cluster, iris$Species)



irisCluster$cluster <- as.factor(irisCluster$cluster)
ggplot(iris, aes(Petal.Length, Petal.Width, color = irisCluster$cluster)) + geom_point()











