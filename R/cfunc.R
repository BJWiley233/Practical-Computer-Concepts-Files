nosim <- 1000
cfunc <- function(x, n) sqrt(n) * (mean(x) - 3.5) / 1.71
dat <- data.frame(
        x = c(apply(matrix(sample(1 : 6, nosim * 10, replace = TRUE), 
                           nosim), 1, cfunc, 10),
              apply(matrix(sample(1 : 6, nosim * 20, replace = TRUE), 
                           nosim), 1, cfunc, 20),
              apply(matrix(sample(1 : 6, nosim * 30, replace = TRUE), 
                           nosim), 1, cfunc, 30)
        ),
        size = factor(rep(c(10, 20, 30), rep(nosim, 3))))
g <- ggplot(dat, aes(x = x, fill = size)) + geom_histogram(alpha = .20, binwidth=.3, colour = "black", aes(y = ..density..)) 
g <- g + stat_function(fun = dnorm, size = 2)
g + facet_grid(. ~ size)


cfunc2 <- function(x, n) sqrt(n) * (mean(x) - .9) / (sqrt(.9*.1))
dat1 <- data.frame(
        x = c(apply(matrix(sample(0 : 1, nosim * 10, replace = TRUE), 
                           nosim), 1, cfunc2, 10),
              apply(matrix(sample(0 : 1, nosim * 20, replace = TRUE), 
                           nosim), 1, cfunc2, 20),
              apply(matrix(sample(0 : 1, nosim * 30, replace = TRUE), 
                           nosim), 1, cfunc2, 30)
        ),
        size = factor(rep(c(10, 20, 30), rep(nosim, 3))))

x0 <- c(1,2,3)
x1 <- c(4,5,6)
c(x0,x1)
g <- ggplot(dat1, aes(x = x, fill = size)) + geom_histogram(alpha = 1, binwidth=.3, colour = "black", aes(y = ..density..)) 
g <- g + stat_function(fun = dnorm, size = 2)
g + facet_grid(. ~ size)
help(initplist)
arrows3D
splitdotpersp()
?initplist
getplist
?getplist
help(initplist)
install.packages("Deriv")
require(Deriv)
t <- function(x) sin((x^2+5)*(cos(x)))
Deriv(t)
m <- function(x) (x^2+5)*cos(x)
Simplify(Deriv(m))
2 * (x * cos(x)) - (5 + x^2) * sin(x)
cos((x^2+5)*(cos(x))) * (2 * (x * cos(x)) - (5 + x^2) * sin(x))    
install.packages("Ryacas")
require(Ryacas)
x <- Sym("x")
s <- expression(tan(x))
deriv(s,x)
?deriv
x <- Sym("x");
s <- expression(tan(x));
deriv(s,x);

library(Ryacas);
x <- Sym("x");
s <- expression(1 / (1+e^-x));
Simplify(deriv(s,x))
Simplify(3*(sin(x^2)^2))
Deriv(sin(x))

t<- function(x) sin(x)

sin(x)
Deriv(expression((cos(x)^2)/x))
log

?round
Inf-(-Inf)

require(dplyr)
num_download <- function(pkgname, date = "2016-07-20") {
        check_pkg_deps()
        
        ## Check arguments
        if(!is.character(pkgname))
                stop("'pkgname' should be character")
        if(!is.character(date))
                stop("'date' should be character")
        if(length(date) != 1)
                stop("'date' should be length 1")
        
        dest <- check_for_logfile(date)
        cran <- read_csv(dest, col_types = "ccicccccci", 
                         progress = FALSE)
        cran %>% filter(package %in% pkgname) %>% 
                group_by(package) %>%
                summarize(n = n())
}    
check_for_logfile <- function(date) {
        year <- substr(date, 1, 4)
        src <- sprintf("http://cran-logs.rstudio.com/%s/%s.csv.gz",
                       year, date)
        dest <- file.path("data", basename(src))
        if(!file.exists(dest)) {
                val <- download.file(src, dest, quiet = TRUE)
                if(val)
                        stop("unable to download file ", src)
        }
        dest
}
check_pkg_deps <- function() {
        if(!require(readr)) {
                message("installing the 'readr' package")
                install.packages("readr")
        }
        if(!require(dplyr))
                stop("the 'dplyr' package needs to be installed first")
}
getwd()

src <- "http://cran-logs.rstudio.com/2018/2018-01-13.csv.gz"
dest <- file.path("data", basename(src))
if(!file.exists(dest)) {
        
        val <- download.file(src, dest, quiet = TRUE)
        print(val)
        if(!val) 
                
                stop("unable to download file ", src)
}

brian <- download.file("https://support.spatialkey.com/spatialkey-sample-csv-data/", "data/spatial.csv")
brian
