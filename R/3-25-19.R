library(reshape2)
library(tidyr)
library(dplyr)
library(readr)
library(tidyverse)
install.packages("ggpubr")
library(ggpubr)

Female <- c(26, 25, 33, 35, 35, 28, 30, 29, 61, 32, 33, 45)
ggdensity(as.data.frame(Female)$Female, main = "Female", xlab = "age")
Male <- c(46, 40, 36, 47, 29, 43, 37, 38, 45, 50, 48, 60)
Not_Indicated <- c(runif(length(Female), 15, 100))
ggdensity(Not_Indicated, main = "NI", xlab = "age")

genders <- c("Female", "Male") 
par(mfrow = c(1, 3))
boxplot(Female, horizontal = FALSE, main = "Female", xlab = "Age") 
boxplot(Male, horizontal = FALSE, main = "Male", xlab = "Age") 
boxplot(Not_Indicated, horizontal = FALSE, main = "Not_Indicated", xlab = "Age") 

data <- data.frame(female = Female, male = Male, not_indicated = Not_Indicated)

?pivot_longer
?melt
remove.packages("devtools")
install.packages("devtools")
library(devtools)
devtools::
build_github_devtools()
library(pkgbuild)
devtools::install_github("tidyverts/fable")
library(remotes)
remotes::install_github("tidyverse/tidyr")
update.packages(ask = FALSE)
devtools::install_github("r-lib/devtools")
find_rtools()
Sys.setenv(PATH = paste("C:/Rtools/bin", Sys.getenv("PATH"), sep=";"))
Sys.setenv(BINPREF = "C:/Rtools/mingw_$(WIN)/bin/")
Sys.getenv("BINPREF")
newdata <- data %>%
        tidyr::pivot_longer(
                cols = c('female', 'male', 'not_indicated'),
                names_to = 'sex',
                values_to = 'age',
                na.rm = TRUE
        )
ggboxplot(newdata, x = "sex", y = "age", 
          color = "sex", palette = c("#00AFBB", "#E7B800", "#FC4E07"),
          order = c("male", "female", "not_indicated"),
          ylab = "age", xlab = "sex")
?anova
res.aov <- aov(age ~ sex, data = newdata)
summary(res.aov)
