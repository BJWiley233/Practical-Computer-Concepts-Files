times <- c("9:06", "16:42", "15:05", "12:00", "3:38")

format(strptime(times, "%H:%M"), format = "%I:%M %p")

#two sided p-value
pvalue2sided <- 2*pnorm(abs(-1.96))

convert.z.score <- function(z, one.sided=NULL) {
        if(is.null(one.sided)) {
                pval = pnorm(-abs(z));
                pval = 2 * pval
        } else if(one.sided=="-") {
                pval = pnorm(z);
        } else {
                pval = pnorm(-z);                                                                                 
        }
        return(pval);
}   

pbinom(10, 20, .1, lower.tail = FALSE)
binom.test(11, 20, .1, alternative = "greater")

tvals <- seq(-pi/2, pi/2, length.out = 7)
sinvals <- vapply(tvals, iv.opC, complex(1), L.FUN = L.sin)
plot(tvals, Re(sinvals), type = "l")
test = c(1, 2, 3, 4, 5)
for (attempt in test){
        print(attempt)
}

pbinom(6, 10, .5, lower.tail = FALSE)
