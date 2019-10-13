# 1

# Ho: p(x) = exp(-lambda)*lambda^x/x!
library(dplyr)
armadillo <- read.csv("armadillos.csv")
count_arm <- armadillo %>%
                group_by(Roadkills) %>%
                summarise(count = n())
sum(count_arm$count)
lambda <- sum(apply(count_arm, 1, prod))/sum(count_arm[,2])
