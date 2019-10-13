# p value
z = -1.645
# 1 sided
pvalue <- pnorm(-abs(z))

# 2 sided
z = -1.96
pvalue <- 2*pnorm(-abs(z))

# z score from p value
z <- qnorm(.05)
z <- qnorm(.95)
z <- qnorm(.025)
z <- qnorm(.975)

# reading in dataset
getwd()
# either read in entire set and then delete first column
pStopsMinn <- read.csv('MplsStops.csv', header = TRUE, stringsAsFactors = FALSE)
pStopMinnNew <- pStopsMinn[,-1]
pStopMinnNewOther <- pStopsMinn[,!(names(pStopsMinn) %in% "X")]
# or read in certain columns of csv
pStopsMinnCertainColumns <- read.csv('MplsStops.csv', header = TRUE, stringsAsFactors = F,
                                     colClasses=c("NULL", NA, NA, NA, NA, NA, NA, 
                                                  NA, NA, NA, NA, NA, NA, NA, NA))
pStopsMinnCertainColumns2 <- read.csv('MplsStops.csv', header = TRUE, stringsAsFactors = F)[, -1]


# subsetting data using subset
unique(pStopMinnNew[, "problem"])
pStopMinnNewTraffic <- subset(pStopMinnNew, problem == "traffic") 
pStopMinnNewSuspicious <- subset(pStopMinnNew, problem == "suspicious")

# subsetting data not using subset

# subsetting data using dplyr



































































