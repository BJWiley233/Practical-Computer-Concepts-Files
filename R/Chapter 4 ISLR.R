credit <- read.csv("Credit.csv")
library(ISLR)
library(MASS)
data(Default)
Default
glm.fit=glm(default ~ balance, data=Default, family=binomial)
summary(glm.fit)
DefaultDF <- Default

DefaultDF$studentDummy <- ifelse(DefaultDF$student=="Yes", 1, 0)

student.fit=glm(default ~ balance + income + studentDummy, data=DefaultDF, family=binomial)
summary(student.fit)

data("Smarket")
Smarket


default.lda <- lda(default ~ balance + student, data = Default)
?lda
predict.lda <- predict(default.lda, data = Default, type = "response", thre)
predict.lda_.2 <- as.factor(ifelse(predict.lda$posterior[,2] > .2, "Yes", "No"))
sum(predict.lda$posterior[,2]>=.2)
confusionMatrix(predict.lda$class, Default$default)
confusionMatrix(predict.lda_.2, Default$default)

default.lda$counts
library(caret)
confusionMatrix(default.lda$terms, Default$default)
plot(default.lda)

################################LAB
library(ISLR)
names(Smarket)
dim(Smarket)
cor(Smarket[,-9])
attach(Smarket)
plot(Volume)
glm.fit <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5
               + Volume, data = Smarket, family = binomial)



# glm(as.formula(paste(colnames(Smarket)[9], "~",
#                      paste(colnames(Smarket)[c(2:7)], collapse = "+"),
#                      sep = ""
# )),
#     data = Smarket, family = binomial)

summary(glm.fit)
glm.probs <- predict(glm.fit, type = "response")
glm.probs[1:10]
contrasts(Direction)
glm.probs <- ifelse(glm.probs >.5, "Up", "Down")
library(caret)
confusionMatrix(as.factor(glm.probs), Direction)
table(glm.probs, Direction)

train <- (Year<2005)
Smarket.2005 <- Smarket[!train,]
dim(Smarket.2005)
Direction.2005 <- Direction[!train]

glm.fit <- glm(Direction ~ Lag1 + Lag2 + Lag3 + Lag4 + Lag5
               + Volume, data = Smarket, family = binomial, subset = train)
glm.probs <- predict(glm.fit, Smarket.2005, type = "response")
glm.probs <- as.factor(ifelse(glm.probs >.5, "Up", "Down"))

confusionMatrix(as.factor(glm.probs), direction.2005)

glm.fit <- glm(Direction ~ Lag1 + Lag2, data = Smarket, family = binomial, subset = train)
glm.probs <- predict(glm.fit, Smarket.2005, type = "response")
glm.probs <- as.factor(ifelse(glm.probs >.5, "Up", "Down"))

confusionMatrix(as.factor(glm.probs), direction.2005)

predict(glm.fit, data.frame(Lag1=c(1.2,1.5), Lag2=c(1.1, -.8)), type = "response")


#####################3
library(MASS)
data("iris")
iris
X <- iris[,1:4]
y <- iris[,5]
library(class)
pred <- knn(train = X, test = X, cl=y, k = 1)

mean(y != pred)

set.seed(101) # Set Seed so that same sample can be reproduced in future also

# Now Selecting 50% of data as sample from total 'n' rows of the data
sample <- sample.int(n = nrow(data), size = floor(.50*nrow(data)), replace = F)
train <- data[sample, ]
test  <- data[-sample, ]

train_control <- trainControl(method = "cv", number = 5)
model <- caret::train(Species ~ ., data = iris, trControl = train_control, method = "knn",
                      tuneGrid = data.frame(k=c(1)))
model$resample$Accuracy
mean(model$resample$Accuracy)

###LDA
library(MASS)
attach(Smarket)
train <- (Year<2005)
lda.fit <- lda(Direction ~ Lag1+Lag2, data = Smarket, subset=train)
plot(lda.fit) # The plot() function produces plots of the linear
#discriminants, obtained by computing ???0.642 × Lag1??? 0.514 × Lag2 for
#each of the training observations.

lda.predict <- predict(lda.fit, Smarket.2005)
table(lda.predict$class, direction.2005)

#QDA is same calls but with qda()

#KNN
library(class)
?knn
train.X <- cbind(Lag1, Lag2)[train,]
test.X <- cbind(Lag1, Lag2)[!train,]
train.dir <- Direction[train]
set.seed(1)
knn.pred = knn(train.X, test.X, train.dir, 1)
table(knn.pred, Direction.2005)

knn.pred = knn(train.X, test.X, train.dir, 3)
table(knn.pred, Direction.2005)