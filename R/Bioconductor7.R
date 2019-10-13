library("ALL")
data(ALL)
bcell = grep("^B", as.character(ALL$BT))
moltype = which(as.character(ALL$mol.biol) %in% c("BCR/ABL", "NEG"))
ALL_bcrNeg = (ALL[, intersect(bcell, moltype)])
ALL_bcrNeg$mol.biol = factor(ALL_bcrNeg$mol.biol)
library(vsn)
par(mfrow=c(1,1))
meanSdPlot(ALL_bcrNeg)
meanSdPlot(ALL_bcrNeg, ranks = F)

sds = esApply(ALL, 1, sd)
sel = (sds > quantile(sds, .8))
#sum(sel)/length(sel)
ALLset1 = ALL_bcrNeg[sel, ]

eucD = dist(t(exprs(ALL_bcrNeg)))
eucM = as.matrix(eucD)
library(RColorBrewer)
hmcolor = colorRampPalette(brewer.pal(10, "RdBu"))(256)
hmcolor = rev(hmcolor)
heatmap(eucM, sym=T, col=hmcolor, distfun=as.dist)



sam = sample(nrow(ALL_bcrNeg), 10)
mat = exprs(ALL_bcrNeg[sam, ])
mat = mat - rowMedians(mat)
dim(mat)
dist(mat[1:2, 1:3])
sum(mat[1,1:3])
sum(mat[2,1:3])
heatmap(mat, sym=T, col=hmcolor, distfun=as.dist)
library(lattice)
ro = order.dendrogram(as.dendrogram(hclust(dist(mat))))
co = order.dendrogram(as.dendrogram(hclust(dist(t(mat)))))
lp = levelplot(t(mat[ro, co]), aspect="fill", col.regions = hmcolor)
print(lp)


library(genefilter)
tt = rowttests(ALLset1, "mol.biol")
?rowttests
tt$p.value
tt[1, ]
ALLset1$mol.biol
bcr = which(ALLset1$mol.biol == "BCR/ABL")
neg = which(ALLset1$mol.biol == "NEG")
ebcr = exprs(ALLset1[1, bcr])
eneg = exprs(ALLset1[1, neg])
mean(ebcr) - mean(eneg)
blue <- rgb(0, 0, 255, 50, maxColorValue=255)
plot(tt$dm, -log10(tt$p.value), pch = 19, col = blue,
     xlab = expression(mean~log[2]~fold~change))
abline(h=-log10(.00005))

sum(tt$p.value<.00005)

library(multtest)
cl = as.numeric(ALLset1$mol.biol=="BCR/ABL")
resT = mt.maxT(exprs(ALLset1), classlabel=cl, B=1000)
ord = order(resT$index)
rawp = resT$rawp[ord]
plot(tt$dm, -log10(tt$p.value), pch = 19, col = blue,
     xlab = expression(mean~log[2]~fold~change))
hist(rawp, breaks = 50, col = "lightgreen")
sum(resT$rawp < .05)
sum(resT$adjp < .05)
hist(resT$adjp, breaks = 50, col = "lightblue")
controlFDR = mt.rawp2adjp(rawp, proc = "BH")
sum(controlFDR$adjp[ ,"BH"] < .05)

## Moderated test statistics and the limma package
library("limma")
design = cbind(mean = 1, diff = cl)
dim(exprs(ALLset1))
fit = limma::lmFit(exprs(ALLset1), design)
fitBayes = limma::eBayes(fit)
library("hgu95av2.db")
ALLset1Syms = unlist(mget(featureNames(ALLset1), env = hgu95av2SYMBOL))
?topTable
top10 = limma::topTable(fitBayes, coef = "diff", sort.by = "p",
         genelist = ALLset1Syms)

top10fdr = limma::topTable(fitBayes, coef = "diff", sort.by = "p",
                           adjust.method="fdr", genelist = ALLset1Syms)
sum(top10$P.Value) == sum(top10fdr$P.Value) 

plot(-log10(tt$p.value), -log10(fitBayes$p.value[, "diff"]), pch=".",
     xlab="T-test", ylab="Moderated")
abline(0, 1, col="pink")

library(data.table)
design = data.frame(design)
idx = setDT(design)[, .I[sample(.N, 3)], by = diff]$V1
##setDT(design)[, .SD[sample(.N, 3, replace = F)], by = diff]
ALLset2 = ALL_bcrNeg[, idx]
table(ALLset2$mol.biol)

setDT(design)[, .I[sample(.N, 3, replace = F)], by = diff]$V1 ## DT[, .I[which.max(somecol)], by=grp]

tt2 = rowttests(ALLset2, "mol.biol")
fitBayes2 = eBayes(lmFit(exprs(ALLset2), design=design[idx, ]))
plot(-log10(tt2$p.value), -log10(fitBayes2$p.value[, "diff"]), pch=".",
     xlab="T-test", ylab="Moderated")
abline(0, 1, col="red")      

g = which(tt2$p.value < 1e-3 & fitBayes2$p.value[, "diff"] > .02)
# intersect(which(tt2$p.value < 1e-3), which(fitBayes2$p.value[, "diff"] > 0.02))
sel = (ALLset2$mol.biol == "BCR/ABL")+1
col = c("black", "red")[sel]
pch = c(1, 16)[sel]
plot(exprs(ALLset2)[g, ], pch=pch, col=col, ylab="expression")
