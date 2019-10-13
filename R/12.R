##poisson
set.seed(1)
x <- rnorm(100, 0, 1)
log.mu <- .5 + .3 * x
y <- rpois(100, exp(log.mu))
##dpois(c(1,2,3), 1)
summary(y)
plot(x,y)

hibert <- function(n) {
        i <- 1:n
        1/outer(i-1, i, "+")
}
