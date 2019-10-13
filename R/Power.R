mean <- 32
sd <- .06
n <- 36
alpha <- .05

ci <- c(-1,1)*qnorm(1-alpha/2)*sd/sqrt(n) + mean

s <- seq(31.80,32.2,0.001)
plot(s, dnorm(s,32, .06/sqrt(n)), type="l")
#lines(s, dnorm(s,31.97, .06), col="red")
redtrans <- rgb(255, 0, 0, 127, maxColorValue=255)
abline(v=ci[1], col="pink", lwd=2, lty=2)
abline(v=ci[2], col="pink", lwd=2, lty=2)

# from1 <- 31.8
# to1 = ci[1]
# S.x <- c(from1, seq(from1, to1, 0.0005), to1)
# S.y  <- c(0, dnorm(seq(from1, to1, 0.0005), 32, .06), 0)
# redtrans <- rgb(255, 0, 0, 127, maxColorValue=255)
# polygon(S.x,S.y, col=redtrans)
# 
# from2 <- ci[2]
# to2 = 32.2
# S.x2 <- c(from2, seq(from2, to2, 0.0005), to2)
# S.y2  <- c(0, dnorm(seq(from2, to2, 0.0005), 32, .06), 0)
# redtrans <- rgb(255, 0, 0, 127, maxColorValue=255)
# polygon(S.x2,S.y2, col=redtrans)
newmean <- 32.01
lines(s, dnorm(s, newmean, .06/sqrt(n)), col="blue", lwd=2)

from3 <- ci[1]
to3 = ci[2]
S.x3 <- c(from3, seq(from3, to3, 0.00005), to3)
S.y3  <- c(0, dnorm(seq(from3, to3, 0.00005), newmean, .06/sqrt(n)), 0)
yellowtrans <- rgb(255, 255, 0, 127, maxColorValue=255)
polygon(S.x3,S.y3, col=yellowtrans)



################ data
ci <- c(-1,1)*qnorm(1-alpha/2)*sd/sqrt(n) + mean

assumed <- 31.97
zleft <- (ci[1]-assumed)/(sd/sqrt(n))
zright <- (ci[2]-assumed)/(sd/sqrt(n))
1-(pnorm(zright) - pnorm(zleft))

assumed2 <- 32.01
zleft2 <- (ci[1]-assumed2)/(sd/sqrt(n))
zright2 <- (ci[2]-assumed2)/(sd/sqrt(n))
1-(pnorm(zright2) - pnorm(zleft2))
