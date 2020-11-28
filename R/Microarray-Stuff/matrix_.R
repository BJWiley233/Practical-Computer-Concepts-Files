library(affy)
setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")
my.gse <- "GSE79196"
mat <- as.matrix(read.table(paste0(my.gse,"justRMA_keep_matrix.txt"),
                            sep = "\t", header = T))
dim(mat)
annot <- AnnotatedDataFrame(read.table(paste0(my.gse,"_SelectPhenoData.txt"),
                                       sep = "\t", header = T))
colnames(annot)
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

means = apply(df, 2, function(x) mean(x, na.rm=T))
cvs = apply(df, 2, function(x) sd(x)/mean(x))
outliers <- c(which(means>5.23), which(cvs<0.407))