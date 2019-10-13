adv <- read.csv("Advertising.csv")

par(mfrow=c(1,1))
mod <- lm(adv$sales ~ adv$TV)
data <- transform(data.frame(adv$sales, adv$TV), Fitted = fitted(mod))

plot(adv.sales ~ adv.TV, data = data, type = "p", pch = 16, 
     cex = 1, col = "red")
lines(Fitted ~ adv.TV, data = data, col = "blue")
with(data, segments(adv.TV, adv.sales, adv.TV, Fitted), col = "lightgrey")

ggplot(data, aes(adv.TV, adv.sales)) + 
    geom_point(color="red") + 
    geom_smooth(se=FALSE, method = "lm") +
    geom_segment(aes(x = adv.TV, y = adv.sales,
                     xend = adv.TV, yend = Fitted))



mod <- loess(adv$sales ~ adv$TV)
data <- transform(data.frame(adv$sales, adv$TV), Fitted = fitted(mod))
plot(adv.sales ~ adv.TV, data = data, type = "p", pch = 16, 
     cex = 1, col = "red")
lines(data$adv.TV[order(data$adv.TV)], 
      data$Fitted[order(data$adv.TV)],
      col = "blue",
      lwd = 1.5)
with(data, segments(adv.TV, adv.sales, adv.TV, Fitted), col = "lightgrey")