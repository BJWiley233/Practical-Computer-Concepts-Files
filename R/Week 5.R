# 1)
# Alpha of .01 and 1 sided for 18 df is -.2552
Treated_With_Vitamin_C <- c(5.5, 6.0, 7.0, 6.0, 7.5, 7.5, 5.5, 7.0, 6.5, 6.0)
Treated_With_Placebo <- c(6.5, 6.0, 8.5, 7.0, 6.5, 7.5, 6.5, 7.5, 6.0, 8.0)
brian <- t.test(Treated_With_Vitamin_C, Treated_With_Placebo, alternative = "two.sided", conf.level = .99, var.equal = F)
dofF <- (sd(Treated_With_Vitamin_C)^2/10 + sd(Treated_With_Placebo)^2/10)^2/
        ((sd(Treated_With_Vitamin_C)^2/10)^2/9 + (sd(Treated_With_Placebo)^2/10)^2/9)
mean(Treated_With_Vitamin_C) - mean(Treated_With_Placebo) +c(-1,1) * 
        2.8824*(sqrt(sd(Treated_With_Vitamin_C)^2/10+sd(Treated_With_Placebo)^2/10))

blah <- t.test(Treated_With_Vitamin_C, Treated_With_Placebo, alternative = "less", conf.level = .99)
mean(Treated_With_Vitamin_C) - mean(Treated_With_Placebo) + c(-Inf,1) * 
        2.326*(sqrt(sd(Treated_With_Vitamin_C)^2/10+sd(Treated_With_Placebo)^2/10))

pt(2.555288, df = 17.79)
# Variances are unequal use crazy formula for df
unequalV_df_alpha <- qt(.995, df = dofF)
t.test(Treated_With_Vitamin_C, Treated_With_Placebo, alternative = "two.sided", conf.level = .99, var.equal = F)
mean(Treated_With_Vitamin_C) - mean(Treated_With_Placebo) +c(-1,1) * 
        unequalV_df_alpha*(sqrt(sd(Treated_With_Vitamin_C)^2/10+sd(Treated_With_Placebo)^2/10))
# If varainces are equal just use n1+n2-2
equalV_df_alpha <- qt(.995, df = 18)
t.test(Treated_With_Vitamin_C, Treated_With_Placebo, alternative = "two.sided", conf.level = .99, var.equal = T)
mean(Treated_With_Vitamin_C) - mean(Treated_With_Placebo) +c(-1,1) * 
        equalV_df_alpha*(sqrt(sd(Treated_With_Vitamin_C)^2/10+sd(Treated_With_Placebo)^2/10))

#2 
n = 11
exp_mean <- 94.55
exp_sd <- 14.29
control_mean <- 83.09
control_sd <- 9.25
t_stat2 <- ((exp_mean - control_mean)-0)/sqrt(exp_sd^2/n + control_sd^2/n)
crazy_df <- function(n1, n2, mean_1, mean_2, sd_1, sd_2) {
        (sd_1^2/n1 + sd_2^2/n2)^2/
                ((sd_1^2/n1)^2/(n1-1) + (sd_2^2/n2)^2/(n2-1))
}
num2_df <- crazy_df(n, n, exp_mean, control_mean, exp_sd, control_sd)
qt(.975, num2_df)
CI <- exp_mean - control_mean + c(-1, 1) * qt(.975, num2_df)*sqrt(exp_sd^2/n + control_sd^2/n)
?t.test

#8 at .05
treated <- c(18, 43, 28, 50, 16, 32, 13, 35, 38, 33, 6, 7) 
untreated <- c(40, 54, 26, 63, 21, 37, 39, 23, 48, 58, 28, 39)
ttt <- t.test(treated, untreated, alternative = "less")
ttt$null.value
?t.test
t.test(treated, untreated, alternative = "two.sided")

pchisq(8, 2, lower.tail = F)


lev1.6 <- c(59.5, 53.3, 56.8, 63.1)
lev3.8 <- c(55.2, 59.1, 52.8, 54.5)
lev6 <- c(51.7, 48.8, 53.9, 49.0)
lev10.2 <- c(44.6, 48.5, 41.0, 47.3)
data <- c(lev1.6, lev3.8, lev6, lev10.2)
groups = factor(rep(letters[1:4], each = 4))

library(plyr)
frame <- as.data.frame(cbind(data, groups))
frame$groups <- mapvalues(frame$groups, from = c(1, 2, 3, 4), to = c("lev1.6", "lev3.8", "lev6", "lev10.2"))

fit <- lm(formula = frame$data ~ factor(frame$groups))
anova(fit)

