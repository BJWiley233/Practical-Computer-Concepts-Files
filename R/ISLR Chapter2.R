
college <- read.csv("College.csv", header = T, sep = ",")
rownames(college) <- college[ ,1]
fix(college)
college <- college[, -1]
summary(college)
pairs(college[ ,1:10])

?plot
?boxplot
plot(college$Private, college$Outstate, col = "lightpink",
     xlab = "Private?", ylab = "Num Outstate")
library(ggplot2)
ggplot(college[, c("Private", "Outstate")], aes(x = Private, y = Outstate, fill = Private)) + 
    geom_boxplot()

Elite <- rep("No", nrow(college))
Elite[college$Top10perc > 50] <- "Yes"
Elite <- as.factor(Elite)
college <- data.frame(college, Elite)
summary(college)

par(mfrow=c(2,2))
quantC <- college[,2:ncol(college)-1]

column <- sample(names(quantC), 1)
for (i in seq(1, 4, 1)) {
    hist(quantC[, column], breaks = sample(log(dist(range(quantC[, column]))), 1),
         main = column)
}
