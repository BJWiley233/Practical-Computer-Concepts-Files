#install packages if not installed
list.of.packages <- c("dplyr", "ggplot2", "ggpubr", "gridExtra", "chron")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(ggplot2)
library(ggpubr)
library(gridExtra)
starcraft <- read.csv("starcraft.csv", header = T, sep = ",")
# A (Age) i.
table(starcraft$Race)
ggplot(starcraft) + geom_bar(aes(Race, fill = ..count..)) + scale_fill_continuous(trans = 'reverse')
# A (Age) ii.
starcraft %>% 
        group_by(Race) %>% 
        summarise(mean = mean(Age, na.rm = T), sd = sd(Age, na.rm = T))
# A (Age) iii.
        # box plot two ways
ggplot2::ggplot(starcraft, aes(x = Race, y = Age, color = Race)) + 
        geom_boxplot(outlier.colour = "black") +
        ggtitle("ggplot2\nBox Plot Ages by Race")
#boxplot(starcraft$Age ~ starcraft$Race, data = starcraft)

ggpubr::ggboxplot(starcraft, x = "Race", y = "Age", 
          color = "Race",
          order = c("Protoss", "Terran", "Zerg"),
          ylab = "Age", xlab = "Race", legend = "right",
          main = "ggpubr-ggboxplot\nBox Plot Ages by Race")        
        # density plot each age
        # got function from here: https://stackoverflow.com/questions/31993704/storing-ggplot-objects-in-a-list-from-within-loop-in-r 
        # got plotting from here: https://stackoverflow.com/questions/10706753/how-do-i-arrange-a-variable-list-of-plots-using-grid-arrange
plot_data_column_filter <- function (data, column, filter) {
        ggplot2::ggplot(data = data[which(data$Race == filter),], aes_string(x = column)) +
                geom_density() + xlab(column) + ggtitle(filter)
        
}

myplots <- lapply(unique(starcraft$Race),
                  plot_data_column_filter, 
                  data = starcraft, 
                  column = "Age")
summary(myplots)
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, ncol = nCol)

# b
# we decided to use parrametric because sample is 15 for each group

# c
bartlett.test(Age ~ Race, data = starcraft)
starcraft.aov <- stats::aov(Age ~ Race, data = starcraft)
summary(starcraft.aov)
TukeyHSD(starcraft.aov)
# Ho: There is no difference in the means
# Ha: There is a difference in at least one of the means (u1 != u2 != u3)
# because the p-value is less than .05 the test proves significant different at 95% confidence interval.
# could use here because bartlett is above .05 kruskal.test(Age ~ Race, data = starcraft)

# Repeat everything for Wins by replacing every above that has Age or "Age" with Wins and "Wins" respectively
# A (Age) i.
table(starcraft$Race)
ggplot(starcraft) + geom_bar(aes(Race, fill = ..count..)) + scale_fill_continuous(trans = 'reverse')
# A (Age) ii.
starcraft %>% 
        dplyr::group_by(Race) %>% 
        summarise(mean = mean(Wins, na.rm = T), sd = sd(Wins, na.rm = T))
# A (Age) iii.
# box plot two ways
ggplot2::ggplot(starcraft, aes(x = Race, y = Wins, color = Race)) + 
        geom_boxplot(outlier.colour = "black") +
        ggtitle("ggplot2\nBox Plot Wins by Race")
#boxplot(starcraft$Age ~ starcraft$Race, data = starcraft)

ggpubr::ggboxplot(starcraft, x = "Race", y = "Wins", 
                  color = "Race",
                  order = c("Protoss", "Terran", "Zerg"),
                  ylab = "Wins", xlab = "Race", legend = "right",
                  main = "ggpubr-ggboxplot\nBox Plot Wins by Race")        
# density plot each age
# got function from here: https://stackoverflow.com/questions/31993704/storing-ggplot-objects-in-a-list-from-within-loop-in-r 
# got plotting from here: https://stackoverflow.com/questions/10706753/how-do-i-arrange-a-variable-list-of-plots-using-grid-arrange
plot_data_column_filter <- function (data, column, filter) {
        ggplot2::ggplot(data = data[which(data$Race == filter),], aes_string(x = column)) +
                geom_density() + xlab(column) + ggtitle(filter)
        
}

myplots <- lapply(unique(starcraft$Race),
                  plot_data_column_filter, 
                  data = starcraft, 
                  column = "Wins")

summary(myplots)
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, ncol = nCol)

# b
# we decided to use parrametric because sample is 15 for each group

# c
bartlett.test(Wins ~ Race, data = starcraft)
starcraft.aov <- stats::aov(Wins ~ Race, data = starcraft)
summary(starcraft.aov)
TukeyHSD(starcraft.aov)
# Ho: There is no difference in the means
# Ha: There is a difference in at least one of the means (u1 != u2 != u3)
# because the p-value is less than .05 the test proves significant different at 95% confidence interval.
# not use this: kruskal.test(Wins ~ Race, data = starcraft)
