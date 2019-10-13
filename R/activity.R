download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip","~/activity.zip")
?download.file

if(!file.exists('activity.csv')){
        unzip('activity.zip')
}
activityData <- read.csv('~/activity.csv', header = TRUE)
sapply(activityData, class)
data <- activityData

data$intervalNew <- ifelse(data$interval >= 100, format(strptime(gsub("([0-9]{1,2})([0-9]{2})", "\\1:\\2", data$interval),"%H:%M"),"%H:%M"),
                               ifelse(data$interval >=10,sub("^","00:", data$interval),sub("^","00:0", data$interval)))
                               

data$posixDate <- as.POSIXct(paste(data$date, data$intervalNew),format = "%Y-%m-%d %H:%M")

require(dplyr)

totalStepsPerDay <- data %>%
        group_by(date) %>%
        summarise(sum(steps, na.rm = TRUE))
names(totalStepsPerDay) <- c("day", "steps")
jpeg('~/RepData_PeerAssessment1/figures/histTotalPerDay.jpg')
qplot(totalStepsPerDay$steps, bins = 30)
dev.off()
require(ggplot2)
mean(totalStepsPerDay$steps)
median(totalStepsPerDay$steps)

length(unique(data$intervalNew))
averageStepsInterval <- data %>%
        group_by(intervalNew) %>%
        summarise(mean(steps, na.rm = TRUE))


names(averageStepsInterval) <- c("interval", "meanSteps")
jpeg('~/RepData_PeerAssessment1/figures/avgDailyPattern.jpg', width = 800)
ggplot(averageStepsInterval, aes(interval, meanSteps, group = 1)) + geom_line() +
        scale_x_discrete(breaks = unique(averageStepsInterval$interval)[seq(1,length(unique(averageStepsInterval$interval)),12)])

dev.off()
which.max(averageStepsInterval$Mean.Steps)
class(averageStepsInterval)
averageStepsInterval[which.max(averageStepsInterval$meanSteps),]
averageTimeBlock <- aggregate(x = list(meansteps = data$steps), by = list(interval = data$intervalNew), FUN = mean, na.rm = T)

ggplot() + geom_line(aes(interval, meansteps, group = 1), data = averageTimeBlock, stat = "identity" )
head(data, 100)
length(which(is.na(data$steps)))
newData <- data %>%
        group_by(intervalNew) %>%
        mutate(steps = ifelse(is.na(steps), mean(steps,na.rm =T), steps))
length(which(is.na(newData$steps)))
head(newData)
newestData <- data
newestData$steps <- with(newestData, ave(steps, intervalNew, FUN = function(x)
        replace(x, is.na(x), mean(x, na.rm =T)))) 
mean(newestData$steps)
install.packages("imputeR")
install.packages("impute")
length(which(is.na(newData)))
qplot(newData$steps, bins = 30, main = "Input Values of Interval Mean")
newesttotalStepsPerDay <- newData %>%
        group_by(date) %>%
        summarise(sum(steps, na.rm = TRUE))
names(newesttotalStepsPerDay) <- c("day", "steps")
newesttotalStepsPerDay <- tapply(newData$steps, newData$date, sum)
jpeg('~/RepData_PeerAssessment1/figures/InputValues_IntervalMean.jpg', width = 800)
qplot(newesttotalStepsPerDay, bins = 30, main = "Input Values of Interval Mean")
dev.off()
newData$dateType <- ifelse(as.POSIXlt(newData$date)$wday %in% c(0,6), "weekend", "weekday")
head(newData[newData$dateType == "weekend",])
averageActivityDOW <- newData %>% 
                group_by(intervalNew, dateType) %>%
                summarise(steps = mean(steps))
head(averageActivityDOW)
averageActivityDOW$intervalNewest <- as.POSIXct(strptime(averageActivityDOW$intervalNew, "%H:%M"))
ggplot() + geom_line(aes(intervalNewest, steps, group = 1), data = averageActivityDOW, 
                     stat = "identity" ) + facet_grid(dateType ~ .)

jpeg('~/RepData_PeerAssessment1/figures/Weekend_vs_Weekend.jpg', width = 800)
ggplot(averageActivityDOW, aes(intervalNew, steps, group = 1)) + geom_line() + 
        facet_grid(dateType ~ .) +
        scale_x_discrete(breaks = unique(averageActivityDOW$intervalNew)[seq(1,length(unique(averageActivityDOW$intervalNew)),12)]) +
        ggtitle("Weekend Steps vs. Weekday Steps") +
        theme(plot.title = element_text(hjust = 0.5))
