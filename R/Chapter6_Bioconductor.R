library(Biobase)
library(genefilter)
library(ALL)
data(ALL)

b_cell <- grep("^B", as.character(ALL$BT))
moltyp_BCR_ABL <- which(as.character(ALL$mol.biol) %in% c("NEG", "BCR/ABL"))

ALL_b_cell_bcrneg <- ALL[, intersect(b_cell, moltyp_BCR_ABL)]
ALL_b_cell_bcrneg$mol.biol <- factor(ALL_b_cell_bcrneg$mol.biol)
sds <- rowSds(exprs(ALL_b_cell_bcrneg))
ncol(exprs(ALL_b_cell_bcrneg))
nrow(exprs(ALL_b_cell_bcrneg))
sh <- shorth(sds)
hist(sds, breaks=50, col="mistyrose")
abline(v=sh, lty=2, lwd=2, col="blue")

ALLsfilt <- ALL_b_cell_bcrneg[sds>=sh, ]
dim(exprs(ALLsfilt))
?nsFilter
test <- nsFilter(ALL_b_cell_bcrneg)$eset
nrow(exprs(test))
table(ALLsfilt$mol.biol)
sum(table(ALLsfilt$mol.biol))
?rowttests
tt <- rowttests(ALLsfilt, fac = "mol.biol")
sampleNames(ALLsfilt)[ALLsfilt$mol.biol=="NEG"]
par(mfrow=c(1,2))
hist(tt$p.value, breaks=50, col="mistyrose")

ALLsrest <- ALL_b_cell_bcrneg[sds<sh, ]
ttrest <- rowttests(ALLsrest, fac = "mol.biol")
hist(ttrest$p.value, breaks=50, col="lightblue")

library(multtest)
?mt.rawp2adjp
mt <- mt.rawp2adjp(tt$p.value, proc = "BH")
mt$index[1:10]
tt$p.value[mt$index[1:10]]
length(featureNames(ALLsfilt))
g <- featureNames(ALLsfilt)[mt$index[1:10]]
library(hgu95av2.db)
links
showMethods("links")
hgu95av2SYMBOL(g)
links(hgu95av2SYMBOL[g])
toTable(hgu95av2SYMBOL[g])
g[1]
mb <- ALLsfilt$mol.biol
y <- exprs(ALLsfilt)[g[1], ]
order(ALLsfilt$mol.biol)
df <- data.frame(sample=mb, log2exprs=y)
library(ggplot2)
ggplot(aes(x=1:nrow(df), y = log2exprs), data = df) +
    geom_point(aes(colour = factor(sample)))
