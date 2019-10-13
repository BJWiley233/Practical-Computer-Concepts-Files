# I categories =
bc_matrix <- matrix(c(.41*144, .59*144, .522*209, .478*209, .596*89, .404*89), nrow = 3,
                    byrow = T)
colSums(bc_matrix)
rowSums(bc_matrix)
rownames(bc_matrix) <- c('alone', 'w/spouse', 'w/others')
colnames(bc_matrix) <- c('advanced', 'local')
bc_chisq <- chisq.test(bc_matrix)
bc_chisq$expected
pchisq(bc_chisq$statistic, bc_chisq$parameter, lower.tail = F)
write.csv(bc_matrix, file = "bc_matrix.csv")

#2 
# I categories, where I = 1, J populations where j = 3
# df = (7-1)(2-1) should equal in chisq.test
fish_matrix <- matrix(c(14,30,42,78,33,14,11,28,53,
                      66,27,9,10,17,61,53,22,10), nrow = 3,
                    byrow = T)
rownames(fish_matrix) <- c("Guadalupe_Island",
                           "cedros_Island",
                           "San Clemente Islands")
colnames(fish_matrix) <- c(">=36","35","34","33","32","<=31")
# one variable 3 populations, test for homogeneity
# ho: pi1 =pi2 =pi3 = pi_i, for i =1
fish_chisq <- chisq.test(fish_matrix)

#3 cereals
cereal <- read.csv("Cereals.csv")
cereal_table <- table(cereal[,2:3])                           
sum(cereal_table)
cereal_chisq <- chisq.test(cereal_table)
cereal_chisq$expected #less than 5
chisq.test(cereal_table, simulate.p.value = TRUE)                          
#The issue is that the chi-square approximation to the distribution of the test statistic relies on the counts being roughly normally distributed. If many of the expected counts are very small, the approximation may be poor.                           
plot(density(cereal_table))  
fisher.test(cereal_table)
     
age <- cereal$Age
shelf <- cereal$Shelf
table_cereal <- table(data.frame(cereal$Age, cereal$Shelf))
shelf.chisq <- chisq.test(table_cereal)

observed <- shelf.chisq$statistic

n <- length(age)
B <- 10^4 - 1
results <- numeric(B)

for (i in 1:B)
{
    index <- sample(n)
    shelf.perm <- shelf[index]
    
    new_table <- table(data.frame(age=age, shelf=shelf.perm))
    results[i] <- chisq.test(new_table, simulate.p.value = TRUE)$statistic
}

(sum(results>=observed) + 1) / (B + 1) # P-value
hist(results, xlim=c(0,observed+5))
abline(v=observed,col="blue")     



#4
#a) 
#i. 
2/10     
#ii. 
5/10
#iii.
(5/10)/(2/10)
#iii
((5/10)/(1-5/10))/((2/10)/(1-2/10))   
drug_matrix <- matrix(c(2,8,5,5), nrow = 2, byrow = T)
colnames(drug_matrix) <- c("Disease", "No_Disease")
rownames(drug_matrix) <- c("Drug", "Placebo")
chisq.test(drug_matrix)$expected # under 5
drug_fisher <- fisher.test(drug_matrix, alternative = "less")
?phyper
phyper(2,10,10,7)
choose(10,2)*choose(10,7-2)/choose(20, 7) +
    choose(10,1)*choose(10,7-1)/choose(20, 7) +
    choose(10,0)*choose(10,7-0)/choose(20, 7)


#5
bacteria <- cbind(numb_col=c(0,1,2,3,4,5,6,7,8,9,10,19), num_obs=c(56,104,80,62,42,27,9,9,5,3,2,1))
lambda <- sum(apply(bacteria, 1, prod))/sum(bacteria[,2])
p_is <- sapply(bacteria[,1], function(x) ifelse(x>0, 
                                                round(ppois(x, lambda = lambda)-ppois(x-1, lambda = lambda),5),
                                                round(ppois(x, lambda = lambda),5)))
bacteria_new <- data.frame(bacteria, p_is)
sum(bacteria_new$num_obs)
bacteria_new$E_i <- round(bacteria_new$p_is*400,3)

bacteria_group8 <- apply(bacteria_new[bacteria_new$numb_col>=7,][-1], 2, sum)
finaldf <- data.frame(rbind(bacteria_new[1:7,], c(">=7",bacteria_group8)))
finaldf[,2:4] <- sapply(finaldf[,2:4], as.numeric)

apply(finaldf[,c(2,4)], 1, function(x) x)
#chisq_stat <- sum(apply(finaldf[,c(2,4)], 1, function(x) (x[1]-x[2])^2/x[2]))
chisq.test(finaldf$num_obs, correct=F, p=finaldf$E_i/sum(finaldf$E_i))
pchisq(chisq_stat, df=nrow(finaldf)-1-1,lower.tail = F)
library(ggplot2)
ggplot(data=bacteria_new,aes(x=numb_col))+
    geom_bar(aes(y=num_obs),stat="identity",position ="identity",alpha=.3,fill='lightblue4',color='blue') +
    geom_bar(aes(y=E_i),stat="identity",position ="identity",alpha=.8,fill='pink',color='red')
