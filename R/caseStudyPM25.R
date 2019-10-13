data2012 <- read.table("~/RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
ls
head(data99)
getwd()
list.files("~/data")
data1999 <- read.table("~/RD_501_88101_1999-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
head(data1999)
grep("^RC",data1999)
grep("^RC",data1999)
cnames <- readLines("~/RD_501_88101_1999-0.txt", 1)
cnames
cnames <- strsplit(cnames, "|", fixed = TRUE)
cnames
?strsplit
names(data1999) <- make.names(cnames[[1]])
head(data1999)
x0 <- data1999$Sample.Value
str(x0)
class(x0)
summary(x0)
mean(is.na(x0))
data2012 <- read.table("~/data/RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
1300000*28*8/2^20
dim(data2012)
names(data2012) <- make.names(cnames[[1]])
head(data2012)
summary(data2012)
x1 <- data2012$Sample.Value
summary(x1)
summary(x0)
mean(is.na(x1))
boxplot(log10(x0),log10(x1))
negative <- x1<0
str(negative)
sum(negative, na.rm = TRUE)
dates<-as.Date(as.character(date),"%Y%m%d")
siteNY99 <- unique(subset(data1999, State.Code == 36, c(County.Code, Site.ID)))
siteNY12 <- unique(subset(data2012, State.Code == 36, c(County.Code, Site.ID)))
site0 <- paste(siteNY99[,1], siteNY99[,2], sep = ".")
site1 <- paste(siteNY12[,1], siteNY12[,2], sep = ".")
both <- intersect(site0, site1)
both
str(siteNY99)
str(site0)
str(site1)
unique(site)
data1999$county.site <- with(data1999, paste(County.Code, Site.ID, sep = "."))
data2012$county.site <- with(data2012, paste(County.Code, Site.ID, sep = "."))
cnt0 <- subset(data1999, State.Code == 36 & county.site %in% both)
cnt1 <- subset(data2012, State.Code == 36 &county.site %in% both)
sapply(split(cnt0, cnt0$county.site), nrow)
sapply(split(cnt1, cnt1$county.site), nrow)
data99Sub <- subset(data1999, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
data12Sub <- subset(data2012, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
dim(data99Sub)
dim(data12Sub)
b <- c("c", "d", "e", "f", "e")
a <- c("c", "j", "f", "e")
a %in% b
dates0 <- data12Sub$Date
x12Sub <- data12Sub$Sample.Value
plot(dates0,x12Sub)
dates0 <- as.Date(as.character(dates0), "%Y%m%d")
dates0
plot(dates0, x12Sub)
dates99 <- data99Sub$Date
x99Sub <- data99Sub$Sample.Value
dates99 <- as.Date(as.character(dates99), "%Y%m%d")
plot(dates99, x99Sub)
par(mfrow = c(1,2))
range(x12Sub,x99Sub, na.rm = T)
range <- range(x12Sub,x99Sub, na.rm = T)
library(dplyr)
data1999 %>%
        select(State.Code, Sample.Value) %>%
        group_by(State.Code) %>%
        summarise(mean(Sample.Value, na.rm = T))
mn99 <- with(data1999, tapply(Sample.Value, State.Code, mean, na.rm = T))
mn99
?tapply
