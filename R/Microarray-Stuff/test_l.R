library(GEOquery)
#my.gse2 <- "GSE120473"
my.gse2 <- "GSE9412"
my.geo.gse2 <- getGEO(GEO=my.gse2,
                      destdir="./geo_downloads",
                      getGPL=FALSE)
getGEOSuppFiles(my.gse2, makeDirectory=T, baseDir="~/geo_downloads")

untar(paste0("geo_downloads/",my.gse2,"/",my.gse2,"_RAW.tar"), 
      exdir=paste0("geo_downloads/",my.gse2,"/CEL"))
files <- list.files(paste0("geo_downloads/",my.gse2,"/CEL"), full.names = T)
my.geo.affybatch <- read.affybatch(filenames = files)
my.geo.affybatch.rma <- rma(my.geo.affybatch)
match("209140_x_at", featureNames(my.geo.affybatch.rma))
exprs(my.geo.affybatch.rma)[8634, ]


featureData(my.geo.gse2[[1]])  
assayData(my.geo.gse2[[1]])
my.geo.gse2 <- my.geo.gse2[[1]]
head(exprs(my.geo.gse2))


ex <- exprs(my.geo.gse2)
match("209140_x_at", featureNames(my.geo.gse2))
ex[8634, ]

library(affyPLM)
my.geo.gse2.rma <- rma(my.geo.gse2)
library(CLL)
data("CLLbatch")
CLLrma <- rma(CLLbatch)

sampleNames(phenoData(my.geo.gse2))
qx <- as.numeric(quantile(ex, c(0., 0.25, 0.5, 0.75, 0.99, 1.0), na.rm=T))
LogC <- (qx[5] > 100) ||
  (qx[6]-qx[1] > 50 && qx[2] > 0) ||
  (qx[2] > 0 && qx[2] < 1 && qx[4] > 1 && qx[4] < 2)

# set up the data and proceed with analysis
sml <- c(rep('G0', 3), rep('G1', 3))    # set group names
fl <- as.factor(sml)
my.geo.gse2$description <- fl
design <- model.matrix(~ description + 0, my.geo.gse2)
colnames(design) <- levels(fl)
fit <- lmFit(my.geo.gse2, design)
cont.matrix <- makeContrasts(G1-G0, levels=design)
fit2 <- contrasts.fit(fit, cont.matrix)
fit2 <- eBayes(fit2, 0.01)
## or "B" for the lods or B-statistic
tT <- topTable(fit2, adjust="fdr", sort.by="B", number=250)



fl <- as.factor(sml)
my.geo.gse2$description <- fl
design <- model.matrix(~ description + 0, my.geo.gse2)

colnames(design) <- levels(fl)
fit <- lmFit(my.geo.gse2, design)
cont.matrix <- makeContrasts(G1-G0, levels=design)
fit2 <- contrasts.fit(fit, cont.matrix)
fit2 <- eBayes(fit2, 0.01)
tT <- topTable(fit2, adjust="fdr", sort.by="B", number=250)