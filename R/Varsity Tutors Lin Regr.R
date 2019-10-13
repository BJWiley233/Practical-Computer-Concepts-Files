library(readxl)
getwd()
data <- read.csv('~/kc_house_data.csv', header = TRUE,
                 sep = ",")

names(data)

nice_houses <- subset(data, data$waterfront == 1, select = c(price, waterfront))

nice_houses %>% arrange(desc(price))
head(data)
add5rows <- tail(data, n = 5L)
add5rows[,1]
new_data <- rbind(data, add5rows)
tail(new_data[,1], n = 10)
new_data <- head(new_data, -5)


summary(data)
colnames(data)

price <- data$price
space <- data$sqft_living

model <- lm(price ~ space)
model$coefficients[1]

pdf("Figure.pdf")
plot(space, price, pch = 16, cex = 1.3, col = "blue", 
     main = "Price base on SF", 
     xlab = "Square Feet", ylab = "Price")
dev.off()

abline(model$coefficients[1], model$coefficients[2])


m <- matrix(c(4,1,3,2,0,1,2,4,5,4,5,3), nrow = 4, byrow = T)

xbar <- matrix(c(-5,-3,0,1,-2,-2,1,2,2,3,3,0), nrow = 4, byrow = T)

#.9 + .8  - (1 - (P(M) + P(F) - P(M & F))) 
.9 + .8  - (1 - (.1 + .2 - .04)) 

?dnorm
qnorm(.90, 0, 1)
qnorm(.95, 0, 1, lower.tail = F)
qnorm(.95, 0, 1, lower.tail = T)
?qbinom()
qbinom(.5, 20, .7)
1-pbinom(7, 10, .5)

m <- matrix(c(1,-1,2,-2,3,-3), nrow = 3) 



pnorm(1) - pnorm(-1)

pnorm(2400, mean = 2000, sd = 200) - pnorm(2000, mean = 2000, sd = 200)

n = 25
u = 8
sd = 2
z = (8 + .2*c(-1,1) - 8)/(2/sqrt(25))
pnorm(z)
diff(pnorm(z))
