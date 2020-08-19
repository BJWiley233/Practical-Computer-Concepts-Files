library(GEOquery)
my.gse2 <- "GSE103223"
my.geo.gse2 <- getGEO(GEO=my.gse2,
                      destdir="./geo_downloads",
                      getGPL=FALSE)
my.geo.gse2 <- my.geo.gse2[[1]]
getGEOSuppFiles(my.gse2, makeDirectory=T, baseDir="~/geo_downloads")

untar(paste0("geo_downloads/",my.gse2,"/",my.gse2,"_RAW.tar"), 
      exdir=paste0("geo_downloads/",my.gse2,"/CEL"))
list.files(paste0("geo_downloads/",my.gse2,"/CEL"))
boxplot(my.geo.gs2)


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
library(oligo)
celfiles <- list.files(paste0("geo_downloads/",my.gse2,"/CEL"), pattern = "*.CEL", full=T)
rawData <- read.celfiles(celfiles)
filename <- sampleNames(rawData)
pData(rawData)$filename <- filename
pData(rawData)$group <- c(rep('leukemia', 3), rep('healthy', 3), rep('leukemia', 3))

head(exprs(gset[[1]]))
#http://supportupgrade.bioconductor.org/p/94707/#94736
oligo::boxplot(rawData, target='core')

normData <- rma(rawData)
library(RColorBrewer)
display.brewer.all()
level.pal = brewer.pal(2, 'Spectral')
pData(normData)$group <- as.factor(pData(normData)$group)
level.cols = level.pal[unname(pData(normData)$group)]

boxplot(normData, col = level.cols)
apply(exprs(normData), 2, max)
head(exprs(normData))
head(exprs(my.geo.gse2))
test <- affy::rma(my.geo.gse2)
boxplot(log2(exprs(my.geo.gse2)))
###########################################
# library(affyPLM)
# test <- affyPLM::normalize.ExpressionSet.scaling(my.geo.gse2, transfn='log')
# 
# boxplot(my.geo.gse2)

ex <- exprs(my.geo.gse2)
apply(ex, 2, max)
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0) ||
  (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)

palette(c("red","blue"))
order(fl)
groups <- as.factor(c(rep('leukemia', 3), rep('healthy', 3), rep('leukemia', 3)))
ex <- ex[, order(groups)]
fl <- groups[order(groups)]

colnames(ex)
#boxplot(ex, boxwex=0.6, notch=T, main=title, outline=FALSE, las=2, col=fl)
boxplot(ex, outline=FALSE, col=fl, notch=T, las=2)
labels <- c("leukemia","healthy")
legend("topleft", labels[order(labels)], fill=palette(), bty="n")



exprs(my.geo.gse2) <- log2(exprs(my.geo.gse2))

pData(my.geo.gse2)$group <- groups
design <- model.matrix(~ group + 0,  pData(my.geo.gse2))
colnames(design) <- levels(fl)
fit_leuk <- lmFit(my.geo.gse2, design)
cont.matrix <- makeContrasts(healthy-leukemia, levels=design)
fit2 <- contrasts.fit(fit_leuk, cont.matrix)
fit_eb <- eBayes(fit2)
tT <- topTable(fit_eb, adjust="fdr", sort.by="B", number=250)
## "B" for the lods or B-statistic.
## gets top 25 lods sorted from highest to lowest
## maybe combination of high -log10p and different dm?
tT25 <- topTable(fit_eb, adjust="fdr", sort.by="B", number=25)
rownames(fit_eb$lods)[order(-fit_eb$lods)][1:25]

## get gene names this way?

affyids <- rownames(tT25)
library(biomaRt)

?useMart
ensembl = useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")
listFilters(ensembl)
bm <- getBM(attributes = c('affy_hugene_2_0_st_v1', 'hgnc_symbol'), 
      filters = 'affy_hugene_2_0_st_v1',
      values = affyids, mart=ensembl)
attrs <- listAttributes(ensembl)
pData(netaffxProbeset)[pData(netaffxProbeset)$transcriptclusterid == 16650883, ]
labels3


library(pd.hugene.2.0.st)
?pd.hugene.2.0.st
vignette(pd.hugene.2.0.st)
data(pmSequence)
data(neta)
featureData(my.geo.gse2)
featureNames(my.geo.gse2)
#featureNames(my.geo.gse2) == featureNames(normData)
#as.integer(rownames(tT25)) %in% pData(netaffxProbeset)$transcriptclusterid

probeset <- list.files(system.file("extdata", package="pd.hugene.2.0.st"), 
                       pattern=".*Probeset", full=T)
load(probeset)
as.integer(rownames(tT25)) %in% pData(netaffxProbeset)$transcriptclusterid
names(pData(netaffxProbeset))
16872223 %in% pData(netaffxProbeset)$transcriptclusterid
pData(netaffxProbeset)[pData(netaffxProbeset)$transcriptclusterid == 16872223, ]

## top 25 e-bayes
match_idx <- match(as.integer(rownames(tT25)), pData(netaffxProbeset)$transcriptclusterid)
data_probes1 <- pData(netaffxProbeset)[match_idx, ]
dim(data_probes1)
colnames(data_probes1)
data_probes1$transcriptclusterid == as.integer(rownames(tT25))
head(data_probes1)
probe_gene1 <- data_probes1[, c("transcriptclusterid", "geneassignment")]
genes1 <- unlist(lapply(probe_gene1$geneassignment, function(x) trimws(strsplit(x, "//")[[1]][2])))
probe_gene1$gene <- genes1
probe_gene1$transcriptclusterid
labels3 <- ifelse(is.na(probe_gene1$gene), probe_gene1$transcriptclusterid, probe_gene1$gene)

