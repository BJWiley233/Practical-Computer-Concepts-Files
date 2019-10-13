x <- y <- matrix( 0, 4, 4)
x[ sample(1:4,2), sample(1:4,2)] <- rexp( 4, 0.25)
y <- disk2dsmooth( x=x, lambda=6.5)
x <- gauss2dsmooth( x=x, lambda=1, nx=1, ny=1)
gauss2dsmooth
install.packages("KRLS")
library(KRLS)

gausskernel(x, 1)
?gausskernel

m11 <- (exp(-((1^2+1^2)/2)))/(2*pi)
m11*0.00296902
m11/

m21 <- (exp(-((2^2+1^2)/2)))/(2*pi)
m21*0.0133062

install.packages('roperators')
require(roperators)

two_d_kernel <- function(matrix_size=5, sigma=1) {
    ker <- matrix(rep(0,matrix_size^2), nrow = matrix_size)
    s <- 2 * sigma^2
    center_size <- (matrix_size-1)/2
    
    center <- c(-1,1)*center_size
    for (i in seq(center[1],center[2])){
        for (j in seq(center[1],center[2])){
            r <- sqrt
            ker[i+center_size+1, j+center_size+1] <- exp(-(i^2+j^2)/s)/(s*pi)
            
        }
    }
    return(ker/sum(ker))
}
plot(density(two_d_kernel(5, 1)))  
    