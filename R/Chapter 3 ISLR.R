library(ISLR)
Advertising <- read.csv("Advertising.csv")
summary(lm(sales ~ TV, data = Advertising))
plot(Advertising$TV, Advertising$sales)
abline(lm(sales ~ TV, data = Advertising), col = "blue", lw = 2)
mean(Advertising$sales)
stats::cor(Advertising[,c("TV", "sales")])^2

summary(lm(sales ~ radio, data = Advertising))
summary(lm(sales ~ newspaper, data = Advertising))

summary(glm(sales ~ ., data = Advertising[,-1]))
stats::cor(Advertising[,c(-1)])^2
test_glm <- lm(sales ~ ., data = Advertising[,-1])
summary(test_glm)
stats::cor(Advertising[,"sales"], test_glm$fitted.values)^2

tv_radio <- lm(sales ~ TV + radio, data = Advertising[,-1])
summary(tv_radio)
confint(tv_radio)
predict(test_glm, data.frame(TV=100000, radio=20000, newspaper=0), interval = "confidence") + test_glm$coefficients[1]*1000
tv_radio$coefficients[1]*1000
?predict
confint(test_glm)

confint(test_glm)[5]*1000 + 100000*confint(test_glm)[6]+20000*confint(test_glm)[7]
confint(tv_radio)[1]*1000 + 100000*confint(tv_radio)[5]+20000*confint(tv_radio)[6]

credit <- read.csv("Credit.csv")
credit$mf <- ifelse(credit$Gender=="Female", 1, 0)
summary(lm(Balance~mf, data = credit))
library(fastDummies)
dummy <- dummy_cols(credit, select_columns = "Ethnicity")
summary(lm(Balance~Ethnicity_Caucasian + Ethnicity_Asian, data = dummy))
summary(lm(Balance~Ethnicity_Caucasian + Ethnicity_Asian + `Ethnicity_African American`, data = dummy))


tv_radio <- lm(sales ~ TV * radio, data = Advertising[,-1])
summary(tv_radio)
credit$studentYN <- ifelse(credit$Student=="Yes", 1, 0)
student <- lm(Balance~Income+studentYN, data = credit)
plot(student$fitted.values, student$residuals)
x = seq(0,150,.01)
y = 211.143 + 5.984*x
plot(x, y, xlim = c(-5,150), ylim = c(0,1400), type="l")
y2 = 211.143 + 382.6705 + 5.984*x
lines(x, y2)



plot(x, y2, xlim = c(-5,150), ylim = c(0,1500), type="l", yaxt="n")
lines(x, y)

ticks<-c(200,600,1000,1400)
minors <- c(200,400,600,800, 1000, 1200, 1400)
axis(2,at=minors,labels=F)
axis(2,at=ticks,labels=ticks)

abline
?plot.new()
library(oceanmap)
empty.plot(axes = T, xlim = c(-5,150), ylim = c(0,1400))
abline(a = 211.1430, b = 5.9843, lw = 2)
abline(a = 211.1430+382.6705, b = 5.9843, xlim = c(0,150))
plot(lm(Balance~Income+studentYN, data = credit))
?abline

Auto <- read.csv("Auto.csv", stringsAsFactors = F, na.strings = "?")
Auto <- Auto[!is.na(Auto$horsepower), ]
sapply(Auto, class)
auto.lm <- lm(mpg ~ horsepower, data = Auto)
plot(Auto$horsepower, Auto$mpg)
auto.lm$coefficients
abline(auto.lm$coefficients[1], auto.lm$coefficients[2], col = "orange", lw = 2.5)

model <- lm(mpg ~ poly(horsepower, 2, raw=T), data = Auto)
summary(model5)
plot(Auto$horsepower, Auto$mpg, xlim=c(-20, max(Auto$horsepower)), ylim=c(-40, max(Auto$mpg)))
abline(auto.lm$coefficients[1], auto.lm$coefficients[2], col = "orange", lw = 2.5)

x = seq(0, max(Auto$horsepower), .01)
pred <- predict(model, newdata=data.frame(horsepower=x))
lines(x, pred, col = "lightblue")
model5 <- lm(mpg ~ poly(horsepower, 5, raw=T), data = Auto)
pred5 <- predict(model5, data.frame(horsepower=x))
lines(x, pred5, col = "green")

abline(v=0, h = -3.223e+01)
plot(auto.lm)
abline(h=0)
plot(auto.lm$fitted, auto.lm$residuals)
plot(auto.lm$fitted, rstandard(auto.lm)) 
leverage.plot(auto.lm)
par(mfrow = c(1, 2))
plot(auto.lm, which = 1)
plot(model5, which = 1)
plot(model5$fitted.values, model5$residuals)
summary(model5)
summary(auto.lm)

attach(galton)
install.packages("alr3")
library(alr3)
attach(galtonpeas)
model.1 <- lm(Progeny ~ Parent)
summary(model.1)
head(galtonpeas)

model.2 <- lm(Progeny ~ Parent, weights=1/SD^2)
summary(model.2)
#             Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 0.127964   0.006811  18.787 7.87e-06 ***
# Parent      0.204801   0.038155   5.368  0.00302 ** 
par(mfrow = c(1,1))
plot(x=Parent, y=Progeny, ylim=c(0.158*100,0.174*100),
     panel.last = c(lines(sort(Parent), fitted(model.1)[order(Parent)], col="blue"),
                    lines(sort(Parent), fitted(model.2)[order(Parent)], col="red")))
legend("topleft", col=c("blue","red"), lty=1,
       inset=0.02, legend=c("OLS", "WLS"))

detach(galtonpeas)
