require(dplyr)
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
head(NEI %>% filter(fips =='42101'))

NEISCC <- merge(NEI, SCC, by="SCC")
names(NEISCC)
head(NEI)
head(SCC)
nrow(SCC)
length(SCC[grep('coal.*comb|comb.*coal', SCC$EI.Sector, ignore.case = TRUE),]$EI.Sector)



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

NEI_MC_P <- NEI[NEI$fips == "04013" | NEI$fips == "42101",]
yMC_P <- aggregate(Emissions ~ year + fips, NEI_MC_P, sum)
ggplot(yMC_P, aes(x = factor(year), y = Emissions, fill = factor(fips))) + 
        geom_bar(stat = "identity", position ="dodge") 
yMC_P_Type <- aggregate(Emissions ~ year + fips + type, NEI_MC_P, sum)
ggplot(yMC_P_Type, aes(x = factor(year), y = Emissions, fill = type)) + 
        geom_bar(stat = "identity") 

p <- ggplot(yMC_P_Type, aes(x = factor(fips), y = Emissions, fill = type)) + 
        geom_bar(aes(factor(fips)), stat = "identity") +
        facet_grid(.~ year)

p
###############
NEI_MC <- NEI[NEI$fips == "04013",]
head(NEI_MC, 50)
yMC <- aggregate(Emissions ~ year, NEI_MC, sum)
ggplot(yMC, aes(x = factor(year), y = Emissions), fill = factor(year)) + 
        geom_bar(aes(fill = year), stat = "identity") 
barplot(yMC$Emissions)

MC_Type <- aggregate(Emissions ~ year + type, NEI_MC, sum)
ggplot(MC_Type, aes(x = year, y = Emissions, fill = factor(type))) + 
        geom_bar(stat = "identity", position ="dodge") 
#####
NEI_P <- NEI[NEI$fips == "42101",]
head(NEI_P, 50)
yP <- aggregate(Emissions ~ year, NEI_P, sum)
ggplot(yP, aes(x = factor(year), y = Emissions), fill = factor(year)) + 
        geom_bar(aes(fill = year), stat = "identity") 
barplot(yP$Emissions)

MP_Type <- aggregate(Emissions ~ year + type, NEI_P, sum)
ggplot(MP_Type, aes(x = year, y = Emissions, fill = factor(type))) + 
        geom_bar(stat = "identity", position ="dodge")
######
head(NEIBM)
library(reshape2)
sums <- 
sums.long <- melt(sum)


SCC <- readRDS("~/Source_Classification_Code.rds")
NEISCC <- merge(NEI, SCC, by="SCC")
head(NEISCC)
names(NEI)
names(SCC)
names(NEISCC)
subsetNEI <- NEI[NEI$fips=="24510" & NEI$type=="ON-ROAD",  ]
nrow(subsetNEI)
aggregatedTotalByYear <- aggregate(Emissions ~ year, subsetNEI, sum)



png("plot5.png", width=840, height=480)
g <- ggplot(aggregatedTotalByYear, aes(factor(year), Emissions))
g <- g + geom_bar(stat="identity") +
        xlab("year") +
        ylab(expression('Total PM'[2.5]*" Emissions")) +
        ggtitle('Total Emissions from motor vehicle (type = ON-ROAD) in Baltimore City, Maryland (fips = "24510") from 1999 to 2008')
print(g)
dev.off()
