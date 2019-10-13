library(dplyr)

companyA_NE <- data.frame("Company" = rep("A", 4), "Region" = rep("Northeast", 4), 
                         "Signal_Strength" = c(65.9, 73.9, 70.9, 74.9))
companyA_SE <- data.frame("Company" = rep("A", 4), "Region" = rep("Southeast", 4), 
                          "Signal_Strength" = c(64.0, 61.4, 55.0, 52.1))
companyA_MW <- data.frame("Company" = rep("A", 4), "Region" = rep("Midwest", 4), 
                          "Signal_Strength" = c(55.9, 64.2, 67.2, 74.3))
companyA_W <- data.frame("Company" = rep("A", 4), "Region" = rep("West", 4), 
                          "Signal_Strength" = c(54.7, 69.9, 62.2, 65.5))

companyB_NE <- data.frame("Company" = rep("B", 4), "Region" = rep("Northeast", 4), 
                          "Signal_Strength" = c(71.3, 76.8, 71.4, 65.2))
companyB_SE <- data.frame("Company" = rep("B", 4), "Region" = rep("Southeast", 4), 
                          "Signal_Strength" = c(64.3, 64.0, 61.3, 68.2))
companyB_MW <- data.frame("Company" = rep("B", 4), "Region" = rep("Midwest", 4), 
                          "Signal_Strength" = c(69.4, 68.6, 61.2, 64.9))
companyB_W <- data.frame("Company" = rep("B", 4), "Region" = rep("West", 4), 
                         "Signal_Strength" = c(65.6, 67.8, 55.2, 66.0))

companyC_NE <- data.frame("Company" = rep("C", 4), "Region" = rep("Northeast", 4), 
                          "Signal_Strength" = c(64.0, 64.2, 76.7, 65.1))
companyC_SE <- data.frame("Company" = rep("C", 4), "Region" = rep("Southeast", 4), 
                          "Signal_Strength" = c(60.8, 62.9, 57.0, 69.6))
companyC_MW <- data.frame("Company" = rep("C", 4), "Region" = rep("Midwest", 4), 
                          "Signal_Strength" = c(58.3, 64.4, 69.3, 73.1))
companyC_W <- data.frame("Company" = rep("C", 4), "Region" = rep("West", 4), 
                         "Signal_Strength" = c(62.4, 62.9, 64.5, 71.3))


data_dB <- rbind(companyA_NE, companyA_SE, companyA_MW, companyA_W,
                 companyB_NE, companyB_SE, companyB_MW, companyB_W,
                 companyC_NE, companyC_SE, companyC_MW, companyC_W)


mean_A_NE <- mean(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "Northeast")$Signal_Strength)
mean_A_SE <- mean(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "Southeast")$Signal_Strength)
mean_A_MW <- mean(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "Midwest")$Signal_Strength)
mean_A_W <- mean(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "West")$Signal_Strength)
mean_B_NE <- mean(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "Northeast")$Signal_Strength)
mean_B_SE <- mean(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "Southeast")$Signal_Strength)
mean_B_MW <- mean(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "Midwest")$Signal_Strength)
mean_B_W <- mean(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "West")$Signal_Strength)
mean_C_NE <- mean(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "Northeast")$Signal_Strength)
mean_C_SE <- mean(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "Southeast")$Signal_Strength)
mean_C_MW <- mean(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "Midwest")$Signal_Strength)
mean_C_W <- mean(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "West")$Signal_Strength)

sd_A_NE <- sd(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "Northeast")$Signal_Strength)
sd_A_SE <- sd(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "Southeast")$Signal_Strength)
sd_A_MW <- sd(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "Midwest")$Signal_Strength)
sd_A_W <- sd(subset(data_dB, data_dB$Company == "A" & data_dB$Region == "West")$Signal_Strength)
sd_B_NE <- sd(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "Northeast")$Signal_Strength)
sd_B_SE <- sd(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "Southeast")$Signal_Strength)
sd_B_MW <- sd(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "Midwest")$Signal_Strength)
sd_B_W <- sd(subset(data_dB, data_dB$Company == "B" & data_dB$Region == "West")$Signal_Strength)
sd_C_NE <- sd(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "Northeast")$Signal_Strength)
sd_C_SE <- sd(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "Southeast")$Signal_Strength)
sd_C_MW <- sd(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "Midwest")$Signal_Strength)
sd_C_W <- sd(subset(data_dB, data_dB$Company == "C" & data_dB$Region == "West")$Signal_Strength)

mean_ALL_NE <- mean(subset(data_dB, data_dB$Region == "Northeast")$Signal_Strength)
mean_ALL_SE <- mean(subset(data_dB, data_dB$Region == "Southeast")$Signal_Strength)
mean_ALL_MW <- mean(subset(data_dB, data_dB$Region == "Midwest")$Signal_Strength)
mean_ALL_W <- mean(subset(data_dB, data_dB$Region == "West")$Signal_Strength)

sd_ALL_NE <- sd(subset(data_dB, data_dB$Region == "Northeast")$Signal_Strength)
sd_ALL_SE <- sd(subset(data_dB, data_dB$Region == "Southeast")$Signal_Strength)
sd_ALL_MW <- sd(subset(data_dB, data_dB$Region == "Midwest")$Signal_Strength)
sd_ALL_W <- sd(subset(data_dB, data_dB$Region == "West")$Signal_Strength)

