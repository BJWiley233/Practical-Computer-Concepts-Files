NEI <- readRDS("~/summarySCC_PM25.rds")
head(NEI)
unique(NEI$year)
unique(NEI$Pollutant)
unique(NEI$fips)
SCC <- readRDS("~/Source_Classification_Code.rds")
head(SCC)
# Maricopa
head(NEI %>% filter(fips =='04013'))
#Philly
head(NEI %>% filter(fips =='04013'))

NEISCC <- merge(NEI, SCC, by="SCC")
names(NEISCC)
head(NEI)
head(SCC)
nrow(SCC)
length(SCC[grep('coal.*comb|comb.*coal', SCC$EI.Sector, ignore.case = TRUE),]$EI.Sector)

 ?grepl

plot(x = year, y = aggregate(Emissions ~ year, NEI, sum))
?plot
barplot(x = NEI$year, y =)

barplot(aggregate(Emissions ~ year, NEI, sum))
?boxplot

names(NEI)
newNEI <- NEI[,c(6,4)]
y<-aggregate(Emissions ~ year, newNEI, sum)
plot(y, pch=19)

ggplot(y, aes(x = factor(year), y = Emissions), fill = factor(year)) + 
        geom_bar(aes(fill = year), stat = "identity") 

library(ggplot2)
names(NEI)
head(NEI[NEI$fips == "24510",])
NEIBM <- NEI[NEI$fips == "24510",]
head(NEIBM, 50)
yBM <- aggregate(Emissions ~ year, NEIBM, sum)
ggplot(yBM, aes(x = factor(year), y = Emissions), fill = factor(year)) + 
        geom_bar(aes(fill = year), stat = "identity") 
plot(yBM)
bmYT <- aggregate(Emissions ~ year + type, NEIBM, sum)
ggplot(bmYT, aes(x = year, y = Emissions, fill = factor(type))) + 
        geom_bar(stat = "identity", position ="dodge") 
head(NEIBM)
library(reshape2)
sums <- 
sums.long <- melt(sum)
