library(affy)

#myAB <- ReadAffy()

library(CLL)
data("CLLbatch")
sampleNames(CLLbatch)
pData(CLLbatch)$Disease

data("disease", package = "CLL")
head(disease)
rownames(disease) <- disease$SampleID
sampleNames(CLLbatch) <- sub("\\.CEL$", "", sampleNames(CLLbatch))
mt <- match(rownames(disease), sampleNames(CLLbatch))


vmd = data.frame(labelDescription = c("Sample ID",
                                      "Disease status: progressive or stable disease"))
phenoData(CLLbatch) <- new("AnnotatedDataFrame", data = disease[mt,], varMetadata = vmd)
CLLbatch <- CLLbatch[, !is.na(CLLbatch$Disease)]





library("simpleaffy")
saqc <- simpleaffy::qc(CLLbatch)
plot(saqc)

dd <- dist2(log2(exprs(CLLbatch)))

diag(dd) = 0
dd.row <- as.dendrogram(hclust(as.dist(dd)))
row.ord <- order.dendrogram(dd.row)
library(latticeExtra)
legend = list(top=list(fun=dendrogramGrob,
                       args=list(x=dd.row, side="top")))

col.l <- colorRampPalette(c('yellow', 'red'))(16)
lp <- levelplot(dd[row.ord, row.ord],
                scales = list(x=list(rot=90)), xlab="",
                ylab="", legend = legend, col.regions=col.l)
lp
col.l <- colorRampPalette(c('blue', 'green', 'purple', 'yellow', 'red'))(30)


library(affyPLM)
dataPLM <- fitPLM(CLLbatch)
boxplot(dataPLM, main = "NUSE", ylim = c(.95,1.22),
        outline = F, col = "lightblue", las = 3,
        whisktly = 0, staplelty = 0)
Mbox(dataPLM, main = "RLE", ylim = c(-.4,.4),
        outline = F, col = "mistyrose", las = 3,
        whisktly = 0, staplelty = 0)

badArray <- match("CLL1", sampleNames(CLLbatch))
CLLB <- CLLbatch[, -badArray]

Mbox(fitPLM(CLLB), main = "RLE", ylim = c(-.4,.4),
     outline = F, col = "mistyrose", las = 3,
     whisktly = 0, staplelty = 0)

CLLrma <- rma(CLLB)
?rma
class(CLLB)
class(CLLrma)

e <- exprs(CLLrma)
dim(e)
dim(CLLrma)
e[grep("^AFFX", featureNames(CLLrma)),]
pData(CLLrma)
?nsFilter
CLLf <- nsFilter(CLLrma, remove.dupEntrez = F, var.cutoff = .5)$eset
class(CLLf)
pData(CLLf)
?rowttests
CLLtt <- rowttests(CLLf, "Disease")
names(CLLtt)
CLLtt[1,]
exprs(CLLf)[1,]
index_stable <- which(pData(CLLf)$Disease=="stable")
exprs(CLLf)[1,][index_stable]
t.test(exprs(CLLf)[1,][index_stable], exprs(CLLf)[1,][-index_stable], var.equal = T)



length(exprs(CLLf)[1,])
mean(exprs(CLLf)[2,][-index_stable])-mean(exprs(CLLf)[2,][index_stable])
a <- rowMeans(exprs(CLLf))

plot(a, CLLtt$dm, pch = ".")
abline(h = 0, col = "blue")
plot(rank(a), CLLtt$dm, pch = ".")
abline(h = 0, col = "blue")

library(limma)
#(nsFilter(rma(CLLB), remove.dupEntrez = F, var.cutoff = .5)$eset)$Disease
design_ <- model.matrix(~CLLf$Disease)
CLLlim <- lmFit(CLLf, design_)
CLLeb <- eBayes(CLLlim)


par(mfrow=c(1,2))
nlog10_CLLtt_p <- -log10(CLLtt$p.value)
smallest25p
CLLtt$p.value[rank(CLLtt$p.value) <= 25]
smallest25p_index <- match(CLLtt$p.value[rank(CLLtt$p.value) <= 25], CLLtt$p.value)
smallest25p <- -log10(CLLtt$p.value[rank(CLLtt$p.value) <= 25])
plot(x = CLLtt$dm[-smallest25p_index], y = nlog10_CLLtt_p[-smallest25p_index], pch = ".", 
     ylab = expression(-log[10]~p), xlab="log-ratio", main = "rowttest",
     points(x=CLLtt$dm[smallest25p_index],
            y= smallest25p, col="blue"), 
     xlim <- c(-2,2),
     ylim <- c(0,max(smallest25p)+.5))

smallest25dm_index <- match(CLLtt$dm[rank(-abs(CLLtt$dm)) <= 25], CLLtt$dm)
smallest25dm <- CLLtt$dm[rank(-abs(CLLtt$dm)) <= 25]
plot(x = CLLtt$dm[-smallest25dm_index], y = nlog10_CLLtt_p[-smallest25dm_index], pch = ".", 
     ylab = expression(-log[10]~p), xlab="log-ratio", main = "rowttest",
     points(x=smallest25dm,
            y= nlog10_CLLtt_p[smallest25dm_index], col="blue", pch=18), 
     xlim <- c(-2,2),
     ylim <- c(0,5.2))
