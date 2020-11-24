library(GEOquery)
library(affy)


setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")
## Path to phenodata
## /home/coyote/JHU_Fall_2020/Data_Analysis/project/geo_downloads/GSE79196/CEL/GSE79196_SelectPhenoData.txt
## ./GSE79196_SelectPhenoData.txt
## Path to matrix
## 
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
keep <- groups %in% big.groups

new.geo.matrix <- my.geo.matrix[, keep]
new.pdata <- as.data.frame(pData(new.geo.matrix), stringsAsFactors=FALSE)
newgroups <- gsub("GSM.* ", "", new.pdata$title)
newgroups <- gsub(" .*", "", newgroups)
## sanity all larger than 0
all(table(newgroups)>20)
new.pdata <- new.pdata[, c("title", "geo_accession", "source_name_ch1")]
row.names(new.pdata) = paste0(row.names(new.pdata), '.CEL.gz')
write.table(new.pdata, file=paste0(my.gse,"_SelectPhenoData.txt"), quote=F, sep = "\t")
write.table(exprs(new.geo.matrix), file=paste0(my.gse,"_matrix.txt"), quote=F)


getOption('timeout') ## might need to change this depending on size
options(timeout=1000)
dir.create("geo_downloads")
a <- getGEOSuppFiles(my.gse, makeDirectory=T, baseDir="./geo_downloads")

#####################################################################################################
library(affy)
setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")
my.gse <- "GSE79196"
cel.path <- paste0("geo_downloads/", my.gse, "/CEL")
## untar
#untar(cel.path, exdir=paste0("geo_downloads/", my.gse, "/CEL"))
# get file names
my.cels <- list.files(paste0("geo_downloads/", my.gse, "/CEL"), pattern = "*.CEL")
keep <- read.table("keep.txt", )[,2]
new.pdata <- read.table(paste0(my.gse,"_SelectPhenoData.txt"), sep = "\t")
my.cels <- my.cels[keep]
#write.table(data.frame(as.numeric(keep), keep), "keep.txt", quote = F)
## confirm cels in correct order
all(gsub("_P[0-9]*", "", my.cels) == paste0(new.pdata$geo_accession, '.CEL.gz'))

my.affy <- ReadAffy(celfile.path = cel.path,
                    filenames = my.cels
                    #,phenoData = paste0(my.gse, "_SelectPhenoData_ALL.txt")
                    )
#matrix <- read.table(pipe(paste0("cut -f1,2,3 ",my.gse,"_matrix.txt")), header = T)
#dim(matrix)
pData(my.affy)
normData <- rma(my.affy)
exprs(normData)[1:10,2]
rownames(pData(normData))[2]

round(matrix[1:20,1:3], 6)
dim(matrix)

justNormData <- justRMA(celfile.path=cel.path)
exprs(justNormData)[1:10,2]
rownames(pData(justNormData))
expr.set <- justNormData[,keep]
df <- exprs(expr.set)
dim(df)
new.pdata <- read.table(paste0(my.gse,"_SelectPhenoData.txt"), sep = "\t")
pData(expr.set) <- new.pdata
groups <- gsub(" .*", "", pData(expr.set)$title)
## B-CLPD: B-cell chronic lymphoproliferative disorders
## CLL: Chronic Lymphocytic Leukemia
## cMCL: conventional Mantle cell lymphoma (MCL)
## nnMCL: leukemic nonnodal Mantle cell lymphoma (MCL)
## SMXL: Splenic marginal zone lymphoma (SMZL)
table(groups)

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

sum(is.na(df))


## CV vs. mean plot
## get cv and mean for each sample
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

outliers <- c(which(means>5.23), which(cvs<0.407))


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