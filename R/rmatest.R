library(affy)

#myAB <- ReadAffy()

library(CLL)
data("CLLbatch")
sampleNames(CLLbatch)
data("disease", package = "CLL")
rownames(disease) <- disease$SampleID
sampleNames(CLLbatch) <- sub("\\.CEL$", "", sampleNames(CLLbatch))
mt <- match(rownames(disease), sampleNames(CLLbatch))
vmd <- data.frame(labelDescription = c("Sample ID",
                                      "Disease status: progressive or stable disease"))
phenoData(CLLbatch) <- new("AnnotatedDataFrame", data = disease[mt,], varMetadata = vmd)
CLLbatch <- CLLbatch[, !is.na(CLLbatch$Disease)]
badArray <- match("CLL1", sampleNames(CLLbatch))
CLLB <- CLLbatch[, -badArray]
CLLrma <- rma(CLLB)
