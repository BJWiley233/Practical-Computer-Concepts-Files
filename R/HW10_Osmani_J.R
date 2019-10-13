#install packages if not installed
list.of.packages <- c("ggplot2", "gridExtra", "dplyr", "purrr", "rowr", "grDevices", "class", "ramify")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


# 1
glass_data <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/glass/glass.data",
                       sep = ",",
                       header = F,
                       stringsAsFactors = F)

header_names <- c("ID", "refactive.index", "sodium", "magnesium", "aluminum",
                  "silicon", "potassium", "calcium", "barium", "iron", "glass.type")

names(glass_data) <- header_names

# 2
library(ggplot2)
ggplot(stack(glass_data[,-1]), aes(x = ind, y = values)) +
        geom_boxplot() 

ggplot(stack(glass_data[,-c(1,6)]), aes(x = ind, y = values)) +
        geom_boxplot() + 
        ggtitle(paste0(names(glass_data)[-c(1,6)], collapse = ", ")) +
        theme(plot.title = element_text(size = 9, vjust = 2, face = "bold"))
calcium <- boxplot.stats(glass_data$calcium)
calcium$out
boxplot(glass_data[,6], main = names(glass_data[6]))

# https://stackoverflow.com/questions/31993704/storing-ggplot-objects-in-a-list-from-within-loop-in-r
plot_data_column <- function (data, column) {
        ggplot2::ggplot(data = data, aes_string(x = column)) +
                geom_density() + xlab(column) + ggtitle(column)
        
}
myplots <- lapply(names(glass_data),
                  plot_data_column, 
                  data = glass_data)
n <- length(myplots)
nCol <- floor(sqrt(n))
library(gridExtra)
grid.arrange(grobs = myplots, ncol = nCol)

# 3 it is non-parametric as it is a method to predict classification

# 4 https://stackoverflow.com/questions/48963595/how-to-get-outliers-for-all-the-columns-in-a-dataframe-in-r
library(dplyr)
library(purrr)
# map_if function .f If a formula, e.g. ~ .x + 2, it is converted to a function.
         # There are three ways to refer to the arguments:
                 # For a single argument function, use .
                 # For a two argument function, use .x and .y
                 # For more arguments, use ..1, ..2, ..3 etc
 #replace(x, list, values)
 
fillOUtliersNA <- function(dataframe) {
         newdata <- dataframe %>%
                 select(-c("barium", "glass.type")) %>%
                 map_if(is.numeric, ~ replace(.x, .x %in% boxplot.stats(.x)$out, NA)) %>%
                 bind_cols()
         cbind(newdata, barium = dataframe[, "barium"], glass.type = dataframe[, ncol(dataframe)])
 }
glassOutliers2NA <- fillOUtliersNA(glass_data)
sapply(glassOutliers2NA, function(x) sum(is.na(x)))
missingDataOutliers <- glassOutliers2NA %>%
  filter_all(any_vars(is.na(.)))

library(tidyr)
newData <- drop_na(glassOutliers2NA)
newData <- newData[, -1]

# 5
min_max <- function (x) (x-min(x, na.rm = T))/(max(x, na.rm = T)-min(x, na.rm = T))
newData[, 1:2] <- sapply(newData[, 1:2], min_max)
newData[, 3:9] <- apply(newData[, 3:9], 2, scale)
# glassOutliers2NA[, 2:3] <- sapply(glassOutliers2NA[, 2:3], min_max)
# glassOutliers2NA[, 4:10] <- apply(glassOutliers2NA[, 4:10], 2, scale)

# 6
indexes <- sample(1:nrow(newData), size = 0.5 * nrow(newData))
train <- newData[indexes,]
test <- newData[-indexes,]

# 7
library(caret)
k = 11

