install.packages("lattice")
require(lattice)

alcohol1 <- read.table("https://stats.idre.ucla.edu/stat/r/examples/alda/data/alcohol1_pp.txt", header=T, sep=",")
?attach
length(unique(alcohol1$id))
xyplot(alcuse ~ age | id,
       data = alcohol1[alcohol1$id %in% c(1,2,3,4,8,80,81,82,83), ],
       panel = function(x,y){
               panel.xyplot(x,y)
               panel.lmline(x,y)
       }, ylim = c(-1,4), as.table = T)

nrow(alcohol1[alcohol1$coa==0, ])
nrow(alcohol1)
nrow(alcohol1[alcohol1$coa==1, ])

alcohol1.coa0 <- alcohol1[alcohol1$coa==0, ]
f.coa0 <- by(alcohol1.coa0, alcohol1.coa0$id,
            function(x) fitted(lm(alcuse ~ age, data = x)))
f.coa0 <- unlist(f.coa0)
names(f.coa0) <- NULL

Tinteraction.plot(alcohol1.coa0$age, alcohol1.coa0$id, f.coa0, xlab = "age", 
                 ylab = "alcuse", ylim = c(-1,4), lwd =1, legend = T)
?interaction.plot

plot(1:3, rnorm(3), pch = 1, lty = 1, type = "o", ylim=c(-2,2))
lines(1:3, rnorm(3), pch = 2, lty = 2, type="o")

Tinteraction.plot(alcohol1.coa0$age, alcohol1.coa0$id, f.coa0, xlab = "age", 
ylab = "alcuse", ylim = c(-1,4), lwd =1, legend = T)
title("COA=0")
###Upper right pannel coa = 1

alcohol1.coa1 <- alcohol1[alcohol1$coa==1, ]
f.coa1 <- by(alcohol1.coa1, alcohol1.coa1$id,
             function(x) fitted(lm(alcuse ~ age, data = x)))
f.coa1 <- unlist(f.coa1)
names(f.coa1) <- NULL

Tinteraction.plot(alcohol1.coa1$age, alcohol1.coa1$id, f.coa1, xlab = "age", 
                 ylab = "alcuse", ylim = c(-1,4), lwd =1, legend = T)
title("COA=1")

mean((alcohol1$peer))
alcohol1.lowpeer <- alcohol1[alcohol1$peer<=mean((alcohol1$peer)), ]
f.lowpeer <- by(alcohol1.lowpeer, alcohol1.lowpeer$id,
                function(x) fitted(lm(alcuse ~ age, data = x)))
f.lowpeer <- unlist(f.lowpeer)
names(f.lowpeer) <- NULL
Tinteraction.plot(alcohol1.lowpeer$age, alcohol1.lowpeer$id, f.lowpeer, xlab = "age", 
                  ylab = "alcuse", ylim = c(-1,4), lwd =1, legend = T)

title("Low Peer")
par(mfrow = c(2,2))

alcohol1.hipeer <- alcohol1[alcohol1$peer>mean((alcohol1$peer)), ]
f.hipeer <- by(alcohol1.hipeer, alcohol1.hipeer$id,
                function(x) fitted(lm(alcuse ~ age, data = x)))
f.hipeer <- unlist(f.hipeer)
names(f.hipeer) <- NULL
Tinteraction.plot(alcohol1.hipeer$age, alcohol1.hipeer$id, f.hipeer, xlab = "age", 
                  ylab = "alcuse", ylim = c(-1,4), lwd =1, legend = T)

title("High Peer")
par(mfrow = c(2,2))

library(nlme)
model.a <- lme(alcuse ~ 1, alcohol1, random = ~1 | id)
summary(model.a)
?lme
model.f <- lme(alcuse ~ coa+cpeer*age_14 , data=alcohol1, random= ~ age_14 | id, method="ML")
resid <- residuals(model.a)
qqnorm(resid)
par(mfrow = c(1,2))
A <- runif(100,4,16)
y <- A + matrix(rnorm(1000*3,sd=0.2),1000,3)
status <- rep(c(0,-1,1),c(950,40,10))
y[,1] <- y[,1] + status
plot(y[,1],y[,2])
plot((y[,2]+y[,1])/2,y[,2]-y[,1])
install.packages("FSA")
library(FSA)  # provides WhitefishLC, col2rgbt()
data(WhitefishLC)
str(WhitefishLC)
library(dplyr)
WhitefishLC <- mutate(WhitefishLC,meanSO=(scaleC+otolithC)/2,diffSO=scaleC-otolithC)
head(WhitefishLC)
plot(diffSO~meanSO,data=WhitefishLC,col="white",
     xlab="Mean Age",ylab="Scale-Otolith Age")
