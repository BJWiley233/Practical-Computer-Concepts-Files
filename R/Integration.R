cor
cov
library(dplyr)
library(UsingR)
library(ggplot2)
library(datasets)
library(HistData)
data(galton)
galton = Galton
freqData <- as.data.frame(table(galton$child, galton$parent))
names(freqData) <- c("child", "parent", "freq")
head(freqData)
freqData[which.max(freqData$freq),]
class(freqData$freq)
class(freqData$child)
freqData$child <- as.numeric(as.character(freqData$child))
freqData$parent <- as.numeric(as.character(freqData$parent))
install.packages("ggplot2")
?install.packages
packageURL <- "https://cran.r-project.org/src/contrib/ggplot2_2.2.1.tar.gz"
install.packages(packageURL, repos=NULL, type='source')
library(ggplot2)


cos(x)
require(stats)
integrate(myfunction, lower = -Inf, upper = Inf)
integrand <- function(x){cos(x)}

integrand <- function(x) {1/((x+1)*sqrt(x))}
integrate(integrand, lower = -Inf, upper = Inf)
library(Ryacas)
x <- Sym("x")
Integrate((cos(x))^4, x)
curve((-2 * sin(-2 * x) + (3 * x - sin(-4 * x)/4))/8, xlim = c(-10,10), ylim = c(-10,10))
curve((-2 * sin(-2 * x))/8, xlim = c(-10,10), ylim = c(-10,10))
curve((2 * sin(2 * x))/8, xlim = c(-10,10), ylim = c(-10,10))
curve((cos(x))^3*sin(x)/8, xlim = c(-10,10), ylim = c(-10,10))

