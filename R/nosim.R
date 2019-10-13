nosim <- 1000
cfunc <- function(x, n) sqrt(n) * (mean(x) - 0.9) / sqrt(.1 * .9)
dat <- data.frame(
        x = c(apply(matrix(sample(0:1, prob = c(.1,.9), nosim * 10, replace = TRUE), 
                           nosim), 1, cfunc, 10),
              apply(matrix(sample(0:1, prob = c(.1,.9), nosim * 20, replace = TRUE), 
                           nosim), 1, cfunc, 20),
              apply(matrix(sample(0:1, prob = c(.1,.9), nosim * 100, replace = TRUE), 
                           nosim), 1, cfunc, 100)
        ),
        size = factor(rep(c(10, 20, 100), rep(nosim, 3))))
g <- ggplot(dat, aes(x = x, fill = size)) + geom_histogram(binwidth=.3, colour = "black", aes(y = ..density..)) 
g <- g + stat_function(fun = dnorm, size = 2)
g + facet_grid(. ~ size)

(mean(x) + c(-1,1) * qnorm(.975) * sd(x)/sqrt(length(x)))/12

qnorm(.975)
qnorm(.975)

.56 + c(-1,1)*qnorm(.975) * sqrt(.56*(1-.56)/100)
c <- binom.test(56,100)
c$conf.int



n <- 20
pvals <- seq(.1, .9, .05)
nosim <- 1000
coverage <- sapply(pvals, function(p) {
        phats <- (rbinom(nosim, prob = p, size = n)+.5)/(n+1)
        ll <- phats - qnorm(.975) * sqrt(phats*(1-phats)/n)
        ul <- phats + qnorm(.975) * sqrt(phats*(1-phats)/n)
        mean(ll < p & ul > p)
})
#plot(pvals, coverage, type = "l")

ggplot(data.frame(pvals, coverage), aes(x = pvals, y = coverage)) +
        geom_line(size = 2) + geom_hline(yintercept = .95) +
        ylim(.75,1)
?ylim

set.seed(10)
gmVol <- rnorm(629, 589, 51)
x <- seq(-4,4, length = 630)*sd(gmVol) + mean(gmVol)
hx <- dnorm(x,mean(gmVol), sd(gmVol))
par(mfrow = c(1,2))
median(gmVol); plot(x,hx, type = "l")
abline( v = median(gmVol))
gmVol2 <- jitter(gmVol, 255)
x1 <- seq(-4,4, length = 630)*sd(gmVol2) + mean(gmVol2)
hx2 <- dnorm(x1,mean(gmVol2), sd(gmVol2))
median(gmVol2); plot(x1,hx2, type = "l")
n <- length(gmVol)
theta <- median(gmVol)
jk <- sapply(1 : n,
       function (i) median(gmVol[-i])
       )

thetabar <- mean(jk)
bias <- (n-1)*(thetabar - theta)
seEst <- sqrt((n-1) * mean((jk-thetabar)^2))
seEst2 <- ((n-1)/n *sum((jk-thetabar)^2))^(1/2)
install.packages("bootstrap")
library(bootstrap)





out <- jackknife(gmVol, median)
out$jack.bias
out$jack.se
set.seed(Sys.time())

gmVol <- rnorm(629, 589, 59); median(gmVol)
B<-1000
resamples <- matrix(sample(gmVol, n*B, replace = T),
                    B, n)
medians <- apply(resamples, 1, median)
sd(medians)
quantile(medians, c(.025,.975))


m1 <- 3
m2 <- 5
sd1 <- sqrt(.6)
sd2 <- sqrt(.68)
t <- qt(.95,18)
sp <- (9*.60 + 9*.68)/18

m2 - m1 + c(-1,1)*t*sqrt(sp*(1/9 + 1/9))

?rexp
y <- rexp(10000)
x <- rnorm(10000)
plot(sort(y), sort(x), type = "l")
order(y)
sort(y)
funcY <- (1 - exp(-x))
plot(sort(funcY), sort(x), type = "l")
funcY2 <- (-log(1-x))
plot(sort(funcY2), sort(x), type = "l")
length(funcY2)
length(is.nan(funcY))
x1 <- x[which(1- x > 0)]
1- x1
funcY2 <- (-log(1-x1))
plot(sort(funcY2), sort(x1), type = "l")
pop <- c(1,3)
b <- 1000
n <- length(pop)
resample <- matrix(sample(pop,
                        n * B, replace = TRUE),
                 B,n)
means <- apply(resample, 1, mean)
hist(means)
funcX <- function (x) x/2
funcX(4)
funcG <- function (x) funcX(3^2*x + 4)
pop <- runif(100, 0, 1)
qqplot(funcX(pop),funcG(pop))
