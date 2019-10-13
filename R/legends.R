library(datasets)
nrow(airquality[which(airquality[ ,1]>15), ])
library(dplyr)
nrow(subset(airquality, airquality$Ozone >15))
nrow(filter(airquality, airquality$Ozone > 15))

with(airquality, plot(Wind, Ozone))
title(main = "Ozone vs Wind")

with(airquality, plot(Wind, Ozone, main = "WvsO",type = "n"))
with(subset(airquality, Month ==5), points (Wind, Ozone, col = "blue"))
with(subset(airquality, Month !=5), points (Wind, Ozone, col = "tomato"))
colors()
legend("topright", pch = 17, col = c("blue", "tomato"), legend = c("May", "Other Months"))
model <- lm(Ozone~Wind, airquality)
abline(model, lwd = 2)

par(mfrow = c(1,3), mar = c(4,4,2,1), oma = c(0,0,4,0))
with (airquality, {
        plot(Wind, Ozone, main = "Wind vs Ozone")
        plot(Solar.R, Ozone, main = "Solar.R vs Ozone")
        plot (factor(Month), Temp, main = "Temp by Month")
        mtext ("New York Air Quality", outer = TRUE)
        
})

source("~/functions.r")

par(mfrow = c(1,1))
r <- rnorm(100)
y <- rnorm(100)
plot(r,y, pch = 20, col = "Blue", lwd = 4)
legend("topright", legend = "Brian", pch = 20, col = "red")
fit <- lm(y ~ r)
