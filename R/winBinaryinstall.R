install.packages("C:/Users/bjwil/Downloads/pamr_1.30.zip", repos = NULL, 
                 lib="C:/Users/bjwil/OneDrive/Documents/R/R/win-library/3.3", type="win.binary")
library(WGCNA)
options(stringsAsFactors = FALSE);

femData = read.csv("LiverFemale3600.csv");
dim(femData)
names(femData)
library(pamr)
install.packages("pamr")
