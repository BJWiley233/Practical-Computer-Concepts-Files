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
boxplot.stats(glass_data$calcium)

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
# replace(x, list, values)

fillOUtliersNA <- function(dataframe) {
        newdata <- dataframe %>%
                select(-c("barium", "glass.type")) %>%
                map_if(is.numeric, ~ replace(.x, .x %in% boxplot.stats(.x)$out, NA)) %>%
                bind_cols() 
        cbind(newdata, barium = dataframe[, "barium"], glass.type = dataframe[, ncol(dataframe)])
}
glassOutliers2NA <- fillOUtliersNA(glass_data)
sapply(glassOutliers2NA, function(x) sum(is.na(x)))

datamm <- rnorm(10000)
barplot(datamm, width = 200)
densityplot(datamm)
?barplot
ggplot(datamm) +
    geom_bar(width = 300)

function (x) (x-min(x, na.rm = T))/(max(x, na.rm = T)-min(x, na.rm = T)
# 5
glassOutliers2NA[, 2:3] <- sapply(glassOutliers2NA[, 2:3], function (x) (x-min(x, na.rm = T))/(max(x, na.rm = T)-min(x, na.rm = T)))
glassOutliers2NA[, 4:10] <- apply(glassOutliers2NA[, 4:10], 2, scale)

# 6
indexes <- sample(1:nrow(glassOutliers2NA), size = 0.5 * nrow(glassOutliers2NA))
train <- glassOutliers2NA[indexes,]
test <- glassOutliers2NA[-indexes,]

# 7
library(caret)
k = 11
knnAlg <- function(train, test, k, ties = FALSE) {
        #distances_to_train <- vector()
        # distances_to_train <- append(distances_to_train, 1)
        final_guesses <- vector()
        for (i in 1:nrow(test)) {
                dist_rowTest2EachTrainRow <- vector()
                for (j in 1:nrow(train)) {
                        eucDist <- dist(rbind(train[j, c(2:(ncol(train)-1))], test[i, c(2:(ncol(train)-1))]))
                        dist_rowTest2EachTrainRow <- append(dist_rowTest2EachTrainRow, eucDist)
                        }
                        distances_glass <- as.data.frame(cbind(glass.type = train$glass.type, dist_rowTest2EachTrainRow))
                        guesses <- distances_glass %>%
                                        arrange(dist_rowTest2EachTrainRow) %>%
                                        select(glass.type) %>%
                                        head(k)
                        
                        final.guess <- as.integer(names(which.max(table(guesses))))
                        final_guesses <- append(final_guesses, final.guess)
                        # test$glassGuess[i] <- final.guess
        }
        finalDf <- cbind(test, glass_guess = final_guesses)
        finalDf$glass_guess <- as.factor(finalDf$glass_guess)
        finalDf$glass.type <- as.factor(finalDf$glass.type)
        #union_levels <- as.numeric(union(as.factor(finalDf$glass_guess), as.factor(finalDf$glass.type)))
        
        #levels(finalDf$glass_guess) <- c(levels(finalDf$glass_guess), as.factor(union_levels))
        #finalDf$glass.type
        #levels(finalDf$glass.type) <- c(levels(finalDf$glass.type), as.factor(union_levels))
        #confusionMatrix(finalDf$glass_guess, finalDf$glass.type)
        table(finalDf$glass_guess, finalDf$glass.type)
        cf <- confusionMatrix(finalDf$glass_guess, finalDf$glass.type)
        #cat("K =", k, "\n")
        #print(cf$table)
        #cat("Accuracy =", cf$overall['Accuracy'], "\n")
        #cat("Error =", 1 - cf$overall['Accuracy'], "\n")
        error <- 1 - cf$overall['Accuracy']
        return(error)
}
knnAlg(train = train, test = test, k = 11)
knnAlg(train = train, test = test, k = 1)
ks <- seq(1, 11, 1)
accuracies <- lapply(ks, knnAlg, train = train, test = test, ties = F)
plot(ks, accuracies, xlab = "k", ylab = "error")
lines(smooth.spline(ks, accuracies, spar = 0.4))

# 8
library(class)
library(tidyr)

missingDataOutliers <- glassOutliers2NA %>%
        filter_all(any_vars(is.na(.)))

newData <- drop_na(glassOutliers2NA)

indexesNoNA <- sample(1:nrow(newData), size = 0.5 * nrow(newData))
trainNoNA <- newData[indexesNoNA,]
testNoNA <- newData[-indexesNoNA,]

trainNoNA_ID <- trainNoNA[, -1]
testNoNA_ID <- testNoNA[, -1]
glass_train_category <- trainNoNA_ID$glass.type
glass_test_category <- as.factor(testNoNA_ID$glass.type)
pred <- class::knn(train = trainNoNA_ID, 
                   test = testNoNA_ID, 
                   cl = glass_train_category, 
                   k = 11, use.all = F)


union_levels <- as.numeric(union(levels(pred), levels(glass_test_category)))
levels(pred) <- union_levels
levels(glass_test_category) <- c(levels(glass_test_category), 5)
cm <- confusionMatrix(data = pred, reference = glass_test_category)
1- cm$overall['Accuracy']
