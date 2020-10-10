library(biomaRt)


?useMart
ensembl = useEnsembl(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")
listFilters(ensembl)
bm <- getBM(attributes = c('affy_hugene_2_0_st_v1', 'hgnc_symbol'), 
            filters = 'affy_hugene_2_0_st_v1',
            values = affyids, mart=ensembl)
attrs <- listAttributes(ensembl)
pData(netaffxProbeset)[pData(netaffxProbeset)$transcriptclusterid == 16650883, ]

listMarts()
listEnsembl()
ensembl = useEnsembl(biomart = "ensembl")

mart <- useMart(host='feb2014.archive.ensembl.org', biomart = "ENSEMBL_MART_ENSEMBL")
ensembl <- useDataset("hsapiens_gene_ensembl", mart)
library(ALL)
data(ALL)
featureNames(ALL)
bm <- getBM(attributes = c("ensembl_gene_id", "affy_hg_u95av2"),
            filters = "affy_hg_u95av2",
            values = featureNames(ALL), mart = ensembl)
summary(bm)
sum(table(bm[,2])>1)
listAttributes(ensembl)[grep("^affy", listAttributes(ensembl)$name), ]
