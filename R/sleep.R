SCC <- readRDS("~/Source_Classification_Code.rds")
NEISCC <- merge(NEI, SCC, by="SCC")
head(NEISCC)
names(NEI)
names(SCC)
names(NEISCC)
subsetNEI <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD",  ]
nrow(subsetNEI)
aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEI, sum)



png("plot5.png", width=840, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
        xlab("year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle('Total Emissions from motor vehicle (type = ON-ROAD) in Baltimore City, Maryland (fips = "24510") from 1999 to 2008')
print(g)
dev.off()

L <- 1.2; n <- 1000; pp <- ppoints(n)
op <- par(mfrow = c(3,3), mar = c(3,3,1,1)+.1, mgp = c(1.5,.6,0),
          oma = c(0,0,3,0))
for(df in 2^(4*rnorm(9))) {
        plot(pp, sort(pchisq(rr <- rchisq(n, df = df, ncp = L), df = df, ncp = L)),
             ylab = "pchisq(rchisq(.),.)", pch = ".")
        mtext(paste("df = ", formatC(df, digits = 4)), line =  -2, adj = 0.05)
        abline(0, 1, col = 2)
}
mtext(expression("P-P plots : Noncentral  "*
                         chi^2 *"(n=1000, df=X, ncp= 1.2)"),
      cex = 1.5, font = 2, outer = TRUE)
par(op)


s2 <- 105.977^2
n <- 513
alpha <- .05
qtiles <- qchisq(c(1-alpha/2,alpha/2), n-1)
ivals <- (n-1)*s2/qtiles
sqrt(ivals)

sigmaVals <-seq(90,120, length = 1000)
likeVals <- dgamma((n-1)*s2, shape = (n-1)/2, scale = 2*sigmaVals^2)
?dgamma
likeVals <- likeVals/max(likeVals)
plot(sigmaVals,likeVals, type = "l")
lines(range(sigmaVals[likeVals >= 1/8]),c(1/8, 1/8))
lines(range(sigmaVals[likeVals >= 1/2]),c(1/2, 1/2))
?range

data(sleep)
sleep
require(reshape2)
dcast(data = sleep, formula = group ~ ID, fun.aggregate = sum, value.var = "extra")
dcast(data = sleep, formula = ID ~ group, fun.aggregate = sum, value.var = "extra")
sleep0 <- dcast(data = sleep, formula = ID ~ group, fun.aggregate = sum, value.var = "extra")
sleep0$diff <- sleep0$`2`-sleep0$`1`
sleep0
difference <- sleep0$`2`-sleep0$`1`
mn <- mean(difference)
s <- sd(difference)
n <- 10
mn + c(-1,1) * qt(.975, n-1) * s /sqrt(1)
t.test(difference)$conf.int
muVals <- seq(0,3,length = 1000)
likeVals <- sapply(muVals, function(mu){
        (sum((difference-mu)^2)/
                 sum((difference-mn)^2))^(-n/2)
         }
        )
plot(muVals, likeVals, type = "l")

likeVals2 <- sapply(muVals, function(mu){
        sum((difference-mu)^2)^(-n/2)/
                 sum((difference-mn)^2)^(-n/2)
}
)
plot(muVals, likeVals2, type = "l")
4^2/2^2
lines(range(muVals[likeVals>1/8]), c(1/8,1/8))
lines(range(muVals[likeVals>1/16]), c(1/16,1/16))
s2p <- (7*15.34^2+20*18.23^2)/27
t <- qt(.975, 27)
y <- 132.86 - 127.44 + c(-1,1) * (t*(s2p*(1/8+1/21))^.5)

127.44 - 132.86 + c(1,-1) * (t*(s2p*(1/8+1/21))^.5)
y/sqrt(s2p)
x <- (15.34^2/8 + 18.23^2/21)^2/(((15.34^2/8)^2/7)+((18.23^2/21)^2/20))
qt <- qt(.975, 15.04)
y <- 132.86 - 127.44 + c(-1,1) * (qt*(15.34^2/8 + 18.23^2/21)^.5)
