pollution <- read.csv("~/data/avgpm25.csv", colClasses = c("numeric", "character",
                                                         "factor", "numeric", "numeric"))
sapply(pollution, mode)
####
par(mar = c(2, 2, 2, 2))
layout(matrix(c(1,2,3,4,1,5,3,6),ncol=2),heights=c(1,3,1,3))
plot.new()
text(0.5,0.5,"Box W vs E",cex=2,font=2)
boxplot(subset(pollution, region == "west")$pm25, col = "blue", xlab = "Brian")
abline(h=quantile(subset(pollution, region == "west")$pm25, c(0.25, 0.75)), col="red")
plot.new()
text(0.5,0.5,"Scatter W vs E",cex=2,font=2)
with(subset(pollution, region == "west"), plot(latitude, pm25, col=ifelse(pm25>=12,"red",ifelse(pm25<=5, "green", "black")), main = "West"))
boxplot(subset(pollution, region == "east")$pm25, col = "red")
abline(h=quantile(subset(pollution, region == "east")$pm25, c(0.25, 0.75)), col="blue")
with(subset(pollution, region == "east"), plot(latitude, pm25, col=ifelse(pm25>=12,"red",ifelse(pm25<=5, "green", "black")), main = "East"))
####
par(mfrow = c(1,1))

x<-1:10

Threeby3GraphMatrixH(x)
Threeby3GraphMatrixV <- function(x) {
par(mar=c(1,1,1,1), mfrow = c(3, 3), bg = "white")
layout(matrix(c(1,2,3,4,5,6,1,7,3,8,5,9,1,10,3,11,5,12),ncol=3))
plot.new()
text(0.5,0.5,"First title",cex=2,font=2)
plot(x, xlab = "Brian", ylab = "Number", main = "1")
plot.new()
text(0.5,0.5,"Second title",cex=2,font=2)
hist(x, main = "2")
plot.new()
text(0.5,0.5,"Third title",cex=2,font=2)
boxplot(x, main = "3")
barplot(x, main = "4")
boxplot(x, main = "5")
barplot(x, main = "6")
barplot(x, main = "7")
hist(x, main = "8")
barplot(x, main = "9")
}




par(mfrow=c(5,5))
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")
boxplot(subset(pollution, region == "west")$pm25, col = "blue")


rug(pollution$pm25)
par(bg = "yellow", new = FALSE)
hist(pollution$pm25, col = "maroon", breaks = 100, main = "Average pm25")
rug(pollution$pm25)
?abline
abline(v=12, col = "blue", lwd = 2)
abline(v=median(pollution$pm25), col = "magenta", lwd = 3)
barplot(table(pollution$region), col = "wheat", main = "Number of Counties in Each Region")

boxplot(pm25 ~ region, data = pollution, col = "red")
par(mfrow = c(2, 1), mar = c(5.1, 5.1, 5.1, 5.1)) ##5.1, 4.1, 4.1, 2.1
hist(subset(pollution, region == "east")$pm25, col = "green")
hist(subset(pollution, region == "west")$pm25, col = "green")
par(mfrow=c(1,1))
with(pollution, plot(latitude, pm25, col = region))
abline(h = 12, lwd = 2, lty = 20)

par(mfrow = c(1, 2), mar = c(5, 4, 2, 1))
with(subset(pollution, region == "west"), plot(latitude, pm25, col=ifelse(pm25>=12,"red",ifelse(pm25<=5, "green", "black")), main = "West"))
with(subset(pollution, region == "east"), plot(latitude, pm25, col=ifelse(pm25>=12,"red",ifelse(pm25<=5, "green", "black")), main = "East"))