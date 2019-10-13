t <- function(y, x) sin(y^2)
xmin <- 0
xmax <- function(y, x) y
ymin <- 0
ymax <- sqrt(pi/2)

integral2(t, ymin, ymax, xmin, xmax)


t <- function(x,y) sin(x^2)
ymin <- 0
ymax <- function(x, y) x
xmin <- 0
xmax <- sqrt(pi/2)

integral2(t, xmin, xmax, ymin, ymax)

install.packages("Rsolnp")
library(Rsolnp)
solnp(function(x,y,z) 3*x-y-3*z, function(x,y,z) x+y-z=0, function(x,y,z) x^2+z^2=1)

critical.r <- function( n, alpha = .05 ) {
        df <- n - 2
        critical.t <- qt( alpha/2, df, lower.tail = F )
        critical.r <- sqrt( (critical.t^2) / ( (critical.t^2) + df ) )
        return( critical.r )
}
critical.r(46)


getwd()
library(xlsx)
library(tidyverse)
df <- read.xlsx('~/Correlation_P.xlsx',
                sheetIndex = 1, stringsAsFactors = F)

colnames(df) <- as.character(unlist(df[1,]))
df = df[-1, ]

df_interest <- df[, grepl("Export|Life Expectancy", names(df))]
row.names(df_interest) <- 1:nrow(df_interest)
finish_df <- df_interest[1:46,]


test <- as.data.frame(sapply(finish_df, as.numeric))
lapply(test, class)
blah <- cor.test(test$Exports, test$`Life Expectancy`)
cor.test(test$Exports, test$`Life Expectancy`)$p.value
cor.test(test$Exports, test$`Life Expectancy`)$estimate^2

