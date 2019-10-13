library(Biobase)
library(ALL)
library(genefilter)
require(BiocInstaller)
#biocLite("hgu95av2.db")

data("ALL")
class(ALL)
bcell <- grep("^B", as.character(ALL$BT))
types <- c("NEG", "BCR/ABL")
moltyp <- which(as.character(ALL$mol.bio) %in% types)
ALL_bcrneg <- ALL[, intersect(bcell, moltyp)]
ALL_bcrneg$mol.biol <- factor(ALL_bcrneg$mol.biol)
ALL_bcrneg$BT <- factor(ALL_bcrneg$mol.biol)
varCut = 0.5
filt_bcrneg <- nsFilter(ALL_bcrneg, require.entrez=TRUE,
                       require.GOBP=TRUE, remove.dupEntrez=TRUE,
                       var.func=IQR, var.cutoff=varCut,
                       feature.exclude="^AFFX")
filt_bcrneg$filter.log
ALLfilt_bcrneg <- filt_bcrneg$eset


types <- c("ALL1/AF4", "BCR/ABL")
moltyp <- which(as.character(ALL$mol.bio) %in% types)
ALL_af4bcr <- ALL[, intersect(bcell, moltyp)]
ALL_af4bcr$mol.biol <- factor(ALL_af4bcr$mol.biol)
ALL_af4bcr$BT <- factor(ALL_af4bcr$mol.biol)
varCut = 0.5
filt_af4bcr <- nsFilter(ALL_af4bcr, require.entrez=TRUE,
                       require.GOBP=TRUE, remove.dupEntrez=TRUE,
                       var.func=IQR, var.cutoff=varCut,
                       feature.exclude="^AFFX")
ALLfilt_af4bcr <- filt_af4bcr$eset
filt_af4bcr$filter.log

?eapply
myPos <- eapply(hgu95av2MAP, function (x) grep("^17p", x, value = T))
length(unlist(myPos))

ppc <- function(x){
        ret <- paste("^", x, sep = "")
        return(ret)
}
ppc("xx")

ppcNum <- function(x, y){
        ret <- paste("^", x, "p", sep = "")
        ret
        return(grep(ret, y, value=T))
}
length(ppcNum("17", hgu95av2MAP))
#BiocManager::install("convert", version = "3.8")
library(convert)
as(object, "ExpressionSet")

dataDirectory <- system.file("extdata", package = "Biobase")
exprsFile = file.path(dataDirectory, "exprsData.txt")
exprs <- as.matrix(read.table(exprsFile, header = T, sep = "\t", row.names=1, as.is = T))
pDataFile = file.path(dataDirectory, "pData.txt")
pData = read.table(pDataFile,
                   row.names=1, header=TRUE, sep="\t")
all(rownames(pData) == colnames(exprs))
class(pData)
colnames(pData)
sapply(pData, class)
metadata <- data.frame(labelDescription=c("Patient gender",
                                         "Case/control status", "Tumor progress on XYZ scale"),
                       row.names=c("gender", "type", "score"))
adf <- new("AnnotatedDataFrame", data=pData,
          varMetadata=metadata)
pData(adf)

experimentData <- new("MIAME", name="Pierre Fermat",
                     lab="Francis Galton Lab",
                     contact="pfermat@lab.not.exist",
                     title="Smoking-Cancer Experiment",
                     abstract="An example ExpressionSet",
                     url="www.lab.not.exist",
                     other=list(notes="Created from text files"))

exampleSet = new("ExpressionSet", exprs=exprs,
                 phenoData=adf, experimentData=experimentData,
                 annotation="hgu95av2")
exprs(exampleSet)                 
assayDataElement(exampleSet,'exprs')
exampleSet$gender[1:5]
featureNames(exampleSet)[1:5]
sampleNames(exampleSet)

vv <- exampleSet[1:5, 1:3]
exprs(vv)
exprs(exampleSet[1:5, 1:3])

x <- exprs(exampleSet[, 1])
y <- exprs(exampleSet[, 3])
library(ggplot2)
plot(x, y, log="xy", 
     col=rgb(0,100,0,50,maxColorValue=255), pch=16, 
     main = paste(colnames(x), "by", colnames(y), sep = " "),
     xlab = colnames(x),
     ylab = colnames(y))
?abline
abline(0, 1)
library("CLL")
library(oligo) # library("Biostrings") # library("matchprobes")
library("hgu95av2probe")
library("hgu95av2cdf")
library("RColorBrewer")
bases <- basecontent(hgu95av2probe$sequence)
head(hgu95av2probe)
View(hgu95av2cdf)
iab <- with(hgu95av2probe, xy2indices(x, y, cdf = "hgu95av2cdf"))
with(hgu95av2probe, xy2indices(x, y))
probedata <- data.frame(int=rowMeans(log2(exprs(CLLbatch)[iab, ])),
                        gc=bases[, 'C'] + bases[, 'G'])
colorfunction <- colorRampPalette(brewer.pal(9, "YlGnBu"))                     
mycolors <- colorfunction(length(unique(probedata$gc)))
label <- expression(log[2]~intensity)
boxplot(int ~ gc, data=probedata, col=mycolors,
        outline=TRUE, xlab="Number of G and C",
        ylab=label, main="")
tab <- table(probedata$gc)
library("geneplotter")
gcUse <- as.integer(names(sort(tab, decreasing=TRUE)[1:10]))
col <- colorfunction(12)[-(1:2)]
par(mar=c(5,4,2,6))
multidensity(int ~ gc, data=subset(probedata,
                                   gc %in% gcUse), xlim=c(6, 12.5),
             col=colorfunction(12)[-(1:2)],
             lwd=2, main="", xlab=label
             , legend = F
             )
legend("bottomleft",
        legend = sort(gcUse),
        fill = col,
        cex = 1,
       inset=c(1.05,.15),
       xpd=TRUE,
       bty = "n")

par(mfrow=c(1,1))
multiecdf(int ~ gc, data=subset(probedata,
                                   gc %in% gcUse), xlim=c(6, 12.5),
             col=colorfunction(12)[-(1:2)],
             lwd=2, main="", xlab=label)

