#install packages if not installed
list.of.packages <- c("dplyr", "DescTools", "plyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


# load packages
library(dplyr)
library(DescTools)
require(plyr)

titanic_data <- read.csv("http://ds4100.weebly.com/uploads/8/6/5/9/8659576/titanic_data.csv", header = T, sep = ',', na.strings = "")


titanic_data$Age[is.na(titanic_data$Age)] <- mean(titanic_data$Age,na.rm=T)
# table(titanic_data$Embarked)
titanic_data$Embarked[is.na(titanic_data$Embarked)] <- DescTools::Mode(titanic_data$Embarked)

# using the first letter to map cabin to number and NA to 0
# we got the idea from here https://towardsdatascience.com/predicting-the-survival-of-titanic-passengers-30870ccc7e8
titanic_data$cabinNew <- substr(titanic_data$Cabin, 0, 1)
# map from here https://stackoverflow.com/questions/20565949/replace-values-in-data-frame-with-other-values-according-to-a-rule
titanic_data$CabinNewVal <- plyr::mapvalues(titanic_data$cabinNew, 
                               from=c("A", "B", "C", "D", "E", "F", "G", "T", NA), 
                               to=as.numeric(c(1,2,3,4,5,6,7,8,0)))
titanic_data$CabinNewVal <- as.numeric(titanic_data$CabinNewVal)
#class(titanic_data$CabinNewVal)
# sapply(titanic_data,function(x) sum(is.na(x)))
titanic_data_clean <- titanic_data %>%
                        select(-c(PassengerId, Name, Ticket, Cabin, cabinNew))

# get indexes for train https://ragrawal.wordpress.com/2012/01/14/dividing-data-into-training-and-testing-dataset-in-r/
indexes <- sample(1:nrow(titanic_data_clean), size = 0.7 * nrow(titanic_data_clean))
train <- titanic_data_clean[indexes,]
test <- titanic_data_clean[-indexes,]

# class(train$CabinNewVal)
class(unique(train$Embarked))
model_train <- glm(Survived ~ ., family=binomial, data = train)
summary(model_train)
#model_train$coefficients
?predict
#https://stat.ethz.ch/R-manual/R-devel/library/stats/html/predict.lm.html
prediction <- predict(model_train, newdata = test %>% select(-Survived), type = 'response')
length(prediction)
prediction <- ifelse(prediction > .5, 1, 0)
table(prediction)
table(test$Survived)
library(caret)
class(prediction)
class(test$Survived)
test$Survived <- as.factor(test$Survived)
prediction <- as.factor(prediction)
matrix_pred <- caret::confusionMatrix(data = prediction, test$Survived)
matrix_pred$table[1]
matrix_pred$table[2]
# false negatives (Type 2 Error) (someone classified as died when they actually survived).
1-matrix_pred$byClass[2]
# false positive (Type 1 Error) (someone classified as survived when they actually died). 
1-matrix_pred$byClass[1]
# https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values