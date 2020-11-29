library(GEOquery)
library(affy)


setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")

## Download matrix data just to confirm the pheno data
my.gse <- "GSE79196"
my.geo.matrix <- getGEO(my.gse, AnnotGPL = T, getGPL = F)
my.geo.matrix <- my.geo.matrix[[1]]
my.pdata <- as.data.frame(pData(my.geo.matrix), stringsAsFactors=FALSE)
colnames(my.pdata)
head(my.pdata[, c("title", "geo_accession", "source_name_ch1")])
my.pdata <- my.pdata[, c("title", "geo_accession", "source_name_ch1")]
row.names(my.pdata) = paste0(row.names(my.pdata), '.CEL.gz')
write.table(my.pdata, file=paste0(my.gse,"_SelectPhenoData_ALL.txt"), quote=F, sep = "\t")
groups <- gsub("GSM.* ", "", my.pdata$title)
groups <- gsub(" .*", "", groups)
big.groups <- names(table(groups)[table(groups)>20])

## remove samples where total of group < 20
## write the keep indices to file
keep <- groups %in% big.groups
write.table(data.frame(as.numeric(keep), keep), "keep.txt", quote = F)

new.geo.matrix <- my.geo.matrix[, keep]
new.pdata <- as.data.frame(pData(new.geo.matrix), stringsAsFactors=FALSE)
newgroups <- gsub("GSM.* ", "", new.pdata$title)
newgroups <- gsub(" .*", "", newgroups)
## sanity all larger than 0
all(table(newgroups)>20)
new.pdata <- new.pdata[, c("title", "geo_accession", "source_name_ch1")]
row.names(new.pdata) = paste0(row.names(new.pdata), '.CEL.gz')
## will use this text file when reading in CELs into AffyBatch
write.table(new.pdata, file=paste0(my.gse,"_SelectPhenoData.txt"), quote=F, sep = "\t")
## Will use to confirm if rma() on AffyBatch is different than author's matrix
## this can be space delimieted since it's just probes and intensities
write.table(exprs(new.geo.matrix), file=paste0(my.gse,"_matrix.txt"), quote=F)

## Now we can get the CEL files with getGEOSuppFiles()
## Only running this here once for intial download and will comment out
getOption('timeout') ## might need to change this depending on size
options(timeout=1000)
dir.create("geo_downloads")
a <- getGEOSuppFiles(my.gse, makeDirectory=T, baseDir="./geo_downloads")
## untar
untar(cel.path, exdir=paste0("geo_downloads/", my.gse, "/CEL"))

#####################################################################################################
library(affy)
setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")
my.gse <- "GSE79196"
cel.path <- paste0("geo_downloads/", my.gse, "/CEL")

# get file names
#my.cels <- list.files(paste0("geo_downloads/", my.gse, "/CEL"), pattern = "*.CEL")
keep <- read.table("keep.txt", )[,2]
#new.pdata <- read.table(paste0(my.gse,"_SelectPhenoData.txt"), sep = "\t")
#my.cels <- my.cels[keep]
## confirm cels in correct order
#all(gsub("_P[0-9]*", "", my.cels) == paste0(new.pdata$geo_accession, '.CEL.gz'))

#my.affy <- ReadAffy(celfile.path = cel.path,
                    #filenames = my.cels
                    #,phenoData = paste0(my.gse, "_SelectPhenoData_ALL.txt")
                    #)

#dim(matrix)
# pData(my.affy)
# normData <- rma(my.affy)
# exprs(normData)[1:10,2]
# rownames(pData(normData))[2]
# 
# round(matrix[1:20,1:3], 6)
# dim(matrix)

?affy::justRMA()
# justRMA is a wrapper for just.rma that permits the user to 
# read in phenoData, MIAME information, and CEL files using widgets.
justNormData <- justRMA(celfile.path=cel.path,
                        phenoData=paste0(my.gse,"_SelectPhenoData_ALL.txt"),
                        compress=T)
rownames(pData(justNormData))
expr.set <- justNormData[,keep]

df <- exprs(expr.set)
## Confirm differences
matrix <- read.table(pipe(paste0("cut -f1,2,3 -d' ' ",my.gse,"_matrix.txt")), header = T)
matrix[1:10,]
df[1:10, 1:3]

write.table(df, file = paste0(my.gse,"justRMA_keep_matrix.txt"), 
            sep="\t", quote = F)
##################################################################################################
##################################################################################################
##################################################################################################
library(affy)
setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")
my.gse <- "GSE79196"
mat <- as.matrix(read.table(paste0(my.gse,"justRMA_keep_matrix.txt"),
                            sep = "\t", header = T))
