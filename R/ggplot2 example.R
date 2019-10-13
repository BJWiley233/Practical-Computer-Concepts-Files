par(mar = c(2, 2, 2, 2))
layout(matrix(c(31,1,2,3,
                32,41,16,17,
                18,42,33,4,
                5,6,34,43,19,
                20,21,44,35,7,
                8,9,36,45,22,
                23,24,46,37,10,
                11,12,38,47,25,
                26,27,48,39,13,
                14,15,40,49,28,
                29,30,50), ncol=5))
for (i in 1:30) {
        plot(x, main =i)
}

library(lattice)
#state <- data.frame(state.x77, region = state.region)
#xyplot(Life.Exp ~ Income | region, data = state, layout = c(4, 1))
library(dplyr)
library(datasets)
airquality <- transform(airquality, Month = factor(Month))
boxplot(mapping = NULL, Ozone ~ Month, airquality, xlab = "Month", ylab = "Ozone (ppb)", main = "Name", pch = 22, outlier.colour = "red")

#p <- ggplot(airquality, aes(Month, Ozone, fill = factor(Month)))
#p + geom_boxplot(outlier.shape = 17) + 
        #scale_fill_manual(name = "Ozone Levels Per Month", values = c("pink", "green", "orange", "yellow", "blue"))
library(plotly)
packageVersion('plotly')
library(ggplot2)                                                          
library(datasets)
lines <- "blanchedalmond"
t <- ggplot(airquality, aes(factor(Month), Ozone))
t +  geom_boxplot(aes(fill=factor(Month), color = factor(Month)), outlier.size = 2) +
        scale_fill_manual(name = "Ozone Levels Per Month", values = c("pink", "green", "orange", "yellow", "blue")) +
        scale_color_manual(name = "Ozone Levels Per Month", values = c("pink", "green", "orange", "yellow", "blue")) +
        geom_boxplot(aes(fill=factor(Month)), outlier.size = 2, outlier.colour = NA) #if you want grey lines

par()

head(airquality, n=25)
length(unique(airquality$Month))
parMar <- function (x) {
        par(mar = c(5.1,4.1,4.1,2.1))
}

