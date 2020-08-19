library(limma)
library(leukemiasEset)
data("leukemiasEset")

ourData = leukemiasEset[, leukemiasEset$LeukemiaType %in% c("ALL", "NoL")]
ourData$LeukemiaType <- factor(ourData$LeukemiaType)

new_names = paste0(sub("\\..*", "", sampleNames(ourData)), "-", ourData$LeukemiaType)
sampleNames(ourData) = new_names

library(genefilter)
ourData$LeukemiaType
ourDatatt <- rowttests(ourData, "LeukemiaType")
logtrans = -log10(ourDatatt$p.value)
plot(ourDatatt$dm, logtrans, pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p))




o1 = order(abs(ourDatatt$dm), decreasing=T)[1:25]
ourDatatt[o1, ]


library(biomaRt)
ensembl = useEnsembl(biomart = "ensembl", 
                     dataset = "hsapiens_gene_ensembl",
                     host    = "www.ensembl.org")
genedesc <- getBM(attributes = c("ensembl_gene_id", "external_gene_name", "description"),
                  filters = c("ensembl_gene_id"),
                  values = featureNames(ourData)[o1],
                  mart = ensembl)
library(stringr)
genedesc$description <- sub(" \\[.*", "", genedesc$description)
rownames(genedesc) <- genedesc$ensembl_gene_id

table <- genedesc[featureNames(ourData)[o1], ] ## diff express
table$pvalue <- ourDatatt$dm[o1]
genedesc[featureNames(ourData)[o1], 1:2]

gen_symb = genedesc[featureNames(ourData)[o1], 1:2]$external_gene_name
#cbind(gen_symb, ourDatatt[o1, ])

par(mar=c(5.1, 4.1, 4.1, 7.1))
plot(ourDatatt$dm, logtrans, pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p), xlim=c(-7,6))
points(ourDatatt$dm[o1], logtrans[o1], pch=18, col = 'blue')
with(as.data.frame(cbind(ourDatatt$dm[o1], logtrans[o1])), 
     text(V2~V1,labels = gen_symb, pos = 4, cex = 0.6))
legend(grconvertX(0.85, "ndc", "user"),
       grconvertY(0.85, "ndc", "user"),
       paste0(1:25,". ", gen_symb), xpd=T, cex = 0.6)


design = model.matrix(~ ourData$LeukemiaType)
fit <- lmFit(ourData, design)
ebfit <- eBayes(fit)

plot(ourDatatt$dm, -log10(ebfit$p.value[,2]), pch=".", xlab="log-ratio",
     ylab=expression(-log[10]~p), xlim=c(-7,6))