library(reshape2)
data_long <- melt(bacteria_new[,c(1,2,4)], id.vars = "numb_col")
ggplot(data=data_long,aes(x=numb_col, y = value, fill=variable, color = variable, alpha=variable)) +
    geom_bar(stat="identity", position = "identity") +
    scale_color_manual(values = c('blue', 'red')) +
    scale_fill_manual(values = c('lightblue4', 'pink')) +
    scale_alpha_manual(values = c(.3, .8))

phillies <- read.csv("Phillies2009.csv", stringsAsFactors = F)
doubles <- data.frame(table(phillies$Doubles))
names(doubles)[1] <- "doubles"
doubles$doubles <- as.numeric(doubles$doubles)
lambda_doubles <- sum(apply(doubles, 1, prod))/sum(doubles[,2])
doubles_p_is <- sapply(doubles[,1], function(x) ifelse(x>0, 
                                                round(ppois(x, lambda = lambda_doubles)-ppois(x-1, lambda = lambda_doubles),5),
                                                round(ppois(x, lambda = lambda_doubles),5)))
sum(doubles_p_is)
doubles$p_is <- doubles_p_is
bacteria_new$E_i <- round(bacteria_new$p_is*400,3)
doubles$expected <- round(doubles$p_is*sum(doubles$Freq), 3)
chisq.test(doubles$Freq, correct=F, p=doubles$expected/sum(doubles$expected))
new_doubles <- melt(doubles[,c(1,2,4)], id.vars = "doubles")
ggplot(data=new_doubles,aes(x=doubles, y = value, fill=variable, color = variable, alpha=variable)) +
    geom_bar(stat="identity", position = "identity") +
    scale_color_manual(values = c('blue', 'red')) +
    scale_fill_manual(values = c('lightblue4', 'pink')) +
    scale_alpha_manual(values = c(.3, .8))


#6
sample_data <- read.csv("SampleData.csv", stringsAsFactors = F)

plot(density(sample_data$data), xlim = 25 + c(-1,1)*25)
abline(v=mean(sample_data$data), col = "blue", lw = 2)
abline(v=median(sample_data$data), col = "red")
x=seq(25 + c(-1,1)*25,length=200)
y=dnorm(x,mean=25,sd=10)
lines(x,y,type="l",lwd=2,col="green")

qts <- qnorm(c(.2, .4, .6, .8), mean = 25, sd = 10)
expected <- rep(nrow(sample_data)/6, 6)
observed <- vector()
observed <- append(observed, sum(sample_data$data < qts[1]))
observed <- append(observed, sum(sample_data$data >= qts[1] & sample_data$data < qts[2]))
observed <- append(observed, sum(sample_data$data >= qts[2] & sample_data$data < 25))
observed <- append(observed, sum(sample_data$data >= 25 & sample_data$data < qts[3]))
observed <- append(observed, sum(sample_data$data >= qts[3] & sample_data$data < qts[4]))
observed <- append(observed, sum(sample_data$data >= qts[4]))
sum(observed)
chisq.test(observed, correct=F, p=expected/sum(expected)) # reject


qts_unk <- qnorm(c(.2, .4, .6, .8), mean = mean(sample_data$data), sd = sd(sample_data$data))
observed_unk <- vector()
observed_unk <- append(observed_unk, sum(sample_data$data < qts_unk[1]))
observed_unk <- append(observed_unk, sum(sample_data$data >= qts_unk[1] & sample_data$data < qts_unk[2]))
observed_unk <- append(observed_unk, sum(sample_data$data >= qts_unk[2] & sample_data$data < mean(sample_data$data)))
observed_unk <- append(observed_unk, sum(sample_data$data >= mean(sample_data$data) & sample_data$data < qts_unk[3]))
observed_unk <- append(observed_unk, sum(sample_data$data >= qts_unk[3] & sample_data$data < qts_unk[4]))
observed_unk <- append(observed_unk, sum(sample_data$data >= qts_unk[4]))
sum(observed_unk)
chisq.test(observed_unk, correct=F, p=expected/sum(expected)) # do not reject

hist(sample_data$data)
qqnorm(sample_data$data, pch = 1, frame = FALSE)
qqline(sample_data$data, col = "steelblue", lwd = 2)

#
mcnemar.test
disease_2 <- matrix(c(1097, 90, 203, 435), nrow = 2, byrow = T)
p11 <- disease_2[1][1]/sum(disease_2)
p00 <- 
chisq.test(disease_2)
chisq.test(disease_2)$expected
sum((disease_2 - chisq.test(disease_2)$expected)^2/chisq.test(disease_2)$expected)
test.stat <- (90-203)^2/(90+203)
pchisq(test.stat, df = 1, lower.tail = F)
mtest <- mcnemar.test(disease_2, correct = F)
mcnemar.test

octopods <- read.csv("octopods.csv")
sapply(octopods, class)
plot(density(octopods$X110))

par(mfrow=c(1,2))
plot(density(octopods$X110))
plot(density(log(octopods$X110)))

log(2.73)
