data(sleep)
install.packages("datasets")
require(datasets)
data(mtcars)
sleep
mtcars
melt(sleep,)
?melt
install.packages("reshape2")
library(reshape)
?melt
g1 <- sleep$extra[1:10]
g2 <- sleep$extra[11:20]
g1
x <- cbind(g1,g2)
x
data <- cbind(1:nrow(x), x)
data
dim(data)
names(data)[1] <- "Patient"

data <- dcast(data = sleep, formula= ID~group, fun.aggregate = sum, value.var = "extra")
library(reshape2)
data$diff <- abs(data$`1`-data$`2`)
?abs
difference <- data$`2`-data$`1`
mn <- mean(difference)
s <- sd(difference)
n <- 10
mn + c(-1,1) *qt(.975, n-1) * s / sqrt(n)
t.test(difference)$conf.int
install.packages("kernlab")
library(kernlab)
data(spam)
set.seed(3435)
trainIndicator <- rbinom(4601, size = 1, prob = .5)
?rbinom
trainSpam <- spam[trainIndicator == 1, ]
testSpam <- spam[trainIndicator == 0, ]

head(trainSpam)
length(is.na(trainSpam))
table(trainSpam$type)
plot(trainSpam$capitalAve ~ trainSpam$type)
plot(log10(trainSpam$capitalAve + 1) ~ trainSpam$type)
plot(log10(trainSpam[,1:6] + 1)
hCluster <- hclust(dist(t(trainSpam[,1:57])))
plot(hCluster)
names(trainSpam)
head(t(trainSpam[,1:58]))
hCLusterUpated <- hclust(dist(t(log10(trainSpam[,1:55] + 1))))
plot(hCLusterUpated)

lapply(trainSpam, class)
trainSpam$numType <- as.numeric(trainSpam$type) - 1
head(trainSpam$numType)
?cv.glm
install.packages("boot")
library(boot)
costFunction <- function(x, y) sum(x != (y > 0.5))
cvError <- rep(NA, 55)
head(trainSpam[,55])
trainSpam[1,]
cvError
reformulate(names(trainSpam)[2], response = "numType")

for (i in 1:55) {
  lmFormula <- reformulate(names(trainSpam)[i], response = "numType")
  glmFit <- glm(lmFormula, family = "binomial", data = trainSpam)
  cvError[i] <- cv.glm(trainSpam, glmFit, costFunction, 2)$delta[2]
}
cvError
names(trainSpam)[which.min(cvError)]

predictionModel <- glm(numType ~ charDollar, family = "binomial", data = trainSpam)
plot(predictionModel)
predictionTest <- predict(predictionModel, testSpam)
plot(predictionTest)
predictedSpam <- rep("nonspam", dim(testSpam)[1])
predictedSpam[predictionModel$fitted > 0.5] <- "spam"
head(predictedSpam$)
predictionModel$fitted

table(predictedSpam, testSpam$type)

install.packages("rmarkdown")
