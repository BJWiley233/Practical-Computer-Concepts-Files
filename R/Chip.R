library(GenomicAlignments)
source("https://bioconductor.org/biocLite.R")
biocLite("HTqPCR")
AaabiocLite("ChIPQC")
library(ChIPQC)
library(GenomicRanges)



all.R.commands <- system.file("doc", "HTqPCR.Rnw",
                              package = "HTqPCR")

Stangle(all.R.commands)

source("https://bioconductor.org/biocLite.R")
biocLite("GenomicFeatures")
biocLite("IMAS")
library(IMAS)
data(bamfilestest)
ext.dir <- system.file("extdata", package="IMAS")
samplebamfiles[,"path"] <- paste(ext.dir,"/samplebam/",samplebamfiles[,"path"],".bam",sep="")
data(sampleGroups)
data(samplesnp)

selArrays = with(pData(CCl4),
                 (Cy3 == "CCl4" & RIN.Cy3 > 9) |
                         (Cy5 == "CCl4" & RIN.Cy5 > 9))

m <- matrix(c(2,-1,0,-1,2,-3,0,-3,2), nrow = 3)
m
is.symmetric.matrix(m)
is.positive.definite(m)
install.packages("matrixcalc")
library(matrixcalc)
det(m)

1-((1-.023)*(1-.078))

?dnorm
qnorm(.95, 0, 1)
qnorm(.95, 0, 1, lower.tail = F)
?qbinom()
qbinom(.5, 20, .5)
1-pbinom(7, 10, .5)
m
vcov(m)
cov(m)