dim(mat)
colnames(mat)[1:5]
annot <- AnnotatedDataFrame(read.table(paste0(my.gse,"_SelectPhenoData.txt"),
                                       sep = "\t", header = T))
rownames(annot)[1:5]
b.cell.expr.set <- ExpressionSet(assayData = mat,
                                 phenoData = annot)

sampleNames(AnnotatedDataFrame(
  read.table(paste0(my.gse,"_SelectPhenoData.txt"),
             sep = "\t", header = T)))

groups <- gsub(" .*", "", pData(b.cell.expr.set)$ertitle)
## B-CLPD: B-cell chronic lymphoproliferative disorders
## CLL: Chronic Lymphocytic Leukemia
## cMCL: conventional Mantle cell lymphoma (MCL)
## nnMCL: leukemic nonnodal Mantle cell lymphoma (MCL)
## SMXL: Splenic marginal zone lymphoma (SMZL)
table(groups)
df <- exprs(b.cell.expr.set)
colnames(df) <- gsub("\\..*", "", colnames(df))
colnames(df) <- paste0(groups, "_", colnames(df))


#####################################################################################################
## correlation plot
data.corr <- cor(df, use="pairwise.complete.obs", method="pearson")


library(ggplot2)
library(reshape2)

melt.data.cor <- melt(data.corr)
mid <- (min(melt.data.cor$value)+max(melt.data.cor$value))/2

ggplot(melt.data.cor, aes(x=Var1, y=Var2, fill=value)) +
  geom_tile(color="white") +
  scale_fill_gradient2(low="blue", mid="black", high="yellow",
                       midpoint=mid, 
                       limit=c(min(melt.data.cor$value), 1),
                       name="Pearson\nCorr.") +
  theme(axis.text.x=element_text(angle=90),
        axis.title=element_blank(),
        plot.title=element_text(hjust=0.5)) +
  ggtitle("Different leukemic B-Cell lymphomas\nCorrelation Plot")


## heatmap
library(gplots)
library(RColorBrewer)
cols <- RColorBrewer::brewer.pal(length(table(groups)), "Set1")
colors <- cols[as.factor(groups)]
heatmap.2(abs(data.corr), trace="none", scale = "row")
# b l t r
pm <- par()$mar
par(mar=c(6.1, 4.1, 4.1, 2.1))
po <- par()$oma
par(oma=c(2,0,0,0))
par(oma=po)


new.lmat=rbind(c(0,3,4), c(0,1,2))
new.lhei=c(0.5,3.0)
new.lwid=c(0.5,4,1)

heatmap.2(abs(data.corr), trace="none", scale = "row", 
          colCol = colors, key=F, dendrogram="column",
          labCol = gsub("_.*_", "_", colnames(df)),
          lmat = new.lmat, lhei = new.lhei, lwid = new.lwid)
## any NA?
sum(is.na(df))


## CV vs. mean plot
## get cv and mean for each sample
########################################################
library(qdapRegex)
means = apply(df, 2, function(x) mean(x, na.rm=T))
cvs = apply(df, 2, function(x) sd(x)/mean(x))

## plot
plot(means, cvs, xlab = "Mean", ylab = "CV", col="red", pch=20,
     xlim = c(min(means), max(means)*1.1))
title("Different leukemic B-Cell lymphomas\nSample CV vs. Mean")
abline(h=0.407, lty=2)
abline(v=5.23, lty=3)
text(means, cvs, labels=ex_between(colnames(df),"_","_"),
     pos = 1, cex=0.6)

########################################################
outliers <- c(which(means>5.23), which(cvs<0.407))
########################################################

#https://stackoverflow.com/questions/60798208/how-to-bold-a-group-of-labels-or-branches-in-heatmap-2-in-r
make_bold_names <- function(mat, rc_fun, rc_names) {
  bold_names <- rc_fun(mat)
  ids <- rc_names %>% match(rc_fun(mat))
  ids %>%
    walk(
      function(i)
        bold_names[i] <<-
        bquote(bold(.(rc_fun(mat)[i]))) %>%
        as.expression()
    )
  bold_names
}
library(dplyr)
library(purrr)


data.corr.copy <- data.corr
colnames(data.corr.copy)[outliers] <- paste(colnames(data.corr.copy)[outliers], "    **")
colnames(data.corr.copy)[-outliers] <- paste(colnames(data.corr.copy)[-outliers], "      ")