mean_A <- mean(subset(data_dB, data_dB$Company == "A")$Signal_Strength)
mean_B <- mean(subset(data_dB, data_dB$Company == "B")$Signal_Strength)
mean_C <- mean(subset(data_dB, data_dB$Company == "C")$Signal_Strength)
mean_D <- mean(subset(data_dB, data_dB$Company == "D")$Signal_Strength)

sd_A <- sd(subset(data_dB, data_dB$Company == "A")$Signal_Strength)
sd_B <- sd(subset(data_dB, data_dB$Company == "B")$Signal_Strength)
sd_C <- sd(subset(data_dB, data_dB$Company == "C")$Signal_Strength)
sd_D <- sd(subset(data_dB, data_dB$Company == "D")$Signal_Strength)

n4 <- 4
n16 <- 16
df4 <- 2 * n4 - 2 
df16 <- 2 * n16 - 2
t_alpha_4 <- c(-1, 1) * 2.447
t_alpha_16 <- c(-1, 1) * 2.042

#example of Regions by individual Company     
mean_A_NE_SE <- mean_A_NE - mean_A_SE
sp_A_NE_SE <- sqrt(((n4 - 1) * sd_A_NE + (n4 - 1) * sd_A_SE) / df4)
ci_A_NE_SE <- mean_A_NE_SE + t_alpha_4 * sp_A_NE_SE * (sqrt(1/n4 + 1/n4))
ts_A_NE_SE <- (mean_A_NE_SE - 0) / (sp_A_NE_SE * sqrt(1/n4 + 1/n4))
# is ts_A_NE_SE inside t values for df = 6 and alpha = .05
diff_A_NE_SE <- between(ts_A_NE_SE, t_alpha_4[1], t_alpha_4[2])

t.test(companyA_NE$Signal_Strength, companyA_SE$Signal_Strength)

c <- (sd_A_NE^2/n4)/(sd_A_NE^2/n4 + sd_A_SE^2/n4)
df <- (n4-1)^2/((1-c)^2*(n4-1) + c^2*(n4-1))
ts_A_NE_SE_Satterthwaite <- ((mean_A_NE - mean_A_SE) - 0) /sqrt((sd_A_NE^2/n4) + (sd_A_SE^2/n4))
qt(0.975, 5.4999)
t_alpha_4_Satterthwaite <- c(-1, 1) * qt(0.975, 5.4999)
ci_A_NE_SE_Satterthwaite <- mean_A_NE_SE + t_alpha_4_Satterthwaite * sqrt((sd_A_NE^2/n4) + (sd_A_SE^2/n4))

#example of Companies by individual Region   
mean_B_C_MW <- mean_B_MW - mean_C_MW
sp_B_C_MW <- sqrt(((n4 - 1) * sd_B_MW + (n4 - 1) * sd_C_MW) / df4)
ci_B_C_MW <- mean_B_C_MW + t_alpha_4 * sp_B_C_MW * (sqrt(1/n4 + 1/n4))
ts_B_C_MW <- (mean_B_C_MW - 0) / (sp_B_C_MW * sqrt(1/n4 + 1/n4))
# is ts_A_NE_SE inside t values for df = 6 and alpha = .05
diff_B_C_MW <- between(ts_B_C_MW, t_alpha_4[1], t_alpha_4[2])


#example of Regions by ALL Companies    
mean_ALL_NE_W <- mean_ALL_NE - mean_ALL_W
sp_ALL_NE_W <- sqrt(((n16 - 1) * sd_ALL_NE + (n16 - 1) * sd_ALL_W) / df16)
ci_ALL_NE_W <- mean_ALL_NE_W + t_alpha_16 * sp_ALL_NE_W * (sqrt(1/n16 + 1/n16))
ts_ALL_NE_W <- (mean_ALL_NE_W - 0) / (sp_ALL_NE_W * sqrt(1/n16 + 1/n16))
# is ts_ALL_NE_W inside t values for df = 6 and alpha = .05
diff_ALL_NE_W<- between(ts_ALL_NE_W, t_alpha_16[1], t_alpha_16[2])
NE <- subset(data_dB, data_dB$Region == "Northeast")$Signal_Strength
West <- subset(data_dB, data_dB$Region == "West")$Signal_Strength
t.test(NE, West)

#example of Companies by ALL Region   
mean_B_C_ALL <- mean_B - mean_C
sp_B_C_ALL <- sqrt(((n16 - 1) * sd_B + (16 - 1) * sd_C) / df16)
ci_B_C_ALL <- mean_B_C_ALL + t_alpha_16 * sp_B_C_ALL * (sqrt(1/n16 + 1/n16))
ts_B_C_ALL <- (mean_B_C_ALL - 0) / (sp_B_C_ALL * sqrt(1/n16 + 1/n16))
# is ts_A_NE_SE inside t values for df = 6 and alpha = .05
diff_B_C_AL <- between(ts_B_C_ALL, t_alpha_16[1], t_alpha_16[2])
B <- subset(data_dB, data_dB$Company == "B")$Signal_Strength
C <- subset(data_dB, data_dB$Company == "C")$Signal_Strength
t.test(B, C)





