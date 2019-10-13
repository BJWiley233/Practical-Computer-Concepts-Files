library(ggplot2)

#1 
alcohol <- read.csv("Alcohol.csv")
lapply(alcohol, mean)
lapply(alcohol, function(x) sd(x)^2) # assuming equal variances
?t.test
t.test(x = alcohol$sea.level, y = alcohol$high.alt, paired = T, var.equal = T)

plot_data_column <- function (data, column) {
    ggplot2::ggplot(data = data, aes_string(x = column)) +
        geom_density() + xlab(column) + ggtitle(column)
    
}

myplots <- lapply(names(alcohol[-1]),
                  plot_data_column, 
                  data = alcohol[-1])
n <- length(myplots)
nCol <- floor(sqrt(n))
library(gridExtra)
grid.arrange(grobs = myplots, ncol = nCol)

library(ggpubr)
ggplot(stack(alcohol[,-1]), aes(x = ind, y = values)) +
    geom_boxplot() 

# The paired sample t-test has four main assumptions:
# The dependent variable must be continuous (interval/ratio).
# The observations are independent of one another.
# The dependent variable should be approximately normally distributed.
# The dependent variable should not contain any outliers.



#2) 
mathnoise <- read.csv("mathnoise.csv")

par(mfrow = c(2,2))
noise_hi <- stats::density(mathnoise[mathnoise$noise=="hi",]$score)
noise_lo <- stats::density(mathnoise[mathnoise$noise=="lo",]$score)
plot(noise_hi, main = "noise_hi")
plot(noise_lo, main = "noise_lo")
noise_hyper <- stats::density(mathnoise[mathnoise$group=="hyper",]$score)
noise_control <- stats::density(mathnoise[mathnoise$group=="control",]$score)
plot(noise_hyper, main = "noise_hyper")
plot(noise_control, main = "noise_control")


g1 <- ggplot(mathnoise, aes(x = noise, y = score)) +
    geom_boxplot() 
g2 <- ggplot(mathnoise, aes(x = group, y = score)) +
    geom_boxplot() 
myplots <- list(g1, g2)
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, nrow = nCol)

par(mfrow=c(1,1))
interaction.plot(x.factor = mathnoise$group, trace.factor = mathnoise$noise,
                 response = mathnoise$score, fun = mean,
                 type = "b", 
                 ylim = c(range(mathnoise$score)+1*c(-5,5)),
                 xlab = "group", ylab = "score", trace.label = "noise",
                 leg.bty = "o",leg.bg = "yellow", main = "Interaction Noise & Group")
labels <- aggregate(mathnoise$score ~ mathnoise$noise + mathnoise$group, FUN = mean)
text(labels$`mathnoise$group`, 
     labels$`mathnoise$score`-3, 
     labels = labels$`mathnoise$score`,
     col = "blue", cex = 1, font = 4, adj = -.2)

noise_hi <- mathnoise[mathnoise$noise=="hi",]$score
sd(noise_hi)
sds <- mathnoise %>%
        group_by(noise, group) %>%
        summarise(sd(score, na.rm = T))  # all have same sd
aggregate(score ~ noise + group, mathnoise, function(x) c(mean = mean(x), sd = sd(x)))


t.test(x = mathnoise[mathnoise$noise=="hi",]$score,
       y = mathnoise[mathnoise$noise=="lo",]$score, var.equal = T)
t.test(x = mathnoise[mathnoise$group=="hyper",]$score,
       y = mathnoise[mathnoise$group=="control",]$score, var.equal = T) # below .05

mathnoise_tbl <- with(mathnoise, base::tapply(score, list(group=group, noise=noise), mean) )
chisq.test(mathnoise_tbl) # below .05
bartlett.test(score ~ noise * group, data = mathnoise)
aov.noise <- aov(score ~ noise * group, data = mathnoise)
plot(aov.noise, 1)
summary(aov.noise) # group and interaction (makes sense)




