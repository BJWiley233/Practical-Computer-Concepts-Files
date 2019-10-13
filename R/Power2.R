mean <- 15.4
sd <- 2.5
n <- 35
alpha <- .05

ci <- c(-1,1)*qnorm(1-alpha/2)*sd/sqrt(n) + mean

assumed <- 15.1
zleft <- (ci[1]-assumed)/(sd/sqrt(n))
zright <- (ci[2]-assumed)/(sd/sqrt(n))
1-(pnorm(zright) - pnorm(zleft))

ci_t <- c(-1,1)*qt(1-alpha/2, df=n-1)*sd/sqrt(n) + mean
tleft <- (ci_t[1]-assumed)/(sd/sqrt(n))
tright <- (ci_t[2]-assumed)/(sd/sqrt(n))
1-(pt(tright, df=n-1) - pt(tleft, df=n-1))
