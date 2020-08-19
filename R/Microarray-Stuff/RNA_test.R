browseVignettes("GEOquery")
GEOquery::getGEOSuppFiles()
paths <- getGEOSuppFiles("GSE46195")
getGeo("")



library(affy)
library(limma)
getwd()
phenoData_ <- read.AnnotatedDataFrame("pheno.txt", header=T, sep = '\t')
dim(phenoData_)
files = list.files("~/down_syndrome", pattern=".*.CEL", full.names = T)
MyBioData <- ReadAffy(filenames = files, phenoData = phenoData_)
ds_eset = rma(MyBioData)


my.gse <- "GSE15947"
##get published data and metadata
##this step is slow because of download and reformatting
##create directory for files downloaded from GEO
if(!file.exists("geo_downloads")) dir.create("geo_downloads")
if(!file.exists("results"))  dir.create("results", recursive=TRUE)
##get data from GEO
my.geo.gse <- getGEO(GEO=my.gse, filename=NULL, 
                     destdir="./geo_downloads", 
                     GSElimits=NULL, GSEMatrix=TRUE, AnnotGPL=FALSE, getGPL=FALSE)
if(!file.exists(paste0("~/geo_downloads/",my.gse)))
  getGEOSuppFiles(my.gse, makeDirectory=T, baseDir="~/geo_downloads")
list.files(paste0("~/geo_downloads/", my.gse))
untar(paste0("geo_downloads/",my.gse,"/",my.gse,"_RAW.tar"), exdir=paste0("geo_downloads/",my.gse,"/CEL"))
list.files(paste0("geo_downloads/",my.gse,"/CEL"))
my.cels <- list.files(paste0("geo_downloads/",my.gse,"/CEL"), pattern = "*.CEL")

my.geo.gse <- my.geo.gse[[1]]
my.pdata <- as.data.frame(pData(my.geo.gse), stringsAsFactors=FALSE)
colnames(my.pdata)
head(my.pdata[, c("title", "geo_accession", "description")])
nrow(my.pdata)
my.pdata <- my.pdata[, c("title", "geo_accession", "description")]
order(rownames(my.pdata))
row.names(my.pdata) == my.cels
table(paste0(row.names(my.pdata), '.CEL.gz') == my.cels)
row.names(my.pdata) = paste0(row.names(my.pdata), '.CEL.gz')
write.table(my.pdata, file=paste0("~/geo_downloads/", my.gse,"/CEL/", 
                                  my.gse,"_SelectPhenoData.txt"), sep="\t", quote=F)
?ReadAffy
cel.path <- paste0("geo_downloads/",my.gse,"/CEL")
#################
my.affy <- ReadAffy(celfile.path = cel.path, 
                    phenoData = paste(cel.path, paste0(my.gse,"_SelectPhenoData.txt"), sep='/'))

################

show(my.affy)                    
head(exprs(my.affy), 2)
head(exprs(my.geo.gse), 2)

table(pData(my.affy)$description)
cbind(as.character(pData(my.affy)$title), pData(my.affy)$sample.levels, pData(my.affy)$sample.labels)
plotDensity(exprs(my.affy))

featureData(my.affy)
exprs(my.affy)
exprs(my.geo.gse)
dim(exprs(my.affy))

my.rma1 <- rma(my.affy, normalize = F, background = F)
head(exprs(my.rma))
nrow(exprs(my.rma))
pData(my.rma)
pData(my.rma)$sample.levels <- c(rep("C.06", 4), rep("T.06", 4), rep("C.24", 4), rep("T.24", 4), rep("C.48", 4), rep("T.48", 4))
pData(my.rma)$sample.labels <- c(paste("C.06", 1:4, sep="."), paste("T.06", 1:4, sep="."), paste("C.24", 1:4, sep="."), paste("T.24", 1:4, sep="."), paste("C.48", 1:4, sep="."), paste("T.48", 1:4, sep="."))
pData(my.rma)$sample.levels <- as.factor(pData(my.rma)$sample.levels)
relevel()
plotDensity(exprs(my.rma))

library(limma)
library(RColorBrewer)