new.lmat=rbind(c(0,3,4), c(0,1,2))
new.lhei=c(1,5.0)
new.lwid=c(0.5,4,1)
par(oma=c(3,0,0,0))
par(mar=c(3.8,4.1,4.1,2.1))
heatmap.2(abs(data.corr), trace="none", scale = "row", 
          colCol = colors, key=F, dendrogram="column",
          labCol = gsub("_.*_", "_", make_bold_names(data.corr.copy,colnames,outliers)),
          lmat = new.lmat, lhei = new.lhei, lwid = new.lwid, cexCol = 1)
#####################################################################################################
## remove 4 outliers and put groups in order
df.rem.out <- df[, -outliers]
annot.rem.out <- annot[-outliers, ]
dim(df.rem.out)
dim(annot.rem.out)
group.rem.out <- groups[-outliers]
groups.ord <- group.rem.out[order(group.rem.out)]
df.ord <- df.rem.out[, order(group.rem.out)]
colnames(df.ord)
annot.ord <- annot.rem.out[order(group.rem.out), ] 
rownames(annot.ord)
## sanity order
all(gsub(".*_", "", colnames(df.ord)) == gsub("\\.CEL.*", "", rownames(annot.ord)))

library(pwr) ## didn't use this

## remove unknown B-CLPD from analysis
## this is what we are trying to predict
B.CLPD <- grep("B-CLPD", groups.ord)
diagnosed.groups.df <- df.ord[, -B.CLPD]
annot.diagnosed.groups <- annot.ord[-B.CLPD, ]
dim(diagnosed.groups.df)
dim(annot.diagnosed.groups)
diagnosed.groups <- groups.ord[-B.CLPD]
table(diagnosed.groups)

# x <- diagnosed.groups.df[i,]
# m <- mean(x)
# sum.sq <- ((54*(gm[1]-m)^2) + (30*(gm[2]-m)^2) + 
#     (24*(gm[3]-m)^2) + (22*(gm[4]-m)^2))
# num <- sum.sq/3
# a
# sum(c((x[diagnosed.groups=="CLL"] - mean(x[diagnosed.groups=="CLL"]))^2,
#       (x[diagnosed.groups=="cMCL"] - mean(x[diagnosed.groups=="cMCL"]))^2,
#       (x[diagnosed.groups=="nnMCL"] - mean(x[diagnosed.groups=="nnMCL"]))^2,
#       (x[diagnosed.groups=="SMZL"] - mean(x[diagnosed.groups=="SMZL"]))^2))
#       
# tapply(diagnosed.groups.df[1,], list(diagnosed.groups), function(x) length(x))
# 
# var(cll)
# num/denom


library(reshape2)
## get p-values
anova.all.genes <- function(x, groups) {
  d <- cbind(melt(x), groups)
  a <- summary(aov(value~groups, d))
  pval <- a[[1]][1,5]
  return(pval)
}

anova.all.pval <- apply(diagnosed.groups.df, 1, anova.all.genes,
                        groups=diagnosed.groups)
# adjust p-values
p.adj <- p.adjust(anova.all.pval, method = "BH")

diagnosed.groups.keep.anova <- diagnosed.groups.df[p.adj<.01, ]
nrow(diagnosed.groups.keep.anova)
#ss <- apply(diagnosed.groups.df, 1, power.anova.ss, groups=diagnosed.groups)
# library(MKomics)
# ss <- c()
# for (i in 1:nrow(diagnosed.groups.df)) {
#   x <- diagnosed.groups.df[i,]
#   # d <- cbind(melt(x), groups)
#   # a <- aov(value~groups, d)
#   # e <- min(abs(TukeyHSD(a)$groups[, "diff"]))
#   e <- min(abs(pairwise.fc(x, groups)))
#   # between = a[[1]][1,2]
#   # within = a[[1]][2,2]
#   # https://psychohawks.wordpress.com/2010/10/31/effect-size-for-analysis-of-variables-anova/
#   # between/sum(between, within)
#   n <- pwr.anova.test(k = 4, n = NULL, f = e, 
#                  sig.level = 0.01, power = 0.8)$n
#   # s <- power.anova.test(groups=4, between.var = between, within.var = within,
#   #                       power = 0.9)
#   ss[i] = n
# }




###############################################################################
## testing to make sure pairwise.t.test does same
## order as pairwise.fc
library(MKmisc)
i = nrow(diagnosed.groups.keep.anova)
d <- diagnosed.groups.keep.anova[i, ]
gene <- gene.names[i]
pair.t <- pairwise.t.test(x=d, g=diagnosed.groups, p.adjust.method = "BH")
p <- pair.t$p.value
m <- melt(p)
m <- m[!is.na(m$value),]

