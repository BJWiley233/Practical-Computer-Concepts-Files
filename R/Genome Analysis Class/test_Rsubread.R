setwd("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_12")
files <- list.files(pattern = "*.tabular")

df <- do.call(cbind,
              lapply(files, function(x) {
                aColumn <- read.table(x,header=T, sep="\t")
                colnames(aColumn)[2] <- gsub(".*86_and_", "", x)
                aColumn
              }))
df <- df[,!duplicated(colnames(df))]
colnames(df) <- gsub("__Counts].tabular", "", colnames(df))

library("Rsubread")
BiocManager::install()

bamfiles <- list.files(pattern = ".*.bam")
install.packages("/home/coyote/Downloads/Rsubread_2.4.1.tar.gz", repos=NULL, type="source")

## MUST PASS 
fc <- Rsubread::featureCounts(bamfiles,
                        annot.ext = "Galaxy86-[GffCompare_on_data_9_and_data_80__annotated_transcripts].gtf",
                        isGTFAnnotationFile = T,
                        GTF.attrType = "transcript_id",
                        strandSpecific = 1)

fc$counts[rownames(fc$counts)=="NM_008089",]
fc$counts[rownames(fc$counts)=="MSTRG.310.1",]
fc$counts[rownames(fc$counts)=="MSTRG.311.1",]
fc$counts[rownames(fc$counts)=="MSTRG.320.1",]
fc$counts[1:20,1]
sum(fc$counts)

## MUST PASS isPairedEnd = TRUE  if aligned reads are from PE!!!!!!!!!!!!!!
fc2 <- Rsubread::featureCounts(bamfiles,
                              annot.ext = "Galaxy86-[GffCompare_on_data_9_and_data_80__annotated_transcripts].gtf",
                              isGTFAnnotationFile = T,
                              countChimericFragments = F,
                              isPairedEnd = TRUE,
                              GTF.featureType = "exon",
                              GTF.attrType = "transcript_id",
                              strandSpecific = 1,
                              countMultiMappingReads = T)

fc3 <- Rsubread::featureCounts(bamfiles,
                               annot.ext = "Galaxy86-[GffCompare_on_data_9_and_data_80__annotated_transcripts].gtf",
                               isGTFAnnotationFile = T,
                               countChimericFragments = F,
                               isPairedEnd = TRUE,
                               GTF.featureType = "exon",
                               GTF.attrType = "transcript_id",
                               strandSpecific = 1,
                               countMultiMappingReads = F)
sum(fc2$stat[,2])
sum(fc3$stat[,2])
head(fc2$counts)
fc3$targets
library(DESeq2)
groups <- factor(c("G1E", "G1E", "Mega", "Mega"))
d <- data.frame(samples = colnames(fc3$counts), group = groups)
ddsMat <- DESeqDataSetFromMatrix(countData = fc3$counts,
                                 colData = d,
                                 design = ~ group)
ddsMat$group
assay(ddsMat)
colData(ddsMat)
as.formula(paste("~", paste(rev(factors), collapse=" + ")))
rld <- rlog(ddsMat)
rld$group
plotPCA(rld, intgroup="group")
plotPCA(rld)
analysis <- DESeq(ddsMat)
n <- nlevels(colData(analysis)[['group']])
allLevels <- levels(colData(analysis)[['group']])
normalizeCounts <- counts(analysis, normalize=T)

ref <- allLevels[1]
lvl <- allLevels[2]
res <- results(analysis, contrast=c('group', ref, lvl),
               cooksCutoff=F,
               independentFiltering=F)
resSorted <- res[order(res$padj),]
outDF <- as.data.frame(resSorted)
outDF$geneID <- rownames(outDF)
head(outDF, 10)
outDF <- outDF[,c("geneID", "baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj")]

fc3$counts["MSTRG.38.1",]
mean(fc3$counts["MSTRG.139.2",1:2])
log2(mean(fc3$counts["MSTRG.139.2",1:2])/mean(fc3$counts["MSTRG.139.2",3:4]))
2^11.397187
for (i in seq_len(n-1)) {
  ref <- allLevels[i]
  contrastLevels <- allLevels[(i+1):n]
  for (lvl in contrastLevels) {
    res <- results(analysis, contrast=c('group', lvl, ref),
                   cooksCutoff=F,
                   independentFiltering=F)
    resSorted <- res[order(res$padj),]
    outDF <- as.data.frame(resSorted)
    outDF$geneID <- rownames(outDF)
    outDF <- outDF[,c("geneID", "baseMean", "log2FoldChange", "lfcSE", "stat", "pvalue", "padj")]
  }
}






t <- read.table("G1E_rep1_vers164.txt.summary", header = T, sep = "\t")
sum(t[,2])

df[df$Geneid=="NM_008089",]
df[df$Geneid=="MSTRG.310.1",]
df[df$Geneid=="MSTRG.311.1",]
sum(df[,2:5])

all(rownames(fc$counts)==df$Geneid)
