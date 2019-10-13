blah <- read.table(
        "AQUAE_p_TCGA_112_304_b2_N_GenomeWideSNP_6_E12_1348354.nocnv_grch38.seg.v2.txt",
        sep="\t", header=TRUE)

x <- data.frame("Time (in minutes)" = c(0, 30, 60, 90, 120), "OD600 Reading (# Cells)" = 
                        c(2.92*10^7, 5.50*10^7, 6.56*10^7, 1.89*10^8, 4.74*10^8), 
                "CFU" = c(3400/(1/200*.1), 382/(1/2000*.1), 492/(1/2000*.1), 107/(1/4000*.1),
                          64/(1/40000*.1)))

x

plot(x = log10(x$OD600.Reading....Cells.), y = log10(x$CFU))
library(ggplot2)
par(mar = c(5,9,4,2) + .1)
ggplot(x, aes(x = log10(x$OD600.Reading....Cells.), y = log10(x$CFU), color = x$Time..in.minutes.)) + 
        geom_point() +
        geom_smooth(method=lm, formula = y ~ poly(x, 2), se=FALSE, fullrange=TRUE, color = "black") +
        geom_text(aes(label=x$Time..in.minutes.), hjust = 1.5) +
        ggtitle("Log CFU vs. Log OD6000") +
        labs(x = "log10(OD600 Reading)", y = "log10(CFU)") +
        #scale_color_manual(values=c('#999999','#E69F00', '#56B4E9', '#CD5B45', '#00009B')) +
        theme(plot.title = element_text(hjust = 0.5), axis.title.y = element_text(margin = margin(t = 0, r = 7, b = 0, l = 0))) +
        scale_colour_gradient(low = "orange", high = "blue")  

?axis.title.y.right
ggplot(mtcars, aes(x=wt, y=mpg, color=as.factor(cyl), shape=as.factor(cyl))) +
        geom_point() + 
        geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
        scale_shape_manual(values=c(3, 16, 17))+ 
        scale_color_manual(values=c('#999999','#E69F00', '#56B4E9'))+
        theme(legend.position="top", axis.title.y = element_text(margin = margin(t = 0, r = 20, b = 0, l = 0)))
        

