colMeans <- function(x) {
        nc <- ncol(x)
        columns <- length(colnames(x))
        means <- nc
        for (j in 1:nc) {
                columns[j] <- colnames(x[j])
        }
        for (i in 1:nc){
                means[i] <- mean(x[, i], na.rm = TRUE)
        }
        return(list("columns"=columns,"means"=means))
}

colMeans(dataset)
?removeNA
colnames(dataset)
?list

make.NegLogLik <- function(data, fixed=c(FALSE,FALSE)) {
        params <- fixed
        function(p) {
                params[!fixed] <- p
                mu <- params[1]
                sigma <- params[2]
                a <- -0.5*length(data)*log(2*pi*sigma^2)
                b <- -0.5*sum((data-mu)^2) / (sigma^2)
                -(a + b)
        } 
}
?fitdist()
