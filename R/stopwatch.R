#install packages if not installed
list.of.packages <- c("dplyr", "ggplot2", "ggpubr", "gridExtra")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(ggplot2)
library(ggpubr)
library(gridExtra)
stopwatch <- read.csv("stopwatch.csv", header = T, sep = ",")
# A i.
table(stopwatch$type)
ggplot(stopwatch) + geom_bar(aes(type, fill = ..count..)) + scale_fill_continuous(trans = 'reverse')
# A ii.
stopwatch %>% 
        group_by(type) %>% 
        summarise(mean = mean(cycles, na.rm = T), sd = sd(cycles, na.rm = T), var_ = (sd(cycles, na.rm = T))^2)
# A iii.
        # box plot two ways
ggplot2::ggplot(stopwatch, aes(x = type, y = cycles, color = type)) + 
        geom_boxplot(outlier.colour = "black") +
        ggtitle("ggplot2\nBox Plot Cycles by Stop Watch Type")

ggpubr::ggboxplot(stopwatch, x = "type", y = "cycles", 
          color = "type",
          order = c("I", "II", "III"),
          ylab = "cycles", xlab = "type", legend = "right",
          main = "ggpubr-ggboxplot\nBox Plot Cycles by Stop Watch Type")        
        # density plot each age
        # got function from here: https://stackoverflow.com/questions/31993704/storing-ggplot-objects-in-a-list-from-within-loop-in-r 
        # got plotting from here: https://stackoverflow.com/questions/10706753/how-do-i-arrange-a-variable-list-of-plots-using-grid-arrange
plot_data_column_filter <- function (data, column, filter) {
        ggplot2::ggplot(data = data[which(data$type == filter),], aes_string(x = column)) +
                geom_density() + xlab(column) + ggtitle(filter)
        
}
myplots <- lapply(unique(stopwatch$type),
                  plot_data_column_filter, 
                  data = stopwatch, 
                  column = "cycles")
n <- length(myplots)
nCol <- floor(sqrt(n))
grid.arrange(grobs = myplots, ncol = nCol)

# b small sample, and distribubution is not normal looking density so we will use non-parametric

#
bartlett.test(cycles ~ type, data = stopwatch) # greater than .05 so can use kw test
stopwatch.kw <- kruskal.test(cycles ~ type, data = stopwatch)
stopwatch.kw # the means are equal
