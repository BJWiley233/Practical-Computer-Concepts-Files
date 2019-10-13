library(dplyr)

brand_a <- c(251.2, 245.1, 248.0, 251.1, 265.5, 250.0, 253.9, 244.6, 254.6, 248.8)
brand_b <- c(263.2, 262.9, 265.0, 254.5, 264.3, 257.0, 262.8, 264.4, 260.9, 255.9)
brand_c <- c(269.7, 263.2, 277.5, 267.4, 270.5, 265.5, 270.7, 272.9, 275.6, 266.5)
brand_d <- c(251.6, 248.6, 249.4, 242.0, 246.5, 251.3, 262.8, 249.0, 247.1, 245.9)

brand_df <- data.frame("brand_a" = brand_a, "brand_b" = brand_b, "brand_c" = brand_c, "brand_d" = brand_d)

means <- sapply(brand_df, mean, na.rm = T)
sds <- sapply(brand_df, sd, na.rm = T)
confidence_95 <- sapply(brand_df, function(x){mean(x)+c(-1.96,1.96)*sd(x)/sqrt(length(x))})


mean_a <- means[1] 
mean_b <- means[2]
mean_c <- means[3]
mean_d <- means[4]
sd_a <-sds[1] 
sd_b <- sds[2]
sd_c <- sds[3]
sd_d <- sds[4]

n = 10
df <- 2 * n - 2
t_alpha <- c(-1, 1) * 2.101

mean_ab <- mean_a - mean_b
sp_ab <- sqrt(((n - 1) * sd_a + (n - 1) * sd_b) / df)
ci_ab <- mean_ab + c(-1,1) * 2.101 * sp_ab * (sqrt(1/n + 1/n))
ts_ab <- ((mean_a - mean_b) - 0) / (sp_ab * sqrt(1/n + 1/n))
# is ts_ab inside t values for df = 18 and alpha = .05
diff_ab <- between(ts_ab, t_alpha[1], t_alpha[2])

mean_ac <- mean_a - mean_c
sp_ac <- sqrt(((n - 1) * sd_a + (n - 1) * sd_c) / df)
ci_ac <- mean_ac + c(-1,1) * 2.101 * sp_ac * (sqrt(1/n + 1/n))
ts_ac <- ((mean_a - mean_c) - 0) / (sp_ac * sqrt(1/n + 1/n))
# is ts_ac inside t values for df = 18 and alpha = .05
diff_ac <- between(ts_ac, t_alpha[1], t_alpha[2])


mean_ad <- mean_a - mean_d
sp_ad <- sqrt(((n - 1) * sd_d + (n - 1) * sd_d) / df)
ci_ad <- mean_ad + c(-1,1) * 2.101 * sp_ad * (sqrt(1/n + 1/n))
ts_ad <- ((mean_a - mean_d) - 0) / (sp_ad * sqrt(1/n + 1/n))
# is ts_ad inside t values for df = 18 and alpha = .05
diff_ad <- between(ts_ad, t_alpha[1], t_alpha[2])

mean_bc <- mean_b - mean_c
sp_bc <- sqrt(((n - 1) * sd_b + (n - 1) * sd_c) / df)
ci_bc <- mean_bc + c(-1,1) * 2.101 * sp_bc * (sqrt(1/n + 1/n))
ts_bc <- ((mean_b - mean_c) - 0) / (sp_bc * sqrt(1/n + 1/n))
# is ts_bc inside t values for df = 18 and alpha = .05
diff_bc <- between(ts_bc, t_alpha[1], t_alpha[2])

mean_bd <- mean_b - mean_d
sp_bd <- sqrt(((n - 1) * sd_b + (n - 1) * sd_d) / df)
ci_bd <- mean_bd + c(-1,1) * 2.101 * sp_bd * (sqrt(1/n + 1/n))
ts_bd <- ((mean_b - mean_d) - 0) / (sp_bd * sqrt(1/n + 1/n))
# is ts_bc inside t values for df = 18 and alpha = .05
diff_bd <- between(ts_bd, t_alpha[1], t_alpha[2])

mean_cd <- mean_c - mean_d
sp_cd <- sqrt(((n - 1) * sd_c + (n - 1) * sd_d) / df)
ci_cd <- mean_cd + c(-1,1) * 2.101 * sp_cd * (sqrt(1/n + 1/n))
ts_cd <- ((mean_c - mean_d) - 0) / (sp_cd * sqrt(1/n + 1/n))
# is ts_bc inside t values for df = 18 and alpha = .05
diff_cd <- between(ts_cd, t_alpha[1], t_alpha[2])


# put all in table
comparison <- c("ab", "ac", "ad", "bc", "bd", "cd")
mean_comp <- c(mean_ab, mean_ab, mean_ad, mean_bc, mean_bd, mean_cd)
sps <- c(sp_ab, sp_ac, sp_ad, sp_bc, sp_bd, sp_cd)
ci_low <- c(ci_ab[1], ci_ac[1], ci_ad[1], ci_bc[1], ci_bd[1], ci_cd[1])
ci_high <- c(ci_ab[2], ci_ac[2], ci_ad[2], ci_bc[2], ci_bd[2], ci_cd[2])
t_stats <- c(ts_ab, ts_ac, ts_ad, ts_bc, ts_bd, ts_cd)
diff_in_means <- sapply(c(diff_ab, diff_ac, diff_ad, diff_bc, diff_bd, diff_cd), function (x) {ifelse(x == FALSE, "Yes", "No")})

results <- data.frame("comparison" = comparison, "mean" = mean_comp, "sp" = sps,
                      "ci_low" = ci_low,  "ci_high" = ci_high, "t-stat" = t_stats,
                      "t_alpha_low" = rep(t_alpha[1], 6), "t_alpha_high" = rep(t_alpha[2], 6), 
                      "diff_in_mean" = diff_in_means)
results; means; sds

brand_df$brand_a
t.test(brand_df$brand_a, brand_df$brand_b, alternative = "two.sided", var.equal = FALSE)
?t.test

# t.test uses the Satterthwaite's approximation for degrees of freedom and t statistic
c = (sd_a^2/n)/(sd_a^2/n + sd_b^2/10)
(n-1)^2/((1-c)^2*(n-1) + c^2*(n-1))
ts_ab_Satterthwaite <- ((mean_a - mean_b) - 0) /sqrt((sd_a^2/n) + (sd_b^2/n))
