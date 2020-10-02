library(seqinr)

setwd("~/JHU_Fall_2020/Genome_Analysis/Module_2")

palkyprt <- seqinr::read.fasta("palkyprt(4)(1).fasta")
c2s
length(palkyprt[[1]])
seqinr::GC(palkyprt[[1]])
seqinr::count(palkyprt[[1]], 1)
seqinr::count(palkyprt[[1]], 2)

smalt <- seqinr::read.fasta("smalt(4)(1).fasta")
length(smalt[[1]])
seqinr::GC(smalt[[1]])
count(smalt[[1]], 2)
c2s(sheli)
sheli <- seqinr::read.fasta("sheli(2).fasta")
count(sheli[[1]], 2)

library(Biobase)
library("ALL")
BiocManager::install("Affyhgu133aExpr")

library(CLL)
data(ALL)
library(hgu133plus2.db)

ALL
featureNames(ALL)
ALL["1840_g_at", ]

data("CLLbatch")
CLLbatch




BiocManager::install("ArrayExpress")
BiocManager::install("oligoClasses")
install.packages("ff")

library(sma)
library(ArrayExpress)
library(GEOquery)
# Lists the DataSet (GDS), Series (GSE) or Platform (GPL) accession number, 
# followed by title and organism.
my.gse2 <- "GSE6691"
my.gse2 <- "GSE19147"
my.gse2 <- "GSE26725"
gsub('\\d{1,3}$','nnn',my.gse2,perl=TRUE)
my.geo.gse2 <- getGEO(GEO=my.gse2,
                      destdir="./geo_downloads",
                      GSElimits = c(1, 10),
                      GSEMatrix = T)
parseGEO()
parseG
library(ArrayExpress)

bug.report(package='GEOquery')
filename <- "geo_downloads/GSE6691_series_matrix.txt.gz"
dat <- readLines(filename)
begin <- grep("^!series_matrix", dat)
datamat <- read.delim(filename, skip=begin, quote='"', comment.char="!")
dim(datamat)

my.geo.gse2 <- my.geo.gse2[[1]]
exprs(my.geo.gse2["AFFX-BioB-5_at", ])

phenoData(my.geo.gse2)
my.geo.gse2
sampleNames(my.geo.gse2)
head(exprs(my.geo.gse2))

my.geo.gse <- getGEO(GEO="GSE18026",
                     destdir="./geo_downloads",
                     getGPL=T)
my.geo.gse[[1]]

exprs(ALL["1007_s_at", ])
exprs(my.geo.gse2["201088_at", ])
exprs(my.geo.gse2["208407_s_at", ])
match("1007_s_at", featureNames(my.geo.gse2))

featureNames(my.geo.gse2)
exprs(my.geo.gse2)[1:10,]
my.geo.gse2[55, ]

class(my.geo.gse2)


#my.gse2 <- "GSE103223"
getGEOSuppFiles(my.gse2, makeDirectory=T, baseDir="./geo_downloads")

untar(paste0("geo_downloads/",my.gse2,"/",my.gse2,"_RAW.tar"), 
      exdir=paste0("geo_downloads/",my.gse2,"/CEL"))
list.files(paste0("geo_downloads/",my.gse2,"/CEL"))
boxplot(exprs(my.geo.gse2))


my.cels <- list.files(paste0("geo_downloads/",my.gse2,"/CEL"), pattern = "*.CEL")


my.pdata <- as.data.frame(pData(my.geo.gse2), stringsAsFactors=FALSE)
colnames(my.pdata)
head(my.pdata[, c("title", "geo_accession", "description")])
nrow(my.pdata)
my.pdata <- my.pdata[, c("title", "geo_accession", "description")]
order(rownames(my.pdata))
row.names(my.pdata) == my.cels
table(paste0(row.names(my.pdata), '.CEL.gz') == my.cels)
row.names(my.pdata) = paste0(row.names(my.pdata), '.CEL.gz')
write.table(my.pdata, file=paste0("~/geo_downloads/", my.gse2,"/CEL/", 
                                  my.gse2,"_SelectPhenoData.txt"), sep="\t", quote=F)

cel.path <- paste0("geo_downloads/",my.gse2,"/CEL")
#################
my.affy <- ReadAffy(celfile.path = cel.path, 
                    phenoData = paste(cel.path, 
                                      paste0(my.gse2,"_SelectPhenoData.txt"), 
                                      sep='/'))

################


