library(affy)
library(limma)
library(GEOquery)
getwd()
phenoData_ <- read.AnnotatedDataFrame("pheno.txt", header=T, sep = '\t')
pData(phenoData_)
dim(phenoData_)
files = list.files("~/down_syndrome", pattern=".*.CEL", full.names = T)


list.files("~/down_syndrome", pattern=".*.CEL")
dim(phenoData_)
row.names(phenoData_)
files = files[match(row.names(phenoData_), list.files("~/down_syndrome", pattern=".*.CEL"))]

MyBioData <- ReadAffy(filenames = files, phenoData = phenoData_)
head(rownames(MyBioData))
MyBioData_1 = affy::rma(MyBioData)
colnames(MyBioData)
MyBioData$tissue

length(rownames(MyBioData))
"AFFX-BioB-5_at" %in% rownames(MyBioData)

MyBioData_2 <- getGEO("GSE1397")
pData(MyBioData_2)
MyBioData_2 <- MyBioData_2[[1]]
dim(exprs(MyBioData_2))
exprs(MyBioData_2)[1:5, ]
dim(exprs(MyBioData_1))
exprs(MyBioData_1)[1:5, ]
MyBioData_3 <- affy::rma(MyBioData, normalize = F)
plotDensity(MyBioData)
plotDensity(exprs(MyBioData_1))

hist(MyBioData)
hist(MyBioData_1, xlab='log intensity')
plotDensity(MyBioData_1, xlab='log intensity')
boxplot(MyBioData)
boxplot(MyBioData_1, names=NA, xlab='samples')
axis(1, )
pData(MyBioData_1)
affy::MAplot(MyBioData)
plots <- affy::MAplot(MyBioData_1[, 22:25], cex.main=0.75, cex=0.75)
titles <- paste(colnames(MyBioData_1), "vs psuedo-median reference chip", sep="\n")

deg <- AffyRNAdeg(MyBioData)
names(deg)
summaryAffyRNAdeg(deg)
library(mosaic)
mm(MyBioData)
mean(affy::mm(MyBioData) > affy::pm(MyBioData))

design <- model.matrix(~ diagnosis, pData(MyBioData_1))
design
  