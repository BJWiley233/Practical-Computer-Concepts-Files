library(datasets)

##lm <- lsfit(x = airquality$Ozone, y = airquality$Temp*airquality$Temp)
##with(airquality, plot(Ozone, Temp))
##abline(lm)
x <- cbind(airquality$Ozone, airquality$Temp)
y <- as.data.frame(x[complete.cases(x), ])
names(y) <- c("Ozone", "Temp")
Time <- as.vector(y$Temp)
Counts <- as.vector(y$Ozone)
length(Time)
length(Counts)
attach(y)
names(y)
linear.model <-lm(Counts ~ Time)
plot(Time, Counts, pch=16, ylab = "Ozone Level", cex.lab = 1.3, col = "red" )

abline(lm(Counts ~ Time), col = "blue")

Time2 <- Time^2
quadratic.model <-lm(Counts ~ Time + Time2)
timevalues <- seq(0, 100, 0.1)
predictedcounts <- predict(quadratic.model,list(Time=timevalues, Time2=timevalues^2))

plot(Time, Counts, pch=16, xlab = "Temp(s)", ylab = "Ozone Level", cex.lab = 1.3, col = "blue", main = "Ozone Level over Temperature")
lines(timevalues, predictedcounts, col = "darkgreen", lwd = 3)
text(60, 130, expression("Ozone Level = 305.48577 - 
9.5060(Temp) + .07708(Temp)"^2), cex = .6, adj=0)

# plot(1:10, 1:10, yaxt="n", ylab=""); 
# mtext("Title", side=3, adj=1, line=1.2, cex=2, font=2); 
# axis(2, las=1)
# 
# plot(1:10) 
# legend('topleft', expression(4^th*"-root transformation")) 
# 
# rsquarelm2 <- 0.855463
# 
# text(5, 5, bquote(R^2))
# ?mtext