fc <- pairwise.fc(x=d, g=diagnosed.groups)
fc
# cll <- mean(2^(d)[diagnosed.groups=="CLL"])
# cMcl <- mean(2^(d)[diagnosed.groups=="cMCL"])
# cll <- mean((d)[diagnosed.groups=="CLL"])
# cMcl <- mean((d)[diagnosed.groups=="cMCL"])
# -1/2^(cll-cMcl)
# data.test <- cbind(melt(d), diagnosed.groups)
# ggplot(data.test, aes(x=diagnosed.groups, y=value, color=diagnosed.groups)) +
#   geom_boxplot()
#https://stackoverflow.com/questions/29674661/r-list-of-lists-to-data-frame
fc.df <- data.frame(do.call(rbind, strsplit(names(fc), " vs ")))
#columns diff order but are all rows same
all(m[,c("Var2", "Var1")] == fc.df)

###############################################################################
## run pairwise to see which genes are profiling individual leukemia type
probes <- rownames(diagnosed.groups.keep.anova)
sig.genes2 <- list()
sig.genes.idx2 <- c()
sig.genes.leuk.type2 <- list(type=c(), probe=c(), avg.p=c(), avg.fc=c())
count = 1
for (i in 1:nrow(diagnosed.groups.keep.anova)) {
  d <- diagnosed.groups.keep.anova[i, ]
  #d <- diagnosed.groups.df["204913_s_at", ]
  probe <- probes[i]
  pair.t <- pairwise.t.test(x=d, g=diagnosed.groups, p.adjust.method = "BH")
  

  ## We need to rearrange the p.value table so we can see
  ## by rows for each group the p-value against the 3 other groups
  ## i.e. 6 pvals correspond to 6x2=12 differences or 4 groups x 3 comparisons
  ## for each group against the other 3
  p <- pair.t$p.value
  m <- melt(p)
  m <- m[!is.na(m$value),]
  #m$value <- p.adjust(m$value, method = "BH", n=nrow(diagnosed.groups.df))
  
  ## From help menu:
  ## The fold changes are returned in a slightly modified form if mod.fc = TRUE. 
  ## Fold changes FC which are smaller than 1 are reported as to -1/FC.
  ## Also it unlogs the fold change in the function with the code
  ##    if (log) {
  ##  logFC <- ave(xj, ...) - ave(xi, ...)
  ##  FC <- base^logFC
  ##  }
  fc <- pairwise.fc(x=d, g=diagnosed.groups)
  # confirmd above loop same order as pairwise.t.test
  m$fc <- fc
  
  ## will be a 4x3 list for each group vs other 3, pretty nifty!
  t.list <- list()
  for (j in 1:nrow(m)) {
    for (k in 1:2) {
      key <- as.character(m[j,k])
      t.list[[key]]$pval <- c( t.list[[key]]$pval, pval=m[j,"value"])
      t.list[[key]]$fc <- c(t.list[[key]]$fc, fc=m[j,"fc"])
      #t.list[[key]] <- c(t.list[[key]], list(pval=m[j,"value"], fc=m[k, "fc"]))
    }
  }
  
  ## only has completely different expression in one type verse the rest
  ## not interested in the gene expression is differentially expressed
  ## for example if gene is same in mMCL and CLL and same in nnMCL and SMZL
  ## but different between the two subsets that would be BH signficant but
  ## wouldn't help use in assigning leukemia type expression PROFILES
  significant <- names(which(lapply(t.list, function(x) all(x$pval < .01)) == T))
  bool <- length(significant) > 0
  if (bool) { 
    sig.genes2[[gene]] <- significant
    for (leuk in significant) {
      sig.genes.leuk.type2$type[count]=leuk
      sig.genes.leuk.type2$probe[count]=probe
      sig.genes.leuk.type2$avg.p[count]=mean(t.list[[leuk]]$pval)
      sig.genes.leuk.type2$avg.fc[count]=mean(t.list[[leuk]]$fc)
      count=count+1
    }
  }
  sig.genes.idx2[i] <- bool
}
## total bool = T should be the length of nice significant gene list
sum(sig.genes.idx2) == length(sig.genes2)
diagnosed.groups.keep.anova.pairT <- diagnosed.groups.keep.anova[sig.genes.idx2, ]
sum(sig.genes.idx2)/length(sig.genes.idx2)

