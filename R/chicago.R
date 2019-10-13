#install packages if not installed
list.of.packages <- c("dplyr", "ggplot2", "ggpubr", "gridExtra", "chron")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(ggplot2)
library(ggpubr)
library(gridExtra)
chicago <- read.csv("ChiMarathonMen.csv", header = T, sep = ",")
# A i.
table(chicago$Division)
ggplot(chicago) + geom_bar(aes(Division, fill = ..count..)) + scale_fill_continuous(trans = 'reverse')
# A ii.
library(chron)
        # either by FinishMin column or using 'chron' library on Finish column
        # note that the second way will be more accurate as the FinishMin column rounds to the minute
chicago %>% 
        group_by(Division) %>% 
        summarise(mean = mean(FinishMin, na.rm = T), sd = sd(FinishMin, na.rm = T))
chicago %>% 
        group_by(Division) %>% 
        summarise(mean = mean(times(Finish), na.rm = T), sd = times(sd(times(Finish), na.rm = T)))
# A iii.
        # box plot two ways
ggplot2::ggplot(chicago, aes(x = Division, y = FinishMin, color = Division)) + 
        geom_boxplot(outlier.colour = "black") +
        ggtitle("ggplot2\nBox Plot Times by Age Group")

ggpubr::ggboxplot(chicago, x = "Division", y = "FinishMin", 
          color = "Division",
          order = c("20-24", "25-29", "30-34", "35-39"),
          ylab = "time", xlab = "ageG", legend = "right",
          main = "ggpubr-ggboxplot\nBox Plot Times by Age Group")        
        # density plot each age
        # got function from here: https://stackoverflow.com/questions/31993704/storing-ggplot-objects-in-a-list-from-within-loop-in-r 
        # got plotting from here: https://stackoverflow.com/questions/10706753/how-do-i-arrange-a-variable-list-of-plots-using-grid-arrange
plot_data_column_filter <- function (data, column, filter) {
        ggplot2::ggplot(data = data[which(data$Division == filter),], aes_string(x = column)) +
                geom_density() + xlab(column) + ggtitle(filter)
        
}
myplots <- lapply(unique(chicago$Division),
                  plot_data_column_filter, 
                  data = chicago, 
                  column = "FinishMin")
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, ncol = nCol)

# b
# because look normal and only slighly skewed and we have engough sample size we will test if we can use anova with bartlett.

#c
bartlett.test(FinishMin ~ Division, data = chicago)
# because p-value is above .05 the variances are equal enough
chicago.aov <- stats::aov(FinishMin ~ Division, data = chicago)
summary(chicago.aov)
TukeyHSD(chicago.aov)
# we wouldn' t use the kruskal wallis because there is not too much dispersion
# kruskal.test(FinishMin ~ Division, data = chicago)
