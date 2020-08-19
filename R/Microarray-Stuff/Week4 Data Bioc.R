# Getting data into Bioconductor
# https://kasperdanielhansen.github.io/genbioconductor/html/Getting_Data_into_Bioconductor.html
library(ShortRead)

fastqDir <- system.file("extdata", "E-MTAB-1147", package = "ShortRead")
fastqPath <- list.files(fastqDir, pattern = "*.fastq.gz", full.names = TRUE)[1]
reads <- readFastq(fastqPath)
#############
fa <- readFasta("C:/Users/bjwil/datasets/human_g1k_v37_decoy.fasta.gz")
id(fa)[22]
length(sread(fa)[[22]])
##############
reads
width(reads)
fqFile = FastqFile(fastqPath)
class(reads)
class(fqFile)
reads = readFastq(fqFile)
sread(reads)[1:2]
quality(reads)[1:2]

as(quality(reads), "matrix")[1:2, 1:10]

## Rsamtools
library(Rsamtools)

bamPath <- system.file("extdata", "ex1.bam", package = "Rsamtools")
bamFile <- BamFile(pamPath)
###
bamFile <- BamFile(bamFilePath)
seqinfo(bamFile)
gr <- GRanges(seqnames = "Scchr13",
              ranges = IRanges(start=c(800000),
                               end=c(801000)))
params = ScanBamParam(which = gr, what = scanBamWhat())
aln = scanBam(bamFile, param = params)
aln[[1]]$pos
tab = table(aln[[1]]$pos)
sum(tab[tab > 1])
#####
class(bamFile)
length(bamFile)
aln <- scanBam(bamFile)

flag(aln)
class(aln)
ss <- aln[[1]]$seq
class(ss)

alns <- aln[[1]]
names(aln)
names(alns)
class(alns)
lapply(alns, function(x) x[1])
summary(width(alns$seq))

library(GenomicAlignments)
browseVignettes("GenomicAlignments")

yieldSize(bamFile) <- 1
open(bamFile)
scanBam(bamFile)[[1]]$seq
close(bamFile)
yieldSize(bamFile) <- NA

gr <- GRanges(seqnames = "seq2",
              ranges = IRanges(start=c(100, 1000),
                               end=c(1500, 2000)))
params = ScanBamParam(which = gr, what = scanBamWhat())
aln = scanBam(bamFile, param = params)
names(aln)
aln[[1]]$pos 
aln[[1]]$qwidth
x = aln[[1]]$pos 
x = (aln[[1]]$pos + aln[[1]]$qwidth)
summary(x)
x[length(x) - 4:0]
quickBamFlagSummary(bamFile)

bamView <- BamViews(bamPath)
bamView
aln <- scanBam(bamView)
names(aln)
names(aln[[1]][[1]])
length(aln[[1]])
length(aln[[1]][[1]])
lapply(aln[[1]][[1]], function(x) x[1:5])
bamRanges(bamView) <- gr
aln <- scanBam(bamView)
x = aln[[1]][[1]]$pos
x[length(x) - 4:0]
?scanBamFlag()
ScanBamParam()
getClass("ScanBamParam")
#getClass("student")


##### oligo

library(GEOquery)
getGEOSuppFiles("GSE38792")
list.files("GSE38792")
untar("GSE38792/GSE38792_RAW.tar", exdir = "GSE38792/CEL")
list.files("GSE38792/CEL")

library(oligo)
celfiles <- list.files("GSE38792/CEL", pattern = ".CEL.gz$", full=T)
length(celfiles)

rawData = read.celfiles(celfiles)
rawData
getClass("GeneFeatureSet")
class(ExpressionSet())
getClass("ExpressionSet")

dim(exprs(rawData))
exprs(rawData)[1:4, 1:6]

max(exprs(rawData))
?apply
length(apply(exprs(rawData), 2, max))



#getClass("GeneFeatureSet")
#getClass("NChannelSet")
#getClass("FeatureSet")

filename <- sampleNames(rawData)
rownames(rawData)
library(stringr)
## look behing "(?<=...) 
## wild card "."
## The lazy .*? guarantees that the quantified dot only matches 
    # as many characters as needed for the rest of the pattern to succeed.
    # https://www.rexegg.com/regex-quantifiers.html#lazy_solution