library(genefilter)
pat <- ".*(leukemia|healthy).*"
my.geo.gse2$status <- as.factor(sub(pat, '\\1', my.geo.gse2$title))
data_tt <- rowttests(my.geo.gse2, 'status')
logtrans = -log10(data_tt$p.value)
## this does largest difference dm either up or down regulated
## will be the most left and most right in plot
o1 = order(abs(data_tt$dm), decreasing=T)[1:25]
data_tt[o1, ]


plot(data_tt$dm, logtrans, pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p), xlim=c(-5,5))
points(data_tt$dm[o1], logtrans[o1], pch=18, col = 'blue')
with(as.data.frame(cbind(data_tt$dm[o1], logtrans[o1])), 
     text(V2~V1, labels=rownames(data_tt[o1, ]), pos = 4, cex = 0.6))

match_idx2 <- match(as.integer(rownames(data_tt[o1, ])), pData(netaffxProbeset)$transcriptclusterid)
data_probes2 <- pData(netaffxProbeset)[match_idx2, ]
dim(data_probes2)
data_probes2$transcriptclusterid == as.integer(rownames(data_tt[o1, ]))
head(data_probes2)
probe_gene <- data_probes2[, c("transcriptclusterid", "geneassignment")]

library(stringr)
trimws(strsplit(probe_gene$geneassignment[1:3], "//")[[1]][2])

## top 25 t-test does top 25 by differential log fold
genes <- unlist(lapply(probe_gene$geneassignment, function(x) trimws(strsplit(x, "//")[[1]][2])))
probe_gene$gene <- genes
probe_gene$transcriptclusterid
probe_gene$probeid <- as.integer(rownames(data_tt[o1, ]))
labels2 <- ifelse(is.na(probe_gene$gene), probe_gene$probeid, probe_gene$gene)

plot(data_tt$dm, logtrans, pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p), xlim=c(-5,5))
points(data_tt$dm[o1], logtrans[o1], pch=18, col = 'blue')
with(as.data.frame(cbind(data_tt$dm[o1], logtrans[o1])), 
     text(V2~V1, labels=labels2, pos = 4, cex = 0.6))

## top 25 e-bayes
o2 <- match(rownames(tT25), rownames(data_tt))
points(data_tt$dm[o2], logtrans[o2], pch=18, col = 'red')
with(as.data.frame(cbind(data_tt$dm[o2], logtrans[o2])), 
     text(V2~V1, labels=labels3, pos = 4, cex = 0.6, col='red'))

ebayes_df <- data_tt[o2, ]
ebayes_df$gene <- labels3
#https://www.nature.com/articles/gene201035
ebayes_df$level <- ifelse(ebayes_df$dm < 0, 'upregulated in cancer', 'downregulated in cancer')


o3 <- match(rownames(tT), rownames(data_tt))
match_idx3 <- match(as.integer(rownames(data_tt[o3, ])), pData(netaffxProbeset)$transcriptclusterid)
data_probes3 <- pData(netaffxProbeset)[match_idx3, ]
data_probes3$transcriptclusterid == as.integer(rownames(data_tt[o3, ]))
probe_gene3 <- data_probes3[, c("transcriptclusterid", "geneassignment")]
genes3 <- unlist(lapply(probe_gene3$geneassignment, function(x) trimws(strsplit(x, "//")[[1]][2])))
probe_gene3$gene <- genes3
probe_gene3$probeid <- as.integer(rownames(data_tt[o3, ]))
labels4 <- ifelse(is.na(probe_gene3$gene), probe_gene3$probeid, probe_gene3$gene)
ebayes_df3 <- data_tt[o3, ]
ebayes_df3$gene <- labels4
#https://www.nature.com/articles/gene201035
ebayes_df3$level <- ifelse(ebayes_df3$dm < 0, 'upregulated in cancer', 'downregulated in cancer')

up <- ebayes_df3[ebayes_df3$level=='upregulated in cancer', ]
'NFKBIA' %in% up$gene


o4 <- order(abs(data_tt$dm), decreasing=T)[1:300]
match_idx4 <- match(as.integer(rownames(data_tt[o4, ])), pData(netaffxProbeset)$transcriptclusterid)
data_probes4 <- pData(netaffxProbeset)[match_idx4, ]
data_probes4$transcriptclusterid == as.integer(rownames(data_tt[o4, ]))
probe_gene4 <- data_probes4[, c("transcriptclusterid", "geneassignment")]
genes4 <- unlist(lapply(probe_gene4$geneassignment, function(x) trimws(strsplit(x, "//")[[1]][2])))
probe_gene4$gene <- genes4
probe_gene4$probeid <- as.integer(rownames(data_tt[o4, ]))
labels5 <- ifelse(is.na(probe_gene4$gene), as.integer(probe_gene4$probeid), probe_gene4$gene)
ebayes_df4 <- data_tt[o4, ]
ebayes_df4$gene <- labels5
#https://www.nature.com/articles/gene201035
ebayes_df4$level <- ifelse(ebayes_df4$dm < 0, 'upregulated in cancer', 'downregulated in cancer')
up <- ebayes_df4[ebayes_df4$level=='upregulated in cancer', ]
'TREM1' %in% up$gene
up$gene[is.na(as.numeric(up$gene))]

down <- ebayes_df4[ebayes_df4$level=='downregulated in cancer', ]
down_genes <- down$gene[is.na(as.numeric(down$gene))]
"IGKV2-24" %in% down_genes
