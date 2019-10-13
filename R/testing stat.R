dat=read.table("http://www.stat.ufl.edu/~winner/data/pgalpga2008.dat",header = F)
dat
oring
colnames(dat) = c("dDist", "dAcc", "FM")
dat
plot(dDist,dAcc)
attach(dat)
plot(dat(dDist, dAcc))
datM <- subset(dat, FM==2, select=1:2)
colnames(datM) = c("MdDist","MdAcc")
attach(datM)
plot(MdDist,MdAcc)
colnames(datF) = c("FdDist","FdAcc")
attach(datF)
plot(FdDist,FdAcc)
datF.lm=lm(FdAcc~FdDist)
summary(datF.lm)
130.89331 - 0.25649*qt(.975,155)
-0.25649 + 0.04424*qt(.975,155)10.82052-2.102*qt(.975,21)*sqrt(1+1/23+((31-mean(T))^2/22/var(T)))
dat.lm=lm(dAcc~dDist)
summary(dat.lm)

install.packages("shiny")
library(shiny);runApp("~/R/New folder/Brian", port=8100)
dir.create("03_reactivity")
dir.create("whereami")
setwd("C:\Program Files\R\Examples")
dir.create("C:\Program Files\R\Examples\test1")
setwd("C:\Program Files\R\Examples\test1")
dir.create("C:\Users\bjwil\OneDrive\Documents\R\New folder\Brian")
setwd("C:\Users\bjwil\OneDrive\Documents\R\New folder\Brian")

library(shiny);
runApp("~/R/win-library/3.4/shiny/examples/03_reactivity", port=8100)
library(shiny);runApp("~/R/New folder/Brian", port=8100)
x=4
library(shiny)