final.df <- data.frame(sig.genes.leuk.type2) 
## this may be longer that genes because the gene may be completely different
## for more than 1 type, i.e. gene6 has adjusted pairwise t tests
## 3 pvals < .01 for cMCL verse the other 3 and also pairwise t tests
## 3 pvals < .01 for nnMCL verse the other 3
dim(final.df)
sum(sapply(sig.genes2, length)) == nrow(final.df)
final.df <- final.df[order(final.df$avg.p),]
head(final.df, 55)






## put names back for expression set
library(dplyr)
colnames(diagnosed.groups.keep.anova.pairT) <-
  paste0(gsub(".*_", "", colnames(diagnosed.groups.keep.anova.pairT)), ".CEL.gz")
significant.expset <- ExpressionSet(assayData=diagnosed.groups.keep.anova.pairT,
                                    phenoData=annot.diagnosed.groups)

# https://www.biostars.org/p/254040/
# http://biolearnr.blogspot.com/2017/05/bfx-clinic-getting-up-to-date.html
# most of code below comes up link above from BFX clinic to map probes to genes
BiocManager::install("hgu133plus2.db")
library(hgu133plus2.db)

keys(hgu133plus2.db)
rownames(significant.expset) %in% keys(hgu133plus2.db) %>%
  summary()
## same for dataframe with leukemia type
unique(final.df$gene) %in% keys(hgu133plus2.db) %>%
  summary()

columns(hgu133plus2.db)

# Expression Set we made at beginning
db.annotation.all <- AnnotationDbi::select(
  x = hgu133plus2.db,
  keys = rownames(b.cell.expr.set),
  #columns = c("PROBEID", "ENSEMBL", "ENTREZID", "SYMBOL"),
  columns = c("PROBEID", "SYMBOL"),
  keytype = "PROBEID"
)

# Significant gene expression sets
db.annotation <- AnnotationDbi::select(
  x = hgu133plus2.db,
  keys = rownames(significant.expset),
  #columns = c("PROBEID", "ENSEMBL", "ENTREZID", "SYMBOL"),
  columns = c("PROBEID", "SYMBOL"),
  keytype = "PROBEID"
)

# 'select()' returned 1:many mapping between keys and columns
# some probes assign to more than 1 gene
table(db.annotation$PROBEID) > 1
dup.ids <- db.annotation$PROBEID[table(db.annotation$PROBEID) > 1] %>%
  unique
## how many for instance are mapped to 2 or more genes
table(table(db.annotation$PROBEID))
## few examples, I have seen this before
db.annotation[ db.annotation$PROBEID == dup.ids[1], ]
db.annotation[ db.annotation$PROBEID == dup.ids[50], ]

## this will concatenate all genes mapped to a probe
db.annot.mult.mapping <- db.annotation %>% 
  group_by(PROBEID) %>%
  summarise(PROBEID=PROBEID,
            genes = paste0(SYMBOL, collapse = "|")) %>%
  dplyr::slice(1)

## AnnotationDbi and ExpressionSet already order probe names
all(db.annot.mult.mapping$PROBEID==row.names(significant.expset))

featureData(significant.expset) <- AnnotatedDataFrame(db.annot.mult.mapping)

## also assigned it to our nice leukemia type dataframe
final.df.with.names <- dplyr::left_join(x=final.df, y=db.annot.mult.mapping, by=c("probe"="PROBEID"))
grouped <- final.df.with.names %>% group_by(type) 
final.df.with.names %>% group_by(type, genes) 
## since there are duplicate gene probes in a single group
## i.e. cMCL has SOX11 twice keep the lowest pvalue row
## so we can obtain top 5 + and - for each group for 40 total
grouped.unique.genes <- grouped[!duplicated(grouped[,c(1,5)]),]
grouped.unique.genes$direction <- ifelse(grouped.unique.genes$avg.fc>0,
                                         "positive", "negative")
grouped.unique.genes.dir <- grouped.unique.genes %>% group_by(type, direction)
## get top 5 in both direction for each group based on significant p-value
diff.exp.genes <- grouped.unique.genes.dir %>% slice_min(avg.p, n=5)
## some are NA so lose those
grouped.unique.genes.dir <- grouped.unique.genes.dir[!grouped.unique.genes.dir$genes=="NA",]
diff.exp.genes <- grouped.unique.genes.dir %>% slice_min(avg.p, n=5)

## other notable genes in CLL and cMCL that are up-regulated in each
diff.exp.genes.notables <- grouped.unique.genes[(grouped.unique.genes$type=="CLL" |
                                                 grouped.unique.genes$type=="cMCL") &
                                                 !(grouped.unique.genes$genes=="NA") &
                                                  grouped.unique.genes$avg.fc>0,]
