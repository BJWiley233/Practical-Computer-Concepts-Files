dataset <- data.frame(var1=rnorm(20,0,1), var2=rnorm(20,5,1))
dataset[c(2,5,7,10),1] <- NA
dataset[c(4,8,19),2] <- NA
summary(dataset)
linmodEst <- function(x, y)
{
  ## compute QR-decomposition of x
  qx <- qr(x)
  ## compute (x'x)^(-1) x'y
  coef <- solve.qr(qx, y)
  ## degrees of freedom and standard deviation of residuals
  df <- nrow(x)-ncol(x)
  sigma2 <- sum((y - x%*%coef)^2)/df
  ## compute sigma^2 * (x'x)^-1
  vcov <- sigma2 * chol2inv(qx$qr)
  colnames(vcov) <- rownames(vcov) <- colnames(x)
  list(coefficients = coef,
       vcov = vcov,
       sigma = sqrt(sigma2),
       df = df)
}
data(cats, package="MASS")
linmodEst(cbind(1, cats$Bwt), cats$Hwt)
x=c(1,2)
y=c(3,4)
x%*%y
sigma
x <- 1:4
(z <- x %*% x)    # scalar ("inner") product (1 x 1 matrix)
drop(z)
z# as 
x <- 1:4
x <- 1:4
(z <- x %*% x)    # scalar ("inner") product (1 x 1 matrix)
drop(z)             # as scalar

y <- diag(x)
z <- matrix(1:12, ncol = 3, nrow = 4)
y %*% z
y %*% x
x %*% z
?read.table

| When you are at the R prompt (>):
  | -- Typing skip() allows you to skip the current question.
| -- Typing play() lets you experiment with R on your own; swirl will ignore what you do...
| -- UNTIL you type nxt() which will regain swirl's attention.
| -- Typing bye() causes swirl to exit. Your progress will be saved.
| -- Typing main() returns you to swirl's main menu.
| -- Typing info() displays these options again.

library(swirl)
swirl()

#########################
InnerFunc <- function(x, y) { x * (y^2) }
InnerIntegral <- function(y) { sapply(y, 
                                      function(z) { integrate(InnerFunc, 0, 2, y=z)$value }) }
integrate(InnerIntegral, 0, 1)
########################
InnerFunc = function(x) { 4*x + 2 }
InnerIntegral = function(y) { sapply(y, 
                                     function(z) { integrate(InnerFunc, z/2, sqrt(z))$value }) }
integrate(InnerIntegral , 0, 4)
########################
InnerFunc = function(x,y) { x*y -(y^3) }
InnerIntegral = function(y) { sapply(y, 
                                     function(z) { integrate(InnerFunc, -1, z, y=z)$value }) }
integrate(InnerIntegral , 0, 1)
########################
x=3
if(x>3){
  y<-10
} else {
  y<0
}
y<-if(x>3){
  10
} else {
    0
}

x<- matrix(1:6, 2,3)
for(i in seq_len(nrow(x))) {
  for(j in seq_len(ncol(x))) {
    print(x[i,j])
  }
}

x0<-1
tol<-1e-4
y<-1
repeat{
      x1<-runif(1, .999, 1.001)
      if (abs(x1-x0)<tol){
          break
      } else {
          x0<-x1
          cat("iteration",y,"\n")
          y<-y+1
        }
}
  
cat("iteration",y)

l<-c(rnorm(10), runif(10), rnorm(10,1))
f <- c(1:30)

tapply (x,f,mean)

library(datasets)
s <- split(airquality, airquality$Month)
sapply(s, function(z) colMeans(z[, c("Ozone", "Solar.R", "Wind")]))

head(airquality)

s <- split(airquality, airquality$Month)
sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE))






