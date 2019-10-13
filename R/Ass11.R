# 1.

#A) This is a repeated measures experiment.  Each subject is obsserved on three types of measurements
# Also can be names one-way repeated measures test or Within-Subjects Designs
# http://onlinestatbook.com/2/research_design/designs.html

#B) 
#library(tabulizer)
library(dplyr)
library(reshape2)
library(tidyr)
#lst <- extract_tables("Week11Asgmt.pdf", encoding="UTF-8") 
#lst[[1]]
#dogs <- data.frame(lst[[1]])
#dogs <- slice(dogs, 3:n())
#row.names(dogs) <- dogs[,1]
#dogs <- dogs[,2:ncol(dogs)]
#for (i in seq(1, 10, 1)){
#    names(dogs)[i] <- paste0("Dog ", i)
#}
#newDogs <- melt(as.matrix(dogs))
#class(newDogs)
#names(newDogs) <- c("treatment", "Dog.num", "concentration")
#lapply(newDogs, class)
#newDogs$concentration <- as.numeric(as.character(newDogs$concentration))


# call it newDogs
dogs.aov <- aov(concentration ~ treatment, data = newDogs)
summary(dogs.aov)
TukeyHSD(dogs.aov)
boxplot(concentration ~ treatment, data = newDogs)

#C)
kruskal.test(concentration ~ treatment, data = newDogs)
attach(newDogs)
dunn.test::dunn.test(concentration, treatment, method = "bh", altp = T)
detach(newDogs)
library(FSA)
dunnTest(concentration ~ treatment, data = newDogs, method = "bh")
#D) 
bartlett.test(concentration ~ treatment, data = newDogs) # fails assumption for homogeneity of variance
# Fails test so cannot use ANOVA

#2
# http://www.sthda.com/english/wiki/two-way-anova-test-in-r#what-is-two-way-anova-test
AmusementPark <- read.csv("AmusementPark.csv")
?t.test
t.test(time ~ method, data = AmusementPark) # no difference
summary(aov(time ~ ride, data = AmusementPark)) # no difference
boxplot(time ~ ride, data = AmusementPark)
library(ggpubr)
ggboxplot(AmusementPark, x = "ride", y = "time", color = "method")
ggline(AmusementPark, x = "ride", y = "time", color = "method",
       add = c("mean_se", "dotplot"),
       legend = "bottom")

interaction.plot(x.factor = AmusementPark$ride, trace.factor = AmusementPark$method,
                 response = AmusementPark$time, fun = mean,
                 type = "b", 
                 ylim = c(range(AmusementPark$time)+1*c(-5,5)),
                 xlab = "ride", ylab = "mean time", trace.label = "method",
                 leg.bty = "o",leg.bg = "yellow", main = "Interaction Ride & Method")
labels <- aggregate(AmusementPark$time ~ AmusementPark$ride + AmusementPark$method, FUN = mean)
text(labels$`AmusementPark$ride`, 
     labels$`AmusementPark$time`-1, 
     labels = labels$`AmusementPark$time`,
     col = "blue", cex = 1, font = 4)

anova(lm(time ~ ride + method + ride:method, data = AmusementPark)) # no difference
library(car)
?Anova
Anova(lm(time ~ ride + method + ride:method, data = AmusementPark), type = "II") # no difference

#3
advertising <- read.csv("advertising.csv")
t.test(requests ~ size, data = advertising) # no difference
summary(aov(requests ~ design, data = advertising)) # is difference
boxplot(requests ~ design, data = advertising)
ggboxplot(advertising, x = "design", y = "requests", color = "size")
ggboxplot(advertising, x = "size", y = "requests", color = "design")
ggline(advertising, x = "design", y = "requests", color = "size",
       add = c("mean_se", "dotplot"),
       legend = "bottom")

interaction.plot(x.factor = advertising$design, trace.factor = advertising$size,
                 response = advertising$requests, fun = mean,
                 type = "b", 
                 ylim = c(range(advertising$requests)+1*c(-3,3)),
                 xlab = "design", ylab = "mean requests", trace.label = "size",
                 leg.bty = "o",leg.bg = "pink", main = "Interaction Design & Size")
labels <- aggregate(advertising$requests ~ advertising$design + advertising$size, FUN = mean)
text(labels$`advertising$design`, 
     labels$`advertising$requests`-1, 
     labels = labels$`advertising$requests`,
     col = "blue", cex = 1, font = 4)

Anova(lm(requests ~ size + design + size:design, data = advertising), type = "II") # is difference
TukeyHSD(aov(lm(requests ~ size + design + size:design, data = advertising), type = "II"))

#4
ILBoys <- read.csv("ILBoys.csv")
weight <- ILBoys$Weight
mom.age <- ILBoys$MothersAge

observed <- anova(aov(weight ~ mom.age))$F[1]

n <- length(weight)
B <- 10^4 - 1
results <- numeric(B)

for (i in 1:B)
{
    index <- sample(n)
    weight.perm <- weight[index]
    results[i] <- anova(aov(weight.perm ~ mom.age))$F[1]
}

(sum(results>=observed) + 1) / (B + 1) # P-value
hist(results, xlim=c(0,observed+5), breaks = 50)
abline(v=observed,col="blue")


#4B)
#weight <- ILBoys$Weight
requests <- advertising$requests # response variable
#mom.age <- ILBoys$MothersAge
size <- advertising$size # ind var 1
design <- advertising$design # ind var 12

observed <- anova(aov(requests ~ size*design))$F[1]

n <- length(size)
B <- 10^4 - 1
results <- numeric(B)

for (i in 1:B)
{
    index <- sample(n)
    size.perm <- size[index]
    design.perm <- design[index]
    results[i] <- anova(aov(requests ~ size.perm*design.perm))$F[1]
}

(sum(results>=observed) + 1) / (B + 1) # P-value
hist(results, xlim=c(0,observed+5), breaks = 50)
abline(v=observed,col="blue")

#DENSITY
library(ggplot2)
Fstat_df <- data.frame(Fstat = results)

abline(v=observed,col="blue")
ggplot(Fstat_df, aes(Fstat)) + geom_density()


# brian thinks this is better

requests <- advertising$requests # response variable
size <- advertising$size # ind var 1
design <- advertising$design # ind var 12
observed <- anova(aov(requests ~ size*design))$F[1]

n <- length(size)
B <- 10^4 - 1
results <- numeric(B)

for (i in 1:B)
{
    sampleDataSet <- advertising[sample(nrow(advertising), round(.7*n)), ] # bagging bootstrapping?
    results[i] <- anova(aov(sampleDataSet$requests ~ sampleDataSet$size*sampleDataSet$design))$F[1]
    
}

(sum(results>=observed) + 1) / (B + 1) # P-value
hist(results, xlim=c(0,observed+5), breaks = 1500)
abline(v=observed,col="blue")

# just density $ IMPRESSS
Fstat_df <- data.frame(Fstat = results)
ggplot(Fstat_df, aes(Fstat)) + geom_density(fill = "pink") + geom_vline(xintercept = observed, col = "blue")