notables <- diff.exp.genes.notables %>% slice_min(avg.p, n=15)
notables[c(6:10, 21:29),]

#######################################################################################  
#######################################################################################  
## 
BH.pairT.pca <- prcomp(t(diagnosed.groups.keep.anova.pairT))
pcomps <- data.frame(BH.pairT.pca$x[, 1:2])
dim(pcomps)
pcomps$leuk <- diagnosed.groups

library(ggplot2)
ggplot(pcomps, aes(PC1, PC2, color=leuk)) +
  geom_point() +
  ggtitle("PCA Plot B-Cell, PC1 vs PC2") +
  theme(plot.title = element_text(hjust = 0.5))

####################################################################################
## write top 5 up and down to file
write.table(diff.exp.genes, file = "diff.exp.genes.txt", quote=F, sep="\t", row.names = F)
## list of the probes for NCBI David
write.table(diff.exp.genes$probe, file = "probes.txt", quote=F, sep="\t", row.names = F,
            col.names = F)

diff.exp.genes <- read.table(file = "diff.exp.genes.txt", sep="\t", header=T)

## got fix your java certificates first
## https://support.bioconductor.org/p/72188/
library(RDAVIDWebService)
david <- DAVIDWebService$new(email="bwiley4@jh.edu", url="https://david.ncifcrf.gov/webservice/services/DAVIDWebService.DAVIDWebServiceHttpSoap12Endpoint/")
result <- addList(david, diff.exp.genes$probe,
                  idType="AFFYMETRIX_3PRIME_IVT_ID",
                  listName="Top5All", listType="Gene")

## see 39 of the 40 probe ids were annotated
david
## get GO and Paths/interactions, need to set at least 1 annotation 
## that has 100% of the IDs so there are rows for each annotation = number of IDs
## that is pretty silly
setAnnotationCategories(david, c("GOTERM_CC_DIRECT",
                                 "KEGG_PATHWAY", "REACTOME_PATHWAY",
                                 "MINT", "INTACT", "UCSC_TFBS", "ENSEMBL_GENE_ID"))
## or just get GO and Ensemble ID
#setAnnotationCategories(david, c("GOTERM_CC_DIRECT", "ENSEMBL_GENE_ID"))

## get annotations selected, returns sparse matrix for your probes for each annotation
## need novel way to convert below
annotTable <- RDAVIDWebService::getFunctionalAnnotationTable(david)
memberships <- RDAVIDWebService::membership(annotTable)
annotTable@Genes ## gene names
nrow(annotTable@Genes) ## 40 since I have 4 groups, you should have 10

## now there are only 39 rows find which id is missing
## since we can't set annotTable@Genes[,"ID"] as names with 40 on list of 39
nrow(memberships$KEGG_PATHWAY) ## this is 40
all(lapply(memberships, function(x) nrow(x))==nrow(diff.exp.genes)) ## now all are 40 in length good, 10 for you


## add full genes names to your results
library("dplyr")
diff.exp.genes.with.names <- left_join(diff.exp.genes, annotTable@Genes[,1:2], by=c("probe"="ID"))



## BELOW to add column for go ids and columns for go terms
## GO comes with a dictionary mapping of ids to terms, pretty nice
go.matrix <- as.data.frame(memberships$GOTERM_CC_DIRECT)
go.dict <- annotTable@Dictionary$GOTERM_CC_DIRECT
## above is not real dict, lists are real dicts in R
go.dict.real.dict <- setNames(split(go.dict[,2], seq(nrow(go.dict))), go.dict[,1])
## Example 'endoplasmic reticulum'
go.dict.real.dict$`GO:0005783`

## create adjacency lists from sparse go matrix for ids and use dict for terms
go.ids.per.probe <- apply(go.matrix, 1, function(x) colnames(go.matrix)[which(x==TRUE)])
names(go.ids.per.probe) <- annotTable@Genes[,"ID"]
go.terms.per.probe <- lapply(go.ids.per.probe, function(x) sapply(x, function(y) go.dict.real.dict[[y]]))
names(go.terms.per.probe) <- annotTable@Genes[,"ID"]