#better
plot(CLLtt$dm, nlog10_CLLtt_p, pch=".", xlab="log-ratio",
       ylab=expression(log[10]~p))
o1 = order(abs(CLLtt$dm), decreasing=TRUE)[1:25]
points(CLLtt$dm[o1], nlog10_CLLtt_p[o1], pch=18, col="blue")
         
abline(h=2)
?points()

mod_nlog10_CLLtt_p <- -log10(CLLeb$p.value[,2])
plot(CLLeb$coefficients[,2], mod_nlog10_CLLtt_p, pch=".", 
     ylab = expression(-log[10]~p), xlab="log-ratio", main = "mod Bayes")
abline(h=2)


############################
sum(CLLtt$p.value < .01)
sum(CLLeb$p.value[,2] <= .01)

table_ <- topTable(CLLeb, coef = 2, adjust.method = "BH", n=10)
length(featureNames(CLLrma))
genenames <- as.character(row.names(table_))
library(annotate)
annotation(CLLf)
library(hgu95av2.db)
ll <- getEG(genenames, "hgu95av2.db")
sym <- getSYMBOL(genenames, "hgu95av2.db")
tab <- data.frame(sym, signif(table_,3))

htmlpage(list(ll), othernames = tab, filename = "GeneList.html", title = "HTML Report",
         table.center = T, table.head = c("Entrez ID", colnames(tab)))
browseURL("GeneList.html")

library(KEGG.db)
library(hgu95av2.db)
library(annaffy)
atab <- aafTableAnn(genenames, "hgu95av2.db", aaf.handler())
saveHTML(atab, file="GeneList2.html")

browseURL("GeneList2.html")

atab <- aafTableAnn(genenames, "hgu95av2.db", aaf.handler()[c(2,5,8,12)])
saveHTML(atab, file="GeneList3.html")

browseURL("GeneList3.html")
library(GO.db)

perfectmatch <- pm(CLLB)
mismatch <- mm(CLLB)
perfectmatch
smoothScatter(log2(mismatch[, "CLL11"]), log2(perfectmatch[, "CLL11"]),
              xlab = expression(log[2] * "MM"),
              ylab = expression(log[2] * "PM"))
abline(0,1, col = "red")
library(ggplot2)



library(genefilter)
library(geneplotter)


grouping <- cut(log2(perfectmatch)[,1], breaks = c(-Inf, log2(2000), Inf), 
                labels = c("low", "high"))
multidensity(log2(mismatch)[,1] ~ grouping, main = "", xlab = "", col = c("red", "blue"))

#CLLrma <- rma(CLLB)
bgrma <- bg.correct.rma(CLLB)
exprs(bgrma) <- log2(exprs(bgrma))
library(vsn)
bgvsn <- justvsn(CLLB)

#length(indexProbes(CLLB, "pm")$`100_g_at`)*(11625+1000)

sel <- sample(unlist(indexProbes(CLLB, "pm")), 500)
sel <- sel[order(exprs(CLLB)[sel, 1])]
yo <- exprs(CLLB)[sel, 1]
yRMA <- exprs(bgrma)[sel, 1]
yVSN <- exprs(bgvsn)[sel, 1]

par(mfrow=c(1,3))
plot(yo, yRMA, xlab="orig", ylab="RMA", log="x", type="l", asp=1)
plot(yo, yVSN, xlab="orig", ylab="VSN", log="x", type="l", asp=1)
plot(yRMA, yVSN, xlab="RMA", ylab="VSN", type="l", asp=1)

CLLvsn <- vsnrma(CLLB)

#CLLf <- nsFilter(CLLrma, remove.dupEntrez = F, var.cutoff = .5)$eset
#CLLtt <- rowttests(CLLf, "Disease")

CLLvsnf <- nsFilter(CLLvsn, remove.dupEntrez = F, var.cutoff = .5)$eset
CLLvsntt <- rowttests(CLLvsnf, fac = "Disease")
par(mfrow=c(1,1))

inboth <- intersect(featureNames(CLLvsnf), featureNames(CLLf))
plot(CLLtt[inboth, "statistic"], CLLvsntt[inboth, "statistic"])
length(inboth)
length(CLLtt$statistic)
length(CLLvsntt$statistic)
#plot(CLLtt[, "statistic"], CLLvsntt[, "statistic"])
abline(0,1)


perfectmatch <- pm(CLLB)
mismatch <- mm(CLLB)
pns <- probeNames(CLLB)
library(RColorBrewer)
colors <- brewer.pal(8, "Dark2")
indices <- split(seq(along=pns), pns)
probe_choice <- indices[["189_s_at"]][seq(along=colors)]

(perfectmatch[probe_choice, 1:12])
random_7 <- sample(1:22, 7)
?matplot
matplot(t(perfectmatch[probe_choice, 1:12]), pch = "P", log = "y", type = "b", col = colors,
        ylim=c(50,2000))
matplot(t(mismatch[probe_choice, 1:12]), pch = "M", log = "y", type = "b", col = colors,
        ylim=c(50,2000), add = T)

newsummary <- t(sapply(indices, function (x)
    rowMedians(t(perfectmatch[x,]-mismatch[x,]))))
dim(newsummary)

colMeans(newsummary<0)*100
colSums(newsummary<0)/nrow(newsummary)*100
