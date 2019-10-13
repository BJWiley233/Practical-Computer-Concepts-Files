parMar <- function (x) {
        par(mar = c(5.1,4.1,4.1,2.1))
}

swapcols <- function(x, col1, col2) {
        if(is.character(col1)) col1 <- match(col1, colnames(x))
        if(is.character(col2)) col2 <- match(col2, colnames(x))
        if(any(is.na(c(col1, col2)))) stop("One or both columns don't exist.")
        i <- seq_len(ncol(x))
        i[col1] <- col2
        i[col2] <- col1
        x[, i]
}

movecol <- function(x, col, to.pos) {
        if(is.character(col)) col <- match(col, colnames(x))
        if(is.na(col)) stop("Column doesn't exist.")
        if(to.pos > ncol(x) | to.pos < 1) stop("Invalid position.")
        x[, append(seq_len(ncol(x))[-col], col, to.pos - 1)]
}

movecolName <- function(x, col, to.pos) {
        if(is.character(col)) col <- match(col, colnames(x))
        if(is.na(col)) stop("Column doesn't exist.")
        if(is.character(to.pos)) to.pos <- match(to.pos, colnames(x))
        if(to.pos > ncol(x) | to.pos < 1) stop("Invalid position.")
        x[, append(seq_len(ncol(x))[-col], col, to.pos - 1)]
}

reverseRowOrder <- function (x) {
        x[seq(dim(x)[1],1), ]
}

Threeby3GraphMatrixH <- function(x) {
        par(mar=c(1,1,1,1), mfrow = c(3, 3), bg = "white")
        layout(matrix(c(1,2,3,7,5,10,1,4,3,8,5,11,1,6,3,9,5,12),ncol=3))
        plot.new()
        text(0.5,0.5,"First title",cex=2,font=2)
        plot(x, xlab = "Brian", ylab = "Number", main = "1")
        plot.new()
        text(0.5,0.5,"Second title",cex=2,font=2)
        hist(x, main = "2")
        plot.new()
        text(0.5,0.5,"Third title",cex=2,font=2)
        boxplot(x, main = "3")
        barplot(x, main = "4")
        boxplot(x, main = "5")
        barplot(x, main = "6")
        barplot(x, main = "7")
        hist(x, main = "8")
        barplot(x, main = "9")
}

Threeby3GraphMatrixV <- function(x) {
        par(mar=c(1,1,1,1), mfrow = c(3, 3), bg = "white")
        layout(matrix(c(1,2,3,4,5,6,1,7,3,8,5,9,1,10,3,11,5,12),ncol=3))
        plot.new()
        text(0.5,0.5,"First title",cex=2,font=2)
        plot(x, xlab = "Brian", ylab = "Number", main = "1")
        plot.new()
        text(0.5,0.5,"Second title",cex=2,font=2)
        hist(x, main = "2")
        plot.new()
        text(0.5,0.5,"Third title",cex=2,font=2)
        boxplot(x, main = "3")
        barplot(x, main = "4")
        boxplot(x, main = "5")
        barplot(x, main = "6")
        barplot(x, main = "7")
        hist(x, main = "8")
        barplot(x, main = "9")
}


testNewFunction2 <- function (x) {
        print("test")
}

##### Color Outliers
library(lattice)
library(dplyr)
library(datasets)
library(plotly)
packageVersion('plotly')
library(ggplot2)                                                          
library(datasets)
lines <- "blanchedalmond"
ggplot(airquality, aes(factor(Month), Ozone)) + theme(panel.background = element_rect(fill = 'black', colour = 'red')) + 
        stat_boxplot(geom = "errorbar", width = 0.3, size=1.3, colour = lines) +  geom_boxplot(aes(fill=factor(Month), color = factor(Month)), outlier.size = 2) +
        scale_fill_manual(name = "Ozone Levels Per Month", values = c("pink", "green", "orange", "yellow", "blue")) +
        scale_color_manual(name = "Ozone Levels Per Month", values = c("pink", "green", "orange", "yellow", "blue")) +
        geom_boxplot(aes(fill=factor(Month)), outlier.size = 2, outlier.colour = NA, colour = lines) #if you want grey lines