## make GO ID dataframe and join
## set the collapse to any delimter you want with your annotations
## NCBI David uses comma separated
## This is really a matrix need to convert
## https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
goid.list <- lapply(go.ids.per.probe, function(x) paste0(x, collapse = ", "))
goid.df <- data.frame(matrix(unlist(goid.list), nrow=length(goid.list), byrow = T), stringsAsFactors = FALSE)
colnames(goid.df) <- "goIDs"
rownames(goid.df) <- annotTable@Genes[,"ID"]
goid.df$ID <- annotTable@Genes[,"ID"]
## add go terms to differential expression dataframe
diff.exp.genes.with.names.goids <- left_join(diff.exp.genes.with.names, 
                                             goid.df, by=c("probe"="ID"))


# same for terms
goTerm.list <- lapply(go.terms.per.probe, function(x) paste0(x, collapse = ", "))
goTerm.df <- data.frame(matrix(unlist(goTerm.list), nrow=length(goTerm.list), byrow = T), 
                        stringsAsFactors = FALSE)
colnames(goTerm.df) <- "goTerms"
rownames(goTerm.df) <- annotTable@Genes[,"ID"]
goTerm.df$ID <- annotTable@Genes[,"ID"]
## add go terms to differential expression dataframe
diff.exp.genes.with.names.goidsAndTerms <- left_join(diff.exp.genes.with.names.goids, 
                                                     goTerm.df, by=c("probe"="ID"))


cat(sum(diff.exp.genes.with.names.goidsAndTerms$goIDs != ""), "entries for", "Go IDs")
cat(sum(diff.exp.genes.with.names.goidsAndTerms$goTerms != ""), "entries for", "Go Terms")
## so for me two of the probes matched (SOX5) so 37 is really 36

################################################################################################
## repeat for other annotations but make individual dataframes
## i.e. the original columns of diff.exp.genes and new column for 
## each of "KEGG_PATHWAY", "REACTOME_PATHWAY", "MINT", "INTACT", "UCSC_TFBS"
memberships <- RDAVIDWebService::membership(annotTable)
names(memberships)
# memberships$KEGG_PATHWAY
# annotation <- "KEGG_PATHWAY"

make.annot.df <- function(annotation) {
  matrix <- as.data.frame(memberships[[annotation]])
  annot.per.probe <- apply(matrix, 1, function(x) colnames(matrix)[which(x==TRUE)])
  names(annot.per.probe) <- annotTable@Genes[,"ID"]
  
  annot.list <- lapply(annot.per.probe, function(x) paste0(x, collapse = ", "))
  annot.df <- data.frame(matrix(unlist(annot.list), nrow=length(annot.list), byrow = T), 
                         stringsAsFactors = FALSE)
  colnames(annot.df) <- annotation
  rownames(annot.df) <- annotTable@Genes[,"ID"]
  annot.df$ID <- annotTable@Genes[,"ID"]
  ## add add annotation to differential expression dataframe with full gene names
  diff.exp.genes.with.names.annot <- left_join(diff.exp.genes.with.names, 
                                               annot.df, by=c("probe"="ID"))
  cat(sum(diff.exp.genes.with.names.annot[annotation] != ""), "entries for", annotation)
  
  diff.exp.genes.with.names.annot
}

## KEGG
kegg.df <- make.annot.df("KEGG_PATHWAY")  ## SOX5 empty
head(kegg.df)

## REACTOME
reactome <- make.annot.df("REACTOME_PATHWAY") ## SOX5 empty
head(reactome)

## IntAct, lot of entries here!
intact <- make.annot.df("INTACT") ## again SOX5 twice so really 31
intact[intact$probe=="203072_at", "INTACT"]

## MINT
mint <- make.annot.df("MINT") ## SOX5 so 16

## UCSC_TFBS
ucsc.tfbs <- make.annot.df("UCSC_TFBS") ## SOX5 so 38
ucsc.tfbs[ucsc.tfbs$probe=="230441_at", "UCSC_TFBS"]

# x=go.ids$`236226_at`
# go.dict.real.dict[[x[2]]]
# 
# go.matrix[31,]
# names(go.ids) <- annotTable@Genes[,"ID"]
# go.dict <- annotTable@Dictionary$GOTERM_CC_DIRECT
# go.dict[go.dict$ID=="GO:0005634",]
# go.ids$`208717_at`


