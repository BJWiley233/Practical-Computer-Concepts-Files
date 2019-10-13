# 1 https://mgimond.github.io/Stats-in-R/ChiSquare_test.html
#H0: variables are dependent
#Ha: variables are independent
#https://www.chegg.com/homework-help/questions-and-answers/use-traditional-approach-p-value-approach-hypothesis-testing-1-test-notion-alcoholics-soci-q5600545
Married <- c(21, 37, 58)
Not_Married <- c(59, 63, 42)
df_AA <- rbind(Married, Not_Married)
colnames(df_AA) <- c("Diagnosed", "Undiagnosed", "Nonalcoholic")
chisq.test(df_AA)$observed
chisq.test(df_AA)$expected
sum((chisq.test(df_AA)$observed - chisq.test(df_AA)$expected)^2/chisq.test(df_AA)$expected)

# 2
n <- 850
sample_proportion <- 400/850
hyp_prop <- .50
SE <- hyp_prop/sqrt(n)
p_diff <- sample_proportion - hyp_prop
t_stat <- (sample_proportion - hyp_prop) / SE
critical_value <- qt(.05, df = 848, lower.tail = T)
t_stat < critical_value
p_value_tstat <- pt(t_stat, df = 848, lower.tail = T)
p_value_tstat < .05

#3
n3 <- 144
sample_proportion_R <- 30/144
hyp_prop_R <- .25
SE_R <- hyp_prop_R/sqrt(n3)
p_diff <- sample_proportion_R - hyp_prop_R
t_stat_R <- (sample_proportion_R - hyp_prop_R) / SE_R
critical_values <- c(-1, 1) * qt(.01, df = n3-1, lower.tail = F)
between(t_stat_R, critical_values[1], critical_values[2])
p_value_tstat_R <- pt(t_stat_R, df = n3-1, lower.tail = T)
p_value_tstat < .01
# We can repeat this for the other two or do a Chi-square
Observed <- c(30, 78, 36)
Expected <- c(36, 72, 36)
combine <- as.matrix(rbind(Observed, Expected))
combine_test <- as.matrix(cbind(Observed, Expected))
chi_statistic <- sum(apply(combine, 2, function(x) {diff(x)^2/x[2]}))

# chi stat table https://www.itl.nist.gov/div898/handbook/eda/section3/eda3674.htm
chi_stat_critical <- qchisq(.99, df = 3-1, lower.tail = T)
chi_statistic < chi_stat_critical
pchisq(1.5, df=2, lower.tail=FALSE)
pchisq(chi_stat_critical, df=2, lower.tail=FALSE)
sum(Observed)
chisq.test(Observed, p = Expected/sum(Observed))

#4
#HO: p1 = p2 there is no difference
#Ha: p1 > p2 there is a greater marketability for ionizing
nbulbs <- 180
p1hat <- 153/nbulbs
p2hat <- 117/nbulbs
# https://stattrek.com/hypothesis-test/difference-in-proportions.aspx
# Pooled sample proportion. Since the null hypothesis states that P1=P2, we use a pooled sample proportion (p) to compute the standard error of the sampling distribution.
# p = (p1 * n1 + p2 * n2) / (n1 + n2)
pooledProp <- (p1hat * nbulbs + p2hat * nbulbs) / (nbulbs + nbulbs)
# Standard error. Compute the standard error (SE) of the sampling distribution difference between two proportions.
# SE = sqrt{ p * ( 1 - p ) * [ (1/n1) + (1/n2) ] }
SE_4 <- sqrt((pooledProp * (1-pooledProp)) * (1/nbulbs + 1/nbulbs))
z_alpha <- qt(.05, df = nbulbs*2 - 2, lower.tail = F)
qnorm(.05, lower.tail = F)
# z-alpha = 1.645, z-stat is (p1hat - p2hat)/SE
z_stat_bulbs <- (p1hat - p2hat) / SE_4
z_stat_bulbs > z_alpha


#5
n5 <- 369
sample_proportion5 <- 23/n5
t_values5 <- c(-1, 1) * qt(.025, df = n5-1, lower.tail = F)
z_values5 <- c(-1, 1) * qnorm(.025, lower.tail = F)
SE_5 <- sqrt(sample_proportion5*(1-sample_proportion5)/n5)
critical_values5 <- sample_proportion5 + z_values5 * SE_5
critical_values5 * 100

#6
# chi-square for .05 alpha and 3x2 matrix is X(.05)(3-1)(2-1) = 5.991
m <- matrix(c(.13, .19, .28, .07, .11, .22), nrow = 2, byrow = T)
t$chisq.test(m)
chisq.test(m)$observed
chisq.test(m)$expected
minNum <- ceiling(5.991/t$statistic)
mMin <- minNum * m
chisq.test(mMin)

#7 A hypothesis test will be performed to test the claim that a 
# population proportion is less than 0.70. A sample size of 400 
# and significance level of 0.01 will be used.  If ??????= 0.63, find 
# the probability of making a type II error, ??. 

# Null hypothesis Ho: p = .70
# Alternative Ha: p < .70
p7 <- .7
n7 <- 400
alpha7 <- .01
z_stat7 <- qnorm(alpha7, lower.tail = T)
SE <- sqrt(p7*(1-p7)/n7)
# reject Null Hypothesis if (phat - .7 / SE < z_stat7) solve for phat
phat <- z_stat7 * SE + p7
# reject Null if phat < 0.6466967 so we accept Null if phat > 0.6466967
# P(Accept or Fail to Reject Null | Null is False) = P (phat > .6466967 | p = . 63)
# This means P(Z score > zscore for p = .63)
z_score_for_p_equals_.63 <- (phat - .63)/sqrt(.63*(1-.63)/400)
# p(Z > .69)
pnorm(.69, lower.tail = F)