display.brewer.all()
level.pal = brewer.pal(6, 'Spectral')
level.pal

level.cols <- level.pal[unname(pData(my.rma)$sample.levels)]
plotDensities(exprs(my.rma), legend=F, col=level.cols, main = "Not Norm.")
legend("topright", legend=levels(pData(my.rma)$sample.levels), fill=level.pal)
boxplot(exprs(my.rma), names=pData(my.rma)$sample.labels, col=level.cols, 
        outline=F, main='Not Norm.')

pData(my.affy)$sample.levels <- c(rep("C.06", 4), rep("T.06", 4), 
                                  rep("C.24", 4), rep("T.24", 4), 
                                  rep("C.48", 4), rep("T.48", 4))
pData(my.affy)$sample.labels <- c(paste("C.06", 1:4, sep="."), 
                                 paste("T.06", 1:4, sep="."), 
                                 paste("C.24", 1:4, sep="."), 
                                 paste("T.24", 1:4, sep="."), 
                                 paste("C.48", 1:4, sep="."), 
                                 paste("T.48", 1:4, sep="."))
my.rma <- rma(my.affy, normalize = T, background = T)
plotDensities(exprs(my.rma), legend=F, col=level.cols, main = "Norm.")
boxplot(exprs(my.rma), names=pData(my.rma)$sample.labels, col=level.cols, 
        outline=F, main='Norm.')
write.table(exprs(my.rma), file=paste0("results/",my.gse,"_RMA_Norm.txt"), sep="\t", quote=FALSE)

head(exprs(my.geo.gse))
head(exprs(my.rma))

my.calls <- mas5calls(my.affy)
table(exprs(my.calls[, 1]))
class(my.rma)
class(my.affy)
present <- apply(exprs(my.calls), 1, function(x) sum(x=='P'))
head(present)
table(present)
prop.table(table(present) * 100)
plotDensities(exprs(my.rma)[present >= 4, ], legend=F, col=level.cols, main = "present >= 4")

exprs(my.rma) <- exprs(my.rma)[present >= 4, ]
exprs(my.rma) <- exprs(my.rma)[present >= 4, ]

my.rma2 <- my.rma[present >= 4, ]
my.rma2 <- my.rma2[-grep('_x_', rownames(exprs(my.rma2)))]
my.rma2 <- my.rma2[-grep('AFFX', rownames(exprs(my.rma2)))]
pData(my.rma2)$sample.levels <- as.factor(pData(my.rma2)$sample.levels)

## DGE with Limma
plotMDS(exprs(my.rma2), labels = pData(my.rma2)$sample.labels,
        top=500, gene.selection = 'common', main='MDS Plot to Compare Replicates')
pdf(file='results/MDS_plot.pdf')
plotMDS(exprs(my.rma2), labels = pData(my.rma2)$sample.labels,
        top=500, gene.selection = 'common', main='MDS Plot to Compare Replicates')
dev.off()

cluster.dat <- exprs(my.rma2)
gene.mean <- apply(cluster.dat, 1, mean)
gene.std <- apply(cluster.dat, 1, sd)
cluster.dat <- sweep(cluster.dat, 1, gene.mean, '-')
cluster.dat <- sweep(cluster.dat, 1, gene.std, '/')

my.dist <- dist(t(cluster.dat),method = 'euclidean')
dim(t(cluster.dat))
my.hclust <- hclust(my.dist, method = 'average')
my.hclust$labels <- pData(my.rma2)$sample.labels
plot(my.hclust, cex=0.75, main='Comparison of Biological Replicates',
     xlab='Euclid Dist')

cor_ <- cor(cluster.dat, method = 'spearman')
## 1 - r
## https://online.stat.psu.edu/stat555/node/85/
## 1 - r where r is the Pearson or Spearman correlation
my.dist <- as.dist(1 - cor_)
my.hclust <- hclust(my.dist, method = 'average')
my.hclust$labels <- pData(my.rma2)$sample.labels
plot(my.hclust, cex=0.75, main='Comparison of Biological Replicates',
     xlab='Correlation')
