if(!file.exists("./data")){dir.create("./data")}
fileUrl1 = "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
fileUrl2 = "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileUrl1,destfile="./data/ACS.csv",method="curl")
download.file(fileUrl2,destfile="./data/solutions.csv",method="curl")
ACS = read.csv("./data/ACS.csv", sep = ",", stringsAsFactors=FALSE, na.rm = TRUE) 

head(reviews)
head(solutions)

head(sqldf("SELECT * 
           FROM reviews r RIGHT JOIN solutions s ON s.id=r.solution_id"))

mergedData = merge(reviews,solutions,by.x="solution_id",by.y="id",all=TRUE)
head(mergedData)
?download.file

a1 <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip = 3, header = TRUE, na.strings=c("NA","NaN", "",".."), stringsAsFactors = FALSE)
rename <- a1 %>% select(everything()) %>% rename(Country = X, milDollars = US.dollars.)
rename2 <- rename[rowSums(is.na(rename)) != ncol(rename),]
rename3 <-  rename2[!(is.na(rename2$Country)), ]
rename4 <-  rename3[!(is.na(rename3$Country) | rename3$Country==""), ]
library(stringr)
rename4[] <- lapply(rename4, str_trim)
is.na(rename4) <- rename4==''
rename4
sapply(rename4, mode)
rename4[,2] <- sapply(rename4[, 2], as.numeric)
rename4[,4] <- sapply(rename4[, 4], as.numeric(as.character))
dots <- grep(".*...*", rename4[,4])
rename5 <- rename4
sapply(rename5, mode)
rename5$milDollars <- as.numeric(gsub(",", "", rename5$milDollars))
x <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv", header = TRUE, na.strings=c("NA","NaN", "","^..$"), stringsAsFactors = FALSE)




mydata[which(mydata$gender=='F'& mydata$age > 65), ]
GDP <- finalGDP[which(finalGDP$Ranking > 0), ]
merge <- merge(GDP, a2, by = "CountryCode")

data <- read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", skip = 3, na.strings = c("Na", "NaN", "", ".."), stringsAsFactors = FALSE)

