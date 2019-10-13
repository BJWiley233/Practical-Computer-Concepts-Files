x <- matrix(c(6, 15, 55, 15, 55, 225, 55, 225, 979), 3, 3)

chol(x)

matrix_ <- matrix(c(1,2,2,1), 2)

chol(matrix_)
eigen(matrix_)$values

x <- matrix(c(2, -1, 0, -1, 2, -1, 0, -1, 2), 3, 3)
eigen(x)$values
chol(x)
det(x)
x
t(x)

file_path <- "http://www.sthda.com/sthda/RDoc/data/housetasks.txt"
housetasks <- read.delim(file_path, row.names = 1)
install.packages("gplots")
library(gplots)
dt <- as.table(as.matrix(housetasks[,1:4]))
balloonplot(t(dt), main = "housetasks", label = FALSE, show.margins = FALSE)
library(graphics)
mosaicplot(dt, shade = TRUE, las=2, main = "housetasks")
library(vcd)
assoc(head(dt, 5), shade = T, las=3)

?assoc




(156-60.55)/sqrt(60.55)


source("https://bioconductor.org/biocLite.R")
biocLite("BiocGenerics")

getwd()
workingDir = "C:/Users/bjwil/OneDrive/Documents/R/Liver_rats"
setwd(workingDir)
options(stringsAsFactors = F)
femData = read.csv("LiverFemale3600.csv")
head

one = c(1,2,5,4)
two = c(2,3,5,7)
dft <- rbind(one,two)
?philentropy::distance

# Set path of Rtools
Sys.setenv(PATH = paste(Sys.getenv("PATH"), "*InstallDirectory*/Rtools/bin/",
                        "*InstallDirectory*/Rtools/mingw_64/bin", sep = ";")) #for 64 bit version
Sys.setenv(BINPREF = "*InstallDirectory*/Rtools/mingw_64/bin")
library(devtools)

#Manually "force" version to be accepted 
assignInNamespace("version_info", c(devtools:::version_info, list("3.5" = list(version_min = "3.3.0", version_max = "99.99.99", path = "bin"))), "devtools")
find_rtools() # is TRUE now

library(devtools)
assignInNamespace("version_info", c(devtools:::version_info, list("3.5" = list(version_min = "3.3.0", version_max = "99.99.99", path = "bin"))), "devtools")
find_rtools() # is TRUE now

devtools::install_github("r-lib/devtools")

theta
m = matrix(c(sin(pi/2)*cos(pi), sin(pi/2)*sin(pi), cos(pi/2),
             cos(pi/2)*cos(pi), cos(pi/2)*sin(pi), -sin(pi/2),
             -sin(pi), cos(pi), 0), nrow = 3)

all(t(m) == solve(m))