sample_names <- str_extract(filename, "(?<=\\_)(.*?)(?=\\.)")
sampleNames(rawData) <- sample_names
pData(rawData)$group <- ifelse(grepl("^OSA", sampleNames(rawData)),
                               "OSA", 
                               "Control")
pData(rawData)$filename <- filename
oligo::boxplot(rawData, target = "core")
normData <- rma(rawData)
"8149273" %in% featureNames(normData)
class(rawData)
class(normData)
featureNames(rawData)
featureNames(normData)
featureNames(control_data)
boxplot(normData)
exprs(normData)[1, ]
apply(exprs(normData), 2, mean)

pData(rawData)$group == "Control"
control_data <- normData[, pData(rawData)$group == "Control"]

mean(exprs(control_data)["8149273", ])

rawData$group = pData(rawData)$group


## limma
library(limma)
library(leukemiasEset)
data("leukemiasEset")

leukemiasEset$LeukemiaType
table(leukemiasEset$LeukemiaType)
ourData = leukemiasEset[, leukemiasEset$LeukemiaType %in% c("ALL", "NoL")]

ourData$LeukemiaType <- factor(ourData$LeukemiaType)

new_names = paste0(sub("\\..*", "", sampleNames(ourData)), "-", ourData$LeukemiaType)
sampleNames(ourData) = new_names

library(affyQCReport)
library(CLL)
data("CLLbatch")
library(oligo)
library("affyPLM")
?fitPLM
class(fitPLM(CLLbatch))
#boxplot(fitPLM(CLLbatch))
exprs(CLLbatch)
CLLrma <- affy::rma(CLLbatch)
exprs(ourData)
library(arrayQualityMetrics)
arrayQualityMetrics(ourData)
library(convert)
fitPLM(as(ourData, "eSet"))

library(genefilter)
dd = dist2(log2(exprs(ourData)))
diag(dd) = 0
dd.row <- as.dendrogram(hclust(as.dist(dd)))
row.ord <- order.dendrogram(dd.row)
library(latticeExtra)
legend = list(top=list(fun=dendrogramGrob,
                       args=list(x=dd.row, side="top")
                       )
              )
library(RColorBrewer)
cols = colorRampPalette(brewer.pal(8, "PiYG"))(25)
library(viridisLite)
cols =  rev(inferno(20))
lp = levelplot(dd[row.ord, row.ord],
               scales=list(x=list(rot=90)), xlab="",
               ylab="", legend=legend, col.regions = cols)
lp


ourDatatt <- rowttests(ourData, "LeukemiaType")
ourData$LeukemiaType
#model.matrix(~ ourData$LeukemiaType)
logtrans = -log10(ourDatatt$p.value)
plot(ourDatatt$dm, logtrans, pch=".", xlab="log-ratio",
       ylab=expression(-log[10]~p))
o1 = order(abs(ourDatatt$dm), decreasing=T)[1:25]
points(ourDatatt$dm[o1], logtrans[o1], pch=18, col = 'blue')
plot(ourDatatt$dm, ebfit$p.value[, 2], pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p))

leukemiasEset$LeukemiaType
table(leukemiasEset$LeukemiaType)
ourData = leukemiasEset[, leukemiasEset$LeukemiaType %in% c("ALL", "NoL")]

ourData$LeukemiaType <- factor(ourData$LeukemiaType)
##
design = model.matrix(~ normData$group)
fit_norm = lmFit(normData, design)
ebfit_norm = eBayes(fit_norm)
topTable(ebfit_norm, n=10)

design = model.matrix(~ ourData$LeukemiaType)
fit <- lmFit(ourData, design)
ebfit <- eBayes(fit)
plot(ourDatatt$dm, logtrans, pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p))

toptable <- topTable(ebfit, number = length(ebfit$F.p.value))
toptable$pvalue = toptable$P.Value
bio_volcano(toptable, fc.col="logFC", label.row.indices=1:10, main="leukemia", add.lines=FALSE)


logtrans = -log10(toptable$P.Value)
plot(toptable$logFC, logtrans, pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p))

plot(toptable$logFC, -log10(toptable$P.Value))
abline(h=-log10(.01))

genename = rownames(topTable(ebfit, n=1))
tapply(exprs(ourData)[genename, ], ourData$LeukemiaType, mean)


x <- list(which(ourData$LeukemiaType %in% "ALL"),
          which(! ourData$LeukemiaType %in% "ALL"))
