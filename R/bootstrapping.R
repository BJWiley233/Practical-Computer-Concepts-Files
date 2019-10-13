sample(10)
sample(100, replace=T)
?sample
sample(1:100, 20, replace = T)
prob1 <- c(rep(.85, 5), rep(.15, 5))
sample(10, replace = T, prob = prob1)
set.seed(100000)
y1 <- matrix( round(rnorm(25,5)), ncol=5)
x1 <- y1[sample(5)]

y2 <- matrix( round(rnorm(40, 5)), ncol=5)
y2[sample(3),]


# Example
data <- round(rnorm(100, 5, 3))
data1 <- round(rnorm(100, 5, 5))
resamples <- lapply(1:20, function(x) sample(data, replace = T))
set_intersection(as.set(data), as.set(unlist(resamples[1])))
r.median <- sapply(resamples, median)
sqrt(var(r.median))
hist(r.median)

data <- round(rnorm(100, 5, 3))
b.median <- function(data, num) {
        resamples <- lapply(1:num, function(i) sample(data, replace=T))
        r.median <- sapply(resamples, median)
        std.err <- sqrt(var(r.median))
        list(std.err=std.err, resamples=resamples, medians=r.median)   
}
b1 <- b.median(data, 30)
b1$std.err
hist(b1$medians)

library(boot)
data(city)
ratio <- function(d, w) sum(d$x * w)/sum(d$u * w)
?boot
boot(city, ratio, R=999, stype="w")
