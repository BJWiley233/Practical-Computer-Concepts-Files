install.packages("sn")
library(sn)
?rsnorm
rsn(n=10000, xi=1.756269, omega=1.605681, alpha=5)
hist(rsn(n=100, xi=1.256269, omega=1.605681, alpha=5))
plot(density(rsn(n=10000, xi=1.856269, omega=1.805681, alpha=20)))
qqnorm(rsn(n=10000, xi=1.856269, omega=1.805681, alpha=20))
qqline(rsn(n=10000, xi=1.856269, omega=1.805681, alpha=50))

#left tailed
quantile(rsnorm(1000000, mean = 5, sd = 2, xi = 2.85))
plot(density(rsnorm(1000000, mean = 5, sd = 2, xi = 3.85)))
quantile(rsnorm(1000, mean = 5, sd = 2, xi = .2))
q <- quantile(rsnorm(1000000, mean = 50, sd = 2, xi = 1.85))
mean(rsnorm(1000000, mean = 50, sd = 2, xi = .15))
abline(v = mean(rsnorm(1000000, mean = 50, sd = 2, xi = 1.85)))
abline(v = median(rsnorm(1000000, mean = 50, sd = 2, xi = 1.85)))

draw <- rsnorm(1000000, mean = 5, sd = 2, xi = 3.85)
dens <- density(draw, bw = .7)
quantile(draw)
plot(dens)   
x1 <- min(which(dens$x >= quantile(draw, 0.25)))  
x2 <- max(which(dens$x < quantile(draw, .75))) 

#with(dens, polygon(x=c(x[c(x1,x1:x2,x2)]), y = c(0, y[x1:x2], 0), col="gray"))
#polygon(x=c(dens$x[c(x1,x1:x2,x2)]), y = c(0, dens$y[x1:x2], 0), col="gray")
#####################################################################################
dd <- with(dens,data.frame(x,y))
#library(ggplot2)
qplot(x,y,data=dd,geom="line")+
        geom_ribbon(data=subset(dd,x>quantile(draw, 0.25) & x<quantile(draw, .75)),aes(ymax=y),ymin=0,
                    fill="red",colour=NA,alpha=0.5)+
        scale_x_continuous(breaks=seq(0,10,1))+
        geom_vline(xintercept=median(draw))
q = quantile(draw)


q[3]-q[2]
q[4]-q[3]
qqnorm(rsnorm(1000, mean = 5, sd = 2, xi = .2))
qqline(rsnorm(1000, mean = 5, sd = 2, xi = .2))
mean(rsnorm(10000, mean = 5, sd = 2, xi = .2))
median(rsnorm(10000, mean = 5, sd = 2, xi = .2))
install.packages("fGarch")
library(fGarch)

integrate(function(x,y){(sin(x+y)^4)*(cos(x+y))^6}, lower = 0, upper = pi/2)
f <- function(a,b) {a^2 + a*b^2}
integrate(f, lower = 0, upper = 1, b = 5)
library(pracma)
integral2(function(x,y){(sin(x+y)^4)*(cos(x+y))^6}, xmin = 0, xmax = pi/2, ymin = 0, ymax = pi/2)

#f(x, y) = 4*(x-y)*(1-y), where 0 < y < 1, y < x < 2
library(pracma)
fun <- function(x, y) 4*(x-y)*(1-y)*(y < x)
integral2(fun, 0, 2, 0, 1, reltol = 1e-10)
#=============


#
fun2 <- function(x,y) x^3*y^4+x*y^2
integral2(fun2, 0, 2, function(x) x^3-x, function(x) x^2+x)
?integral2

fun25 <- function(x,y) y^3
I <- integral2(fun25, -pi/4, pi/4, 0, function(x) cos(2*x))

fun25x <- function(x,y) cos(x)*y^4
Ix<- integral2(fun25x, -pi/4, pi/4, 0, function(x) cos(2*x))

Ix/I
fun25y <- function(x,y) sin(x)*y^4
Iy<- integral2(fun25y, -pi/4, pi/4, 0, function(x) cos(2*x))
Iy$Q/I$Q

fun25Ix <- function(x,y) (sin(x))^2*y^5
IIx<- integral2(fun25Ix, -pi/4, pi/4, 0, function(x) cos(2*x))

fun25Iy <- function(x,y) (cos(x))^2*y^5
IIy<- integral2(fun25Iy, -pi/4, pi/4, 0, function(x) cos(2*x))

pt(-1.270953, 44)

tumor_function <- function(x, y, z) z^2*sin(x)
tpInt <- integral3(tumor_function, 0, pi, 0, 2*pi, 0, function(x, y) 1+((sin(6*y)*sin(5*x))/5))