####################################################################################
# p <- pair.t$p.value
# m <- melt(p)
# m <- m[!is.na(m$value),]
# t.list <- list()
# for (i in 1:nrow(m)) {
#   for (j in 1:2) {
#     print(m[i,j])
#     k <- as.character(m[i,j])
#     t.list[[k]] <- c( t.list[[k]], m[i,"value"])
#   }
# }
# significant <- which(lapply(t.list, function(x) all(x < .01)) == T)
# 
# sig.genes.bool <- c()
# 
# length(which(lapply(t.list, function(x) all(x < .01)) == T)) > 0
# 
# fun <- function (pair) {
#   t.list[[pair[,'Var1']]] <- c(t.list$pair[,'Var1'], pair[,'value'])
#   t.list[[pair['Var2']]] <- c(t.list[[pair['Var2']]], pair['value'])
# }
# apply(m, 1, fun)
# pair <- m[1,]
# 
#  
# 
# aov.run <- apply(diagnosed.groups.df, 1, FUN=aov.all.genes,
#                  groups = diagnosed.groups)
# x = diagnosed.groups.df["204913_s_at", ]
# aov.run.sorted <- sort(aov.run)
# p.adjust.holm <- p.adjust(aov.run.sorted, method = "holm")
# sum(p.adjust(aov.run.sorted, method = "bonferroni")<.01)
# sum(p.adjust.holm<.01)
# plot(aov.run.sorted, col="red", type="l",
#      ylim=c(min(c(aov.run.sorted, p.adjust.holm)),
#             max(c(aov.run.sorted, p.adjust.holm))),
#      ylab="sorted p-values",
#      main="P-value vs. Adjusted P-Value\nGender gene set")
# lines(p.adjust.holm, col="blue", type="l", lty=2,
#       ylim=c(min(c(aov.run.sorted, p.adjust.holm)),
#              max(c(aov.run.sorted, p.adjust.holm))))
# legend(17, 0.05, legend=c("raw p-value", "holm adjusted\np-value"),
#        col=c("red", "blue"), lty=1:2, cex=0.7)
# 
# 
# sum(p.adjust.holm < 0.01)
# p.adjust.holm[p.adjust.holm<.01]
# test2 <- diagnosed.groups.df.pow[p.adjust.holm < 0.01,]
# tf <- c()
# g1=grep("CLL", diagnosed.groups)
# g2=grep("cMCL", diagnosed.groups)
# g3=grep("nnMCL", diagnosed.groups)
# g4=grep("SMZL", diagnosed.groups)
# for (i in 1:nrow(test2)) {
#   x <- test2[i, ]
#   x1 <- as.numeric(x[g1])
#   x2 <- as.numeric(x[g2])
#   x3 <- as.numeric(x[g3])
#   x4 <- as.numeric(x[g4])
#   fac <- c(rep("CLL",length(x1)), rep("cMCL",length(x2)), 
#            rep("nnMCL",length(x3)), rep("SMZL", length(x4)))
#   a.dat <- data.frame(as.factor(fac),c(x1,x2,x3,x4))
#   names(a.dat) <- c("factor", "express")
#   a1 <- aov(express~factor, a.dat)
#   tf[i] <- all(TukeyHSD(a1)$factor < .50)
# }
# sum(tf)
# 
# 
# "204913_s_at" %in% rownames(diagnosed.groups.df.pow)
# test3 <- diagnosed.groups.df["204913_s_at", ]
# #test3 <- diagnosed.groups.df[1, ]
# diagnosed.groups.df[14361,]
# names(test3) <- diagnosed.groups
# test3 <- cbind(melt(test3),names(test3))
# colnames(test3) <- c("val", "group")
# a <- aov(val~group, test3)
# summary(a)
# TukeyHSD(a)
# # grouped boxplot
# ggplot(test3, aes(x=group, y=val, fill=group)) + 
#   geom_boxplot()
# 
# 
# t <- TukeyHSD(aov(value~groups, cbind(melt(x), groups)))$group
# #t.list <- list(cMCL=c(), CLL=c(), SMZL=c(), nnMCL=c())\
# t.list2 <- list()
# s <- strsplit(rownames(t), "-")
# for (i in 1:length(s)) {
#   for (j in s[[i]]) {
#     t.list2[[j]] <- c(t.list2[[j]], t[i,"p adj"])
#   }
# }
# length(which(lapply(t.list, function(x) all(x < .01)) == T)) > 0
# 
# 
# 
# 
# test4 <- diagnosed.groups.df.pow[p.adjust.holm > 0.80,]
# colnames(test4) <- diagnosed.groups
# 
# library(reshape2)
# test5 <- melt(t(test4[1:2, ]))
# # grouped boxplot
# ggplot(test5, aes(x=Var1, y=value, fill=Var2)) + 
#   geom_boxplot()
# 
# ##############################
# ggplot(cbind(melt(x), names(x)), aes(x=`names(x)`, y=value, fill=`names(x)`)) + 
#   geom_boxplot()