test = do.call(cbind, lapply(x, function(i) rowMeans(exprs(ourData)[, i])))
class(test)
sort(apply(as.data.frame(test), 1, diff), decreasing=T)[1:10]

sort(toptable$logFC, decreasing = T)[1:10]


design2 <- model.matrix(~ ourData$LeukemiaType - 1)
colnames(design2) <- c("ALL", "NoL")
fit2 <- lmFit(ourData, design2)
contrasts.matrix <- makeContrasts(contrasts="ALL-NoL", levels = design2)
fit2_contasts <- contrasts.fit(fit2, contrasts.matrix)
fit2_eb <- eBayes(fit2_contasts)
topTable(fit2_eb, n=10)

####################
library(minfi)
library(minfiData)
data("RGsetEx")
RGsetEx
sampleNames(RGsetEx)
pp_RGsetEx <- preprocessFunnorm(RGsetEx)
exprs(pp_RGsetEx)
pp_RGsetEx$status
getIslandStatus(pp_RGsetEx)
assays(pp_RGsetEx)
pData(pp_RGsetEx)
browseVignettes("minfi")

open_sea <- pp_RGsetEx[getIslandStatus(pp_RGsetEx) == "OpenSea",]
open_sea$status
getBeta(open_sea)
beta_means <- apply(getBeta(open_sea), MARGIN = 2, mean)
colMeans(getBeta(open_sea))
beta_means[open_sea$status == "normal"] 

mean(beta_means[open_sea$status == "normal"]) -
mean(beta_means[open_sea$status != "normal"])

mean(getBeta(open_sea)[, open_sea$status == "normal"]) -
mean(getBeta(open_sea)[, open_sea$status != "normal"])

library(GEOquery)
getGEOSuppFiles("GSE68777")
getwd()
untar("GSE68777/GSE68777_RAW.tar", exdir = "GSE68777/idat")

list.files("GSE68777/idat", pattern = "idat")
rgSet <- read.metharray.exp("GSE68777/idat")
rgSet <- rgSet_

pData(rgSet)
head(sampleNames(rgSet))
geoMat <- getGEO("GSE68777")
pD.all <- pData(geoMat[[1]])
colnames(pD.all)
pD <- pD.all[, c("title", "geo_accession", "characteristics_ch1.1", "characteristics_ch1.2")]
head(pD)
names(pD)[c(3,4)] <- c("group", "sex")
pD$group <- sub("^diagnosis: ", "", pD$group)
pD$sex <- sub("^Sex: ", "", pD$sex)

dim(pD)
head(sampleNames(rgSet))
sampleNames(rgSet) <- sub(".*_5", "5", sampleNames(rgSet))
head(pD)
rownames(pD) <- pD$title
## guarantee same order 
pD <- pD[sampleNames(rgSet), ]
grSet <- preprocessQuantile(rgSet)
granges(grSet)
head(getIslandStatus(grSet), 20)


library(airway)
data(airway)
airway
assay(airway)[1:3, 1:3]     
airway$dex <- relevel(airway$dex, "untrt")

library(edgeR)
?edgeR
dge <- DGEList(counts = assay(airway, "counts"),
               group = airway$dex)
airway$SampleName
## the number 0 specifies the row names
dge$samples <- merge(dge$samples,
                     as.data.frame(colData(airway)),
                     by = 0)
#colSums(assay(airway))
dge$genes <- data.frame(name = names(rowRanges(airway)),
                        stringsAsFactors = F)
dge <- calcNormFactors(dge)






##1
BiocManager::install("yeastRNASeq")
library(yeastRNASeq)
fastqFilePath <- system.file("reads", "wt_1_f.fastq.gz", package = "yeastRNASeq")
reads <- readFastq(fastqFilePath)
sread(reads)
sum(grepl("^.{4}A", sread(reads)))/length(reads)

##2
qualityScores(reads[1:10])
as.raw(qualityScores(reads[1:10]))
mean(as(quality(reads),"matrix")[, 5])

##3
BiocManager::install("leeBamViews")
library(leeBamViews)
bamFilePath <- system.file("bam", "isowt5_13e.bam", package="leeBamViews")
bamFile <- BamFile(bamFilePath)
seqinfo(bamFile)
gr <- GRanges(seqnames = "Scchr13",
              ranges = IRanges(start=c(800000),
                               end=c(801000)))