dev.off()

unique(averageActivityDOW$intervalNew)

length(unique(newData$date))* length(unique(newData$interval))
class(averageActivityDOW$intervalNew)

head(averageActivityDOW$intervalNew)
install.packages("chron")
require(chron)
chron(times=averageActivityDOW$intervalNew, format = "%H:%M")


averagedActivityDataImputed <- aggregate(steps ~ interval + dateType, data=newData, mean)
ggplot(averagedActivityDataImputed, aes(interval, steps)) + 
        geom_line() + 
        facet_grid(dateType ~ .) +
        xlab("5-minute interval") + 
        ylab("avarage number of steps")

library(manipulate)
myHist <- function(mu){
        g <- ggplot(Galton, aes(child)) +
                geom_histogram(fill="salmon", binwidth = 1, aes(y = ..density..), colour = "black") +
                geom_density(size = 2) +
                geom_vline(xintercept = mu, size = 2)
        mse <- round(mean(Galton$child - mu)^2,3)
        g <- g + labs(title = paste('mu = ', mu, 'MSE =', mse))
        g
}
manipulate(myHist(mu), mu = slider(62, 74, step = 0.5))
library(datasets)
data(Galton)
install.packages("HistData")
library(HistData)
library(ggplot2)
Galton$child
x<- 1:4
p <- x/sum(x)
p
temp <- rbind(x,p)
temp
rownames(temp) <- c("X", "Prob")
temp
mean(x*p)

p(+|D) sens = .75
p(-|~D) spec = .52
p(D) = .3 D = .3

p(D|+) = p(+|D)p(D) / p(+|D)p(D) + P(+|~D)(~D)

sens*D/(sens*D +(1-spec)*(1-D))

install.packages("UsingR")
library(UsingR)
data("father.son")
names(father.son)
x <- father.son$sheight
n <- length(x)
ggplot(as.data.frame(x), aes(x)) + geom_histogram(fill="salmon", binwidth = 1,aes(y = ..density..), colour = "black") +
        geom_density(size = 2)
class(x)
class(father.son)
pnorm(93, 100, 10)
pA = .05
(+|A) = .93 sens
sens = .93
(-|~A) = .88
spec = .88
(~A|-) = (-|~A)~pA / (-|~A)~pA + (-|A)pA
(.88*.95)/((.88*.95) + (1-.93)*.05)

qnorm(.95, 100,10/sqrt(50))
nosim = 1000000
choose(15,3)*.2^3*.8^12
apply(matrix(sample(1 : 6, nosim * 10, replace = TRUE), 
             nosim), 1, var)
mean(apply(matrix(sample(1 : 6, nosim * 10, replace = TRUE), 
                  nosim), 1, var))
sqrt(15.17)
15.17-3.5^2
j=0
k=0
i=0
for (i in 1:6){
        j <- i^2*1/6
        k <- k + j
}
k - 3.5^2
variance <- sum(sapply(x<-c(1:6),function (x){x^2*1/6})) - 3.5^2
x
?lapply
pbinom(2, size = 10000, prob = .00001)
ppois(2, 10000*.00001)

nosim <- 1000
cfunc <- function(x, n) sqrt(n) * (mean(x) - 3.5) / 1.71)
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

p = .5
cfunc2 <- function(x, n)  2 * (mean(x) - .5) * sqrt(n)
cfunc3 <- function(x, n) mean(x) * n
cfunc4 <- function(x) x
cfunc2
?apply

dat1 <- data.frame(
        x = c(apply(matrix(sample(0 : 1, nosim * 10, replace = TRUE), 
                           nosim), 1, cfunc2, 10),
              apply(matrix(sample(0 : 1, nosim * 20, replace = TRUE), 
                           nosim), 1, cfunc2, 20),
              apply(matrix(sample(0 : 1, nosim * 30, replace = TRUE), 
                           nosim), 1, cfunc2, 30)
        ),
        size = factor(rep(c(10, 20, 30), rep(nosim, 3))))



length(apply(matrix(sample(0 : 1, nosim * 10, replace = TRUE), 
                    nosim), 1, cfunc3, 10))
