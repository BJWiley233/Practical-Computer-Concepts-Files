library(ALL)
data(ALL)
?ALL
featureNames(ALL)
experimentData(ALL)
?ALL
exprs(ALL)[, 1:4]
exprs(ALL)[1:4, ]
head(pData(ALL))
ALL$sex
featureData(ALL)

ids = featureNames(ALL)[1:5]
ids

library(hgu95av2.db)
as.list(hgu95av2ENTREZID)[1:30]
hgu95av2ENTREZID[ids]
names(pData(ALL))
varLabels(ALL)

library(airway)
data(airway)
airway
colData(airway)
BiocManager::install("GenomicFiles")
library(GenomicFiles)
as.list(metadata(airway))
length(colnames(airway))
length(rownames(airway))
ncol(airway)
nrow(airway)

?airway ## RNAseq
assayNames(airway)
assay(airway, "counts")

length(rowRanges(airway))
rowRanges(airway)

## how many genes

sum(elementNROWS(rowRanges(airway)))
start(airway)
#gr = GRanges(seqnames = "1", ranges = IRanges(start=1, end=10^9))
gr = GRanges(seqnames = "1", ranges = IRanges(start=1, end=10^7))
subsetByOverlaps(airway, gr)

#airway[all(seqnames(airway) == "1")]
#airway[unlist(runValue(seqnames(airway) == "1"))]

BiocManager::install("GEOquery")
library(GEOquery)
### https://www.ebi.ac.uk/arrayexpress/search.html?query=GSE11675
eList = getGEO("GSE11675")
eset = getGEO("GSE788")
sampleNames(eset[[1]])
class(eset[[1]])
expressions = as.data.frame(exprs(eset[[1]]))
mean(expressions$GSM9024)
eData = eList[[1]]
names(pData(eList[[1]]))

eList2 = getGEOSuppFiles("GSE11675")
eList2

library(biomaRt)
head(listMarts())
listMarts()
mart <- useMart("ensembl")
mart
head(listDatasets(mart))
ensembl <- useDataset("hsapiens_gene_ensembl", mart)
values <- c("202763_at", "209310_s_at", "207500_at")

library(stringr)
dim(listAttributes(ensembl))
grep("affy_hg_u133_plus_2", listFilters(ensembl)$name, value = T)
dim(listFilters(ensembl))
test = listAttributes(ensembl)
grep("^affy", test$name, value=T)

getBM(attributes = c("ensembl_gene_id", "affy_hg_u133_plus_2"),
      filters = "affy_hg_u133_plus_2", values = values, mart = ensembl)

getBM(attributes = c("ensembl_gene_id", "affy_hg_u133_plus_2"),
      values = values, mart = ensembl)
attributePages(ensembl)
listAttributes(ensembl, page = "feature_page")[, 1:2]
names(listAttributes(ensembl, page = "feature_page"))

##1
library(ALL)
data(ALL)
mean(exprs(ALL)[, 5])
mean(exprs(ALL[, 5]))

##2
library(biomaRt)
listMarts()
mart <- useMart(host='feb2014.archive.ensembl.org',biomart="ENSEMBL_MART_ENSEMBL")
listDatasets(mart)
ensembl <- useDataset("hsapiens_gene_ensembl", mart)
grep("^affy", listAttributes(ensembl)$name, value = T)
featureNames(ALL)

annot <- getBM(attributes = c("ensembl_gene_id", "affy_hg_u95av2"), mart = ensembl,
               filter = "affy_hg_u95av2", values = featureNames(ALL))

library(dplyr)
test <- annot %>% 
    group_by(affy_hg_u95av2) %>% 
    summarise(count = n()) %>% 
    filter(count > 1)
nrow(test)
sum(table(annot[, 2]) > 1)

##3 
grep("^chromosome", listAttributes(ensembl)$name, value = T)
annot_chrom <- getBM(attributes = c("ensembl_gene_id", "affy_hg_u95av2", "chromosome_name"), 
                     mart = ensembl, filter = c("affy_hg_u95av2"), 
                     values = list(featureNames(ALL)))
test <- annot_chrom %>% 
    group_by(affy_hg_u95av2) %>%
    filter(chromosome_name %in% 1:22) %>%
    summarise(count = n())

annot_chrom <- getBM(## the columns to get
                     attributes = c("ensembl_gene_id", "affy_hg_u95av2", "chromosome_name"), 
                     ## the Mart object to use
                     mart = ensembl, 
                     ## the columns to filter
                     filter = c("affy_hg_u95av2", "chromosome_name"), 
                     ## the values of column filters
                     values = list(featureNames(ALL), 1:22)
                     )
length(table(annot_chrom[, 2]))

##4
BiocManager::install("minfiData")
library(minfiData)
data(MsetEx)    
MsetEx
?MsetEx
#https://www.bioconductor.org/help/course-materials/2015/BioC2015/methylation450k.html
sampleNames(MsetEx) == "5723646052_R04C01"
sampleNames(MsetEx)
class(MsetEx)
getMeth(MsetEx)[, "5723646052_R04C01"]
mean(getMeth(MsetEx)[, "5723646052_R04C01"])

## 5
library(GEOquery)
eset = getGEO("GSE788")
sampleNames(eset[[1]])

expressions = as.data.frame(exprs(eset[[1]]))
mean(expressions$GSM9024)

mean(exprs(eset[[1]][, 2]))

##6
library(airway)
data(airway)
mean(airway$avgLength)

##7
colData(airway)["SRR1039512", ]
sum(assay(airway[, 3]) >= 1)


##8
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

txdb = TxDb.Hsapiens.UCSC.hg19.knownGene

seqlevels(txdb) <- paste0("chr", 1:22)
seqlevelsStyle(txdb) <- "NCBI"
exs = exons(txdb)

subsetByOverlaps(airway, exs)
#subsetByOverlaps(exs, airway)

##9
sample = airway[, colnames(airway) == "SRR1039508"]
rowRanges(sample)
subsetByOverlaps(sample, exs)
assays(sample)[[1]]
sum(assays(subsetByOverlaps(sample, exs))[[1]])/
    sum(assays(sample)[[1]])

##10
trans =  transcripts(txdb)
subset_sample_txdb = subsetByOverlaps(sample, trans)
subset_sample_txdb = subsetByOverlaps(sample, exs)

library(AnnotationHub)
ah = AnnotationHub()
qh = query(ah, c("H3K4me3", "E096", "narrow"))
narrow_peaks = qh[[1]]
prom = promoters(subset_sample_txdb)

seqlevelsStyle(prom) <- "UCSC"
new_seqlevels = paste0("chr", 1:22)
seqlevels(narrow_peaks, pruning.mode="coarse") <- paste0("chr", 1:22)
subsetByOverlaps(prom, narrow_peaks)


assays(subsetByOverlaps(prom, narrow_peaks))[[1]]
median(assays(subsetByOverlaps(prom, narrow_peaks))[[1]])
test = assays(subsetByOverlaps(prom, narrow_peaks))[[1]]
median(test[test >=1])