params = ScanBamParam(which = gr, what = scanBamWhat())
aln = scanBam(bamFile, param = params)
aln[[1]]$pos
tab = table(aln[[1]]$pos)
sum(tab[tab > 1])

##4
bpath <- list.files(system.file("bam", package = "leeBamViews"), pattern = "bam$", full = T)
bamFiles <- BamFileList(bpath)
gr <- GRanges(seqnames = "Scchr13",
              ranges = IRanges(start=c(807762),
                               end=c(808068)))
params = ScanBamParam(which = gr, what = scanBamWhat())

alignments <- function(x) {
    count = length(scanBam(x, param = params)[[1]]$pos)
    return(count)
}
mean(sapply(bamFiles, alignments))

##5
library(GEOquery)
getGEOSuppFiles("GSE38792")
list.files("GSE38792")
untar("GSE38792/GSE38792_RAW.tar", exdir = "GSE38792/CEL")
list.files("GSE38792/CEL")

library(oligo)
celfiles <- list.files("GSE38792/CEL", pattern = ".CEL.gz$", full=T)
rawData = read.celfiles(celfiles)

filename <- sampleNames(rawData)
rownames(rawData)
library(stringr)
sample_names <- str_extract(filename, "(?<=\\_)(.*?)(?=\\.)")
sampleNames(rawData) <- sample_names
pData(rawData)$group <- ifelse(grepl("^OSA", sampleNames(rawData)),
                               "OSA", 
                               "Control")
pData(rawData)$filename <- filename
normData <- rma(rawData)
control_data <- normData[, pData(normData)$group == "Control"]
mean(exprs(control_data)["8149273", ])


##6
design = model.matrix(~ normData$group)
fit_norm = lmFit(normData, design)
ebfit_norm = eBayes(fit_norm)
topTable(ebfit_norm, n=10)


##7
?topTable
topTable(ebfit_norm, n = length(ebfit_norm$F.p.value), p.value = 0.05)
sum(topTable(ebfit_norm, n = length(ebfit_norm$F.p.value))$P.Value <= 0.05)

##8 
BiocManager::install("minfiData")
library(minfi)
library(minfiData)
data("RGsetEx")
RGsetEx
sampleNames(RGsetEx)
pp_RGsetEx <- preprocessFunnorm(RGsetEx)
exprs(pp_RGsetEx)
pp_RGsetEx$status
getIslandStatus(pp_RGsetEx)
assays(pp_RGsetEx)
pData(pp_RGsetEx)
browseVignettes("minfi")

open_sea <- pp_RGsetEx[getIslandStatus(pp_RGsetEx) == "OpenSea",]
open_sea$status
getBeta(open_sea)
beta_means <- apply(getBeta(open_sea), MARGIN = 2, mean)
colMeans(getBeta(open_sea))
beta_means[open_sea$status == "normal"] 

mean(beta_means[open_sea$status == "normal"]) -
    mean(beta_means[open_sea$status != "normal"])

mean(getBeta(open_sea)[, open_sea$status == "normal"]) -
    mean(getBeta(open_sea)[, open_sea$status != "normal"])

##9
library(AnnotationHub)
ah <- AnnotationHub()
qh <- query(ah, c("Caco2", "Homo sapiens", "AWG"))
qh
data <- qh[["AH22442"]]            
seqnames(data)
getProbeInfo(RGsetEx)
CpG_450k <- granges(pp_RGsetEx)
seqnames(CpG_450k)
sum(countOverlaps(data, CpG_450k) >= 1)

##10
BiocManager::install("zebrafishRNASeq")
library(zebrafishRNASeq)
data(zfGenes)
grepl("^ERCC", rownames(zfGenes))
nrow(zfGenes[!grepl("^ERCC", rownames(zfGenes)), ])
new_zfGenes <- zfGenes[!grepl("^ERCC", rownames(zfGenes)), ]

library(DESeq2)
names(new_zfGenes) <- ifelse(grepl("^Ctl", names(new_zfGenes)),
                             "Control", "Treatment")
design <- model.matrix(~ names(new_zfGenes))
as.data.frame(condition=colnames(new_zfGenes))
coldata <- data.frame(condition=colnames(new_zfGenes))
DESeq_zfGenes <- DESeqDataSetFromMatrix(new_zfGenes, coldata, design = ~ condition)
dds <- DESeq2::DESeq(DESeq_zfGenes)
res <- results(dds)
sum(res$padj <= 0.05, na.rm=T)
