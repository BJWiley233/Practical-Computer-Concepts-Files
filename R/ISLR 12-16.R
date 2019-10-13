library(MASS)
MASS::Boston
colnames(MASS::Boston)
library(ISLR)
ISLR::Khan$xtrain[,1]
datasets::USArrests
MASS
adversiting_data = read.csv("Advertising.csv", header = T, sep = ',', stringsAsFactors = F)
ls()
rm(list = ls())
ls()
set.seed(59)
x=rnorm(50)
y=x+rnorm(50, mean = 50, sd=.1)
cor(x,y)

plot(x,y)
pdf('Figure.pdf')
plot(x,y,col='green')
dev.off()


x=seq(-pi,pi, length = 50)
y=x
f=outer(x,y,function(x,y)cos(y)/(1+x^2))
contour(x,y,f)
contour(x,y,f, nlevels=45, add=T)
fa=(f-t(f))/2
contour(x,y,fa, nlevels=45, add=T)
image(x,y,fa, nlevels=45, add=T, col=topo.colors(12))
persp(x,y,fa, theta=180, phi = 45)


# 1
read.csv("two_way_aov.csv", header = T, sep =',', stringsAsFactors = F)
test <- read.csv("two_way_aov.csv", header = T, sep =',', stringsAsFactors = F, fileEncoding="UTF-8-BOM")

my_anova <- aov(Cravings ~ Procedure * Place, data = test)
names(test)
summary(my_anova)
mean(test[,3])
sd(test[,3])


test_chi = data.frame("Scanned" = c(56,61), "Not Scanned" = c(28,15), 
                      row.names = c("Alone", "With Adult"))

chisq.test(test_chi, correct = F)
brian = chisq.test(test_chi)
brian$stdres
?chisq.test

# 2
library(dplyr)
library(data.table)
library(tidyverse)
food2 = data.frame(Taste_Buds = c('Lots','Lots','Few','Few'),
                  Vegetable = c('Carrot','Broccoli','Carrot','Broccoli'),
                  Taste_Rating = c(3.2, 3.2, 3.0, 1.2),
                  stringsAsFactors=FALSE)
food2 = data.frame(Taste_Buds = character(),
                   Vegetable = character(),
                   Taste_Rating = double(),
                   stringsAsFactors=FALSE)
blah = list(c('Lots', 'Carrot', 3.2),
           c('Lots', 'Broccoli', 3.2),
            c('Few', 'Carrot', 3),
            c('Few', 'Broccoli', 1.2)) 
?data.table
for (val in blah) {
        food2[nrow(food2)+1, ] <- val
}
new <- as.data.frame(do.call("rbind",blah))
smartbind(food2, new)
lapply(food2, class)

food <- read.csv("btest.csv", header = T, sep =',', stringsAsFactors = F, fileEncoding="UTF-8-BOM")
lapply(food, class)
summary(aov(Taste_Rating ~ Taste_Buds * Vegetable, data = food))
summary(aov(Taste_Rating ~ Taste_Buds * Vegetable, data = food2))

library(stats)
library(graphics)
summary(esoph)
data(esoph)
table(esoph$agegp, esoph$ncases)

political <- data.frame(Observed = c(16,20,19), Expected = round(mean(c(16,20,19)),4))
row.names(political) <- c('Democrat', 'Republican', 'Independent')
pol_chi <- chisq.test(political$Observed, correct = T)
pol_chi$expected
Row_Total <- political[,"Expected"] / political[,"Observed"]
Column_Total <- political[,"Expected"] / sum(political[,"Observed"])
(political[,"Observed"] - political[,"Expected"])/sqrt(abs(political[,"Expected"]))
num <- c(-25.526, 256.32, -36.5, -81 , -525.796)
pol_chi$res  
(16-18.3333)/sqrt(18.3333)        
(16-18.3333)/18.33

coffee <- read.csv("coffee.csv", header = T, sep =',', stringsAsFactors = F, fileEncoding="UTF-8-BOM")
?anova
coffee_aov <- aov(Number.of.Correct.Times ~ Amount.of.Coffee, data = coffee)
summary(coffee_aov)
