BiocManager::install('qpcrNorm')
library(qpcrNorm)
install.packages(c('crosstalk', 'matrixStats', 'RMySQL', 'shiny'))
update.packages(c("nlme", "survival"))

data("qpcrBatch.object")
slotNames(qpcrBatch.object)
slot(qpcrBatch.object, "geneNames")
# https://www.wvdl.wisc.edu/wp-content/uploads/2013/01/WVDL.Info_.PCR_Ct_Values1.pdf
# Ct levels are inversely proportional to the amount of target
# nucleic acid in the sample
# Cts < 29 are strong positive reactions indicative of abundant target nucleic acid in the sample
# Cts of 30-37 are positive reactions indicative of moderate amounts of target nucleic acid
# Cts of 38-40 are weak reactions indicative of minimal amounts of target nucleic acid
snippet = slot(qpcrBatch.object, "exprs")[1:4, ]

## different time-points ??
## qPCR analysis at nine time-points (0 hrs, 6 hrs and 1, 2, 4, 6, 12, 16 and 21 days)
## https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2926816/
?ctQc
?readQpcr
BiocManager::install("ReadqPCR")
library(ReadqPCR)

myNormRI.data = normQpcrRankInvariant(qpcrBatch.object, 1)
slot(myNormRI.data, "exprs")[1:4, ]