elements <- read.csv("elements.csv")
#test <- elements
train_index_column = 10
knnAlg_Fix <- function(train, test, k, train_index_column) {
    #distances_to_train <- vector()
    # distances_to_train <- append(distances_to_train, 1)
    if (names(test) != names(train)[-train_index_column]) {
        names(test) = names(train)[-train_index_column]
    }
    final_guesses <- vector()
    for (i in 1:nrow(test)) {
        dist_rowTest2EachTrainRow <- vector()
        for (j in 1:nrow(train)) {
            eucDist <- dist(rbind(train[j, c(1:(ncol(train)-1))], test[i, c(1:(ncol(train)-1))]))
            dist_rowTest2EachTrainRow <- append(dist_rowTest2EachTrainRow, eucDist)
        }
        distances_glass <- as.data.frame(cbind(glass.type = train$glass.type, dist_rowTest2EachTrainRow))
        guesses <- distances_glass %>%
            arrange(dist_rowTest2EachTrainRow) %>%
            select(glass.type) %>%
            head(k)
        
        final.guess <- as.integer(names(which.max(table(guesses)))) #argmax
        final_guesses <- append(final_guesses, final.guess)
        # test$glassGuess[i] <- final.guess
    }
    finalDf <- cbind(test, glass_guess = final_guesses)
    finalDf$glass_guess <- as.factor(finalDf$glass_guess)
    ######## finalDf$glass.type <- as.factor(finalDf$glass.type)
    #union_levels <- as.numeric(union(as.factor(finalDf$glass_guess), as.factor(finalDf$glass.type)))
    
    #levels(finalDf$glass_guess) <- c(levels(finalDf$glass_guess), as.factor(union_levels))
    #finalDf$glass.type
    #levels(finalDf$glass.type) <- c(levels(finalDf$glass.type), as.factor(union_levels))
    #confusionMatrix(finalDf$glass_guess, finalDf$glass.type)
    ######## table(finalDf$glass_guess, finalDf$glass.type)
    ######## cf <- confusionMatrix(finalDf$glass_guess, finalDf$glass.type)
    cat("K =", k, "\n")
    ######## print(cf$table)
    ######## cat("Accuracy =", cf$overall['Accuracy'], "\n")
    ######## cat("Error =", 1 - cf$overall['Accuracy'], "\n")
    ######## error <- 1 - cf$overall['Accuracy']
    #cat(finalDf$glass_guess)
    return(finalDf$glass_guess)
}
train_index_column = 10
k = 11
knnAlg_Fix(train = train, test = elements, k = k, train_index_column)



# 8 not working
library(class)
library(tidyr)
library(caret)

#missingDataOutliers <- glassOutliers2NA %>%
#        filter_all(any_vars(is.na(.)))

#newData <- drop_na(glassOutliers2NA)

#indexes_blah <- sample(1:nrow(newData), size = 0.5 * nrow(newData))
#train_blah <- newData[indexes_blah,]
#test_blah <- newData[-indexes_blah,]

glass_train_category <- factor(train$glass.type)
train_remove_glass_type <- train[, -10]
elements <- read.csv("elements.csv")
names(elements) <- names(train)[-10]
# the Class packge knn function does not work when you test set has no
pred_elem <- class::knn(train = train_remove_glass_type, 
                   test = elements, 
                   cl = glass_train_category, 
                   k = 11, use.all = F)


#9 

guesses <- knnAlg_Fix(train = train, test = test, k = k, train_index_column)
test$glass.type <- as.factor(test$glass.type)

finalDf <- data.frame(real = test$glass.type, guess = guesses)
finalDf$guess <- as.factor(finalDf$guess)
finalDf$real <- as.factor(finalDf$real)
#table(finalDf$guess, finalDf$real)
cf <- confusionMatrix(finalDf$guess, finalDf$real)
error <- 1- cf$overall['Accuracy']

cat("our function error k=11 " , 1- cf$overall['Accuracy'])

# Class function for test
pred <- class::knn(train = train_remove_glass_type, 
                        test = test[, -10], 
                        cl = glass_train_category, 
                        k = 11, use.all = F)
# can't run this
union_levels <- as.numeric(union(levels(pred), levels(glass_test_category)))
levels(pred) <- union_levels
levels(glass_test_category) <- c(levels(glass_test_category), 5)
cm <- confusionMatrix(data = pred, reference = glass_test_category)
cat("error Class function test k = 11" , 1- cm$overall['Accuracy'])

cat("\nWe WIN!!!!! but close")


#  10
error_array <- vector()
for (i in seq(1, 11, 1)) {
    guesses <- knnAlg_Fix(train = train, test = test, k = i, train_index_column)
    test$glass.type <- as.factor(test$glass.type)
    
    finalDf <- data.frame(real = test$glass.type, guess = guesses)
    finalDf$guess <- as.factor(finalDf$guess)
    finalDf$real <- as.factor(finalDf$real)
    #table(finalDf$guess, finalDf$real)
    cf <- confusionMatrix(finalDf$guess, finalDf$real)
    error <- 1- cf$overall['Accuracy']
    
    cat("our function error k = ", i , " is ", 1- cf$overall['Accuracy'], "\n")
    error_array <- append(error_array, error)
}

#11.	(4 pts) Create a plot of k (x-axis) versus error rate (percentage of incorrect classifications).
k_error_df <- data.frame(k = seq(1, 11, 1), error_ = error_array)
plot(k_error_df$k, k_error_df$error_)
lines(smooth.spline(seq(1, 11, 1), error_array, spar = 0.4))

#12.	(4 pts) Produce a cross-table confusion matrix showing the accuracy of the classification a k of your choice.
guesses <- knnAlg_Fix(train = train, test = test, k = 3, train_index_column)
test$glass.type <- as.factor(test$glass.type)

finalDf <- data.frame(real = test$glass.type, guess = guesses)
finalDf$guess <- as.factor(finalDf$guess)
finalDf$real <- as.factor(finalDf$real)
#table(finalDf$guess, finalDf$real)
cf <- confusionMatrix(finalDf$guess, finalDf$real)
error <- 1- cf$overall['Accuracy']
print(cf)

    