meandiff <- 2.88
sddiff<- 7.61
n <- 49
testStat <- sqrt(n)*meandiff/sddiff
testStat

2*pt(abs(testStat), n-1,lower.tail = F)
?pnorm

pnorm(5)
qnorm(.95)-((12-11.34)/4)
1-pnorm(1.479854)
pnorm(qnorm(.05)-(sqrt(16)*(32-30)/4))

pharm <- data.frame(baseline=c(140,138,150,148,135), week2=c(132,135,151,146,130))
diff <- pharm$week2 - pharm$baseline
n = 5
testStat <- sqrt(n) * mean(diff)/sd(diff)
2* pt(abs(testStat), n - 1, lower.tail = F)
t.test(pharm$baseline, pharm$week2, alternative = "two.sided", paired = T)

avg <- 1100
sd <- 30
n = 9
avg + c(-1,1)*qt(.975, n-1)*sd/sqrt(n)


quantile = 0.975 # is 95% with 2.5% on both sides of the range

n_y <- 16 # nights new system
n_x <- 16 # nights old system
var_y <- 20^2 # variance new (sqrt of ??)
var_x <- 28^2 # variance old (sqrt of ??)
??_y <- 11# average hours new system
??_x <- 4# average hours old system

meandiff <- ??_y - ??_x
sp <- sqrt(mean(c(var_y, var_x)))
se <- sp * sqrt(1/n_y+1/n_x)
tstat <- meandiff/se
2* pt(tstat, n_y + n_x -2)


(-1.96, mean = 2, sd = 1) + pnorm(1.96, mean = 2, sd = 1
# calculate pooled standard deviation
??_p <- sqrt(((n_x - 1) * var_x + (n_y - 1) * var_y)/(n_x + n_y - 2))
confidenceInterval <- ??_y - ??_x + c(-1, 1) * qt(quantile, df=n_y+n_x-2) * ??_p * (1 / n_x + 1 / n_y)^.5


matrix(c(8, 5, 1, ???2, 0, ???1, 0, 7, 1, 6, 0, 8, 6, 5, ???3, 1, 2, 5, ???8, 4, 2, 6, ???2, 0, 6), nrow = 5, byrow = T)
det

#In a random sample of 100 patients at a clinic, you would like to test whether 
#the mean RDI is x or more using a one sided 5% type 1 error rate. 
#The sample mean RDI had a mean of 12 and a standard deviation of 4. 
#What value of (testing versus ) would you reject for?
qnorm(.95, lower.tail = T)
qnorm(.05)
sqrt(100)*12/4

n = 100
type_1_error = .05 # 1 side
sample_mean = 12
sample_sd = 4
test_means = c(12.66,10.84,11.34,9.30)
sapply(
        test_means,
        function(test_mean){
                round(pnorm(q=sample_mean,mean=test_mean,sd=sample_sd/sqrt(n),lower.tail=F),7)
        }
)
sqrt(100)*(12-11.34)/4
pnorm(sqrt(100)*(12-12)/4)

test1 <- c(140,138,150,148,135)
test2 <- c(138,136,148,146,133)
diff <- test2-test1
diff
n <- sum(!is.na(diff))
n <- 9
mean(diff)
sd(test1)
sd(test2)
tstat <- sqrt(n) * mean(diff) / sd(diff)
tstat <- 
2*pt(abs(tstat), n + n - 2, lower.tail = F)
t.test(diff,paired = F)
pharm <- data.frame(baseline=c(140,138,150,148,135), week2=c(138,136,148,146,133))

t.test(pharm$baseline,pharm$week2, alt = "two.sided", paired=F)
?t.test

s <- 'AAGGCCTT'
?pt()
nT <- nC <- 9 
meanTreated <- -3
meanControl <- 1
sdTreated <- 1.5
sdControl <- 1.8
sp <- sqrt((sdTreated^2+sdControl^2)/2)
tstat <- (meanTreated-meanControl)/(sp*sqrt(1/nT+1/nC))
2*pt(abs(tstat), nC - 1, lower.tail = F)
((1.645+1.28)*4)^2

u <- 2
sd <- 12
p <- .10
pow <- NULL
n <- power.t.test(n = 288, power = NULL, delta = u, sd = sd, sig.level = p, 
                  type = "one.sample", alt = "two.sided")

n$power
(choose(5,3)+choose(5,4)+choose(5,5))* .1^x*.9^(n-x)
x = 3
n = 5
a <- c()
for (i in x:n) {
        s <- choose(n,i) 
        a <- append(a,s,length(a))
}

sum(a) 16 * .1^x*.9^(n-x)       
pbinom(2,5,.1, lower.tail = F)
pbinom
binom.test(3,5,.1,alternative = "greater")
binom.test
.00856/0.00081
?qunif
