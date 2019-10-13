library(FNN)
library(MASS)
data(Boston)

set.seed(42)
boston_index <- sample(1:nrow(Boston), size = 250)
boston.lm <- lm(medv~lstat, data = Boston)
boston.lm2 <- lm(medv~poly(lstat, 2, raw = T), data = Boston)
summary(boston.lm)
summary(boston.lm2)
x = seq(0, max(Boston$lstat), .01)
predictB2 <- predict(boston.lm2, data.frame(lstat=x))

train <- Boston[boston_index, ]
test <- Boston[-boston_index,]

x_train <- train["lstat"]
y_train <- train["medv"]
x_test <- test["lstat"]
y_test <- test["medv"]

x_train_min <- min(x_train)
x_train_max <- max(x_train)
lstat_grid <- data.frame(lstat=seq(x_train_min, x_train_max, .01))

pred_1 <- knn.reg(train = x_train, test = lstat_grid, y = y_train, k = 1)
pred_10 <- knn.reg(train = x_train, test = lstat_grid, y = y_train, k = 10)
pred_25 <- knn.reg(train = x_train, test = lstat_grid, y = y_train, k = 25)
pred_50 <- knn.reg(train = x_train, test = lstat_grid, y = y_train, k = 50)

length(lstat_grid$lstat)
length(pred_1$pred)

plot(Boston$lstat, Boston$medv)
abline(34.55384, -0.95005, col = "green", lw = 2)
lines(x, predictB2, col = "blue", lw = 2)
lines(lstat_grid$lstat, pred_50$pred, col = "orange", lw = 2)

pred_train <- knn.reg(train = x_train, test = x_train, y = y_train, k = 1)$pred
mean((x_train$lstat-pred_train)^2)
sqrt(mean((y_train$medv-pred_train)^2))

b <- knn.reg(train = x_train, test = x_train, y = y_train, k = 1)
summary(b)
b$residuals

rmse <- function(actual, predicted) {
    sqrt(mean((actual-predicted)^2))
}
rmse(y_train$medv, pred_train)
make_knn_pred <- function(k = 1, training, predicting) {
    pred <- FNN::knn.reg(train = training["lstat"],
                         test = predicting["lstat"],
                         y = training["medv"],
                         k = k)$pred
    actual <- predicting$medv
    rmse(actual = actual, predicted = pred)
}

k = c(1, 5, 10, 25, 50, 250)

boston_trn_rmse <- sapply(k, make_knn_pred, training = train, predicting = train)
boston_tst_rmse <- sapply(k, make_knn_pred, training = train, predicting = test)

best_k = k[which.min(boston_tst_rmse)]

# find overfitting, underfitting, and "best"" k
fit_status = ifelse(k < best_k, "Over", ifelse(k == best_k, "Best", "Under"))

# summarize results
knn_results = data.frame(
    k,
    round(boston_trn_rmse, 2),
    round(boston_tst_rmse, 2),
    fit_status
)
colnames(knn_results) = c("k", "Train RMSE", "Test RMSE", "Fit?")

# display results
knitr::kable(knn_results, escape = FALSE, booktabs = TRUE)
