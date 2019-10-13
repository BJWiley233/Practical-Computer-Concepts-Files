library(limma)
library(CCl4)
dataPath <- system.file("extdata", package="CCl4")
dir(dataPath)
adf = read.AnnotatedDataFrame("samplesInfo.txt", path = dataPath)
rownames(adf)
variable.names(adf)
targets <- pData(adf)
# read.maimages expects a data.frame with mandatory column FileName as its input
targets$FileName <- row.names(targets)
# RGList Object in R
RG <- read.maimages(targets, source = "genepix", path = dataPath)
head(RG$genes)
test <- read.maimages(targets, source = "genepix.mean", path = dataPath)
head(RG$Rb) == head(test$Rb)
head(test$R)

source = "genepix"

columns = switch(source, blah=list(1,2,3), ttt=list(2,3,4), genepix=, brian=list(5,6,7), thisOne=list("a","b","c"), NULL)

par(mfrow=c(5, 1))
imageplot(log2(RG$Rb[,1]), layout = RG$printer, low = "white", high = "red")
imageplot(log2(RG$Gb[,1]), layout = RG$printer, low = "white", high = "green")
imageplot(rank(RG$Rb[,1]), layout = RG$printer, low = "white", high = "red")
imageplot(rank(RG$Gb[,1]), layout = RG$printer, low = "white", high = "green")
imageplot(rank(log(RG$R[,1]) + log(RG$G[,1])), layout = RG$printer, low = "white", high = "blue")

# An MA-plot displays the log-ratio of red intensities R and green intensities G on
# the y-axis versus the overall intensity of each spot on the x-axis.
MA <- normalizeWithinArrays(RG, method = "none", bc.method = "none")
library(geneplotter)
smoothScatter(MA$A[,1], MA$M[,1], xlab="A", ylab="M")
abline(h=0, col="red")

MA <- normalizeWithinArrays(RG, method = "none", bc.method = "subtract")
par(mfrow=c(2,1))
smoothScatter(MA$A[,1], MA$M[,1], xlab="A", ylab="M")
abline(h=0, col="red")
limma::plotMA(MA)

par(mfrow=c(1,1))
plotformula <- log2(RG$G)~col(RG$G)
boxplot(plotformula, col="forestgreen", xlab="Arrays", ylab=expression(log[2]~G))

pal = palette(rainbow(18))
par(mar=c(5.1, 4.1, 4.1, 6))
multidensity(formula=plotformula, xlim=c(5,9), col = pal, legend = F, lwd=2)
par(xpd=T)
legend(9.5, 4.4, legend=paste(c(1:18)), fill = pal, cex = .7)
#abline(h=0, col = "black")

rin <- with(MA$targets, ifelse(Cy5=="CCl4", RIN.Cy5, RIN.Cy3))
select <- (rin == max(rin))
RGgood <- RG[, select]
adfgood <- adf[select, ]
# Note the di???erent indexing conventions: for
# objects of type RGList, like RG, arrays are considered as"columns", whereas
# for the object adf, which is of type AnnotatedDataFrame, arrays are consid-
#     ered as"rows".
library(vsn)
ccl4 <- justvsn(RGgood, backgroundsubtract=T)
r <- assayData(ccl4)$R
g <- assayData(ccl4)$G
meanSdPlot(cbind(r, g))

#rownames(pData(adfgood))
rownames(adfgood) <- sub("\\.gpr", "", rownames(adfgood))
pData(adfgood)
# The factor variable channel needs to have a level _ALL_, which is des-
# ignated for annotation columns that refer to the whole array.
varMetadata(adfgood)$channel <- factor(c("G", "R", "G", "R"), 
                                       levels = c("G", "R", "_ALL_"))
phenoData(ccl4) <- adfgood
validObject(ccl4)
ccl4AM <- ccl4
assayData(ccl4AM) <- assayDataNew(A=(r+g)/2, M = r-g)
varMetadata(phenoData(ccl4AM))$channel[] <- "_ALL_"
validObject(ccl4AM)
smoothScatter(assayData(ccl4AM)$A[,2],
              assayData(ccl4AM)$M[,2], xlab = "A")
pData(ccl4AM)
par(mfrow=c(3, 2))
for (i in rownames(pData(ccl4AM))) {
    smoothScatter(assayData(ccl4AM)$A[,i],
                  assayData(ccl4AM)$M[,i], 
                  xlab = "A", ylab = "M", main = i)
    abline(h=0, col = "red")
}
design <- modelMatrix(pData(ccl4AM), ref = "DMSO")
fit <- lmFit(assayData(ccl4AM)$M, design)
fitEB <- eBayes(fit)
class(fit)
class(fitEB)
names(fit)
par(mfrow = c(1,1))
hist(fitEB$p.value, 100)
fitEB$genes <- pData(featureData(ccl4AM))
?topTable
topTable(fitEB, adjust.method = "BH")
head(sort(fitEB$t, decreasing = T))
plot(fitEB$coefficients, -log10(fitEB$p.value), pch = ".")