#3) 
library(data.table)
library(purrr)
eggprod <- fread("eggprod.csv", select = c(1:3))
eggprod <- eggprod %>% modify_at(-3, as.factor)
#eggprod <- read.csv("eggprod.csv")
# Multi-Factor Between-Subject Designs. See http://onlinestatbook.com/2/research_design/designs.html
# http://onlinestatbook.com/2/glossary/factorial_design.html 
# 3 x 4 or 12 combinations of levels
aggregate(eggs ~ treat, eggprod, function(x) c(mean = mean(x), var = sd(x)^2)) # large diff in variance
aggregate(eggs ~ block, eggprod, function(x) c(mean = mean(x), var = sd(x)^2)) # large diff in variance

g1 <- ggplot(eggprod, aes(x = treat, y = eggs)) +
    geom_boxplot() 
g2 <- ggplot(eggprod, aes(x = factor(block), y = eggs)) +
    geom_boxplot() 
myplots <- list(g1, g2)
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, nrow = nCol)

bartlett.test(eggs ~ treat, data = eggprod)
bartlett.test(eggs ~ block, data = eggprod)

kruskal.test(eggs ~ treat, data = eggprod)
summary(aov(eggs ~ treat, data = eggprod))

kruskal.test(eggs ~ block, data = eggprod)
summary(aov(eggs ~ block, data = eggprod))



aggregate(eggs ~ treat + block, eggprod, function(x) c(mean = mean(x), var = sd(x)^2))
interaction.plot(x.factor = eggprod$treat, trace.factor = eggprod$block,
                 response = eggprod$eggs, fun = mean,
                 type = "b", 
                 ylim = c(range(eggprod$eggs)+1*c(-10,10)),
                 xlab = "treat", ylab = "eggs", trace.label = "block",
                 leg.bty = "o",leg.bg = "yellow", main = "Interaction Block & Treat")
egg_tbl <- with(eggprod, base::tapply(eggs, list(treat=treat, block=block), mean) )
#as.matrix(egg_tbl)
#class(egg_tbl)
friedman.test(egg_tbl)
chisq.test(egg_tbl)
summary(aov(eggs ~ treat*block, data = eggprod)) # need more than 1 data point
TukeyHSD(aov(eggs ~ treat*block, data = eggprod))  # need more than 1 data point

g3 <- ggplot(eggprod, aes(x = "", y = eggs)) +
    geom_boxplot() 
myplots <- list(g1, g2, g3)
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, nrow = nCol)


# 4
chickwts <- read.csv("chickwts.csv")

par(mfrow=c(2,1))
veg <- chickwts[chickwts$diet=="vegetarian", ]$weight
meat <- chickwts[chickwts$diet=="meat", ]$weight
plot(density(veg))
lines(density(meat))

ggplot(chickwts) + geom_density(aes(x = weight,
                                 y = ..density.., colour = diet))

aggregate(weight ~ diet, chickwts, function(x) c(mean = mean(x), var = sd(x)^2)) # large diff in variance


t.test(x = veg, y = meat, var.equal = T)





weight <- chickwts$weight
diet <- chickwts$diet

chick.ttest <- t.test(x = veg, y = meat, var.equal = T)

observed <- chick.ttest$statistic

n <- length(weight)
B <- 10^4 - 1
results <- numeric(B)

for (i in 1:B)
{
    index <- sample(n)
    weight.perm <- weight[index]
    
    newDf <- data.frame(weight=weight.perm, diet=diet)
    vegP <- newDf[newDf$diet=="vegetarian", ]$weight
    meatP <- newDf[newDf$diet=="meat", ]$weight
    results[i] <- t.test(x = vegP, y = meatP, var.equal = T)$statistic
}

(sum(results>=observed) + 1) / (B + 1) # P-value
hist(results)
abline(v=observed,col="blue")

# 5 
