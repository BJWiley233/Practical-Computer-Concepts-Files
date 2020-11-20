# yeast.mine <- read.table("/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_8/GOTerm_Genes.tsv", sep="\t")
# length(unique(yeast.mine$V2))
## 61

library(biomaRt)
library(dplyr)

ensembl <- useEnsembl(biomart="ENSEMBL_MART_ENSEMBL",
                      dataset = "scerevisiae_gene_ensembl",
                      host = "useast.ensembl.org")

## this will give random Go ids for some reason
data <- getBM(attributes = c("ensembl_gene_id", "go_id"),
              filters = "go",
              values ="GO:0006623",
              mart = ensembl)

GO_0006623 <- data %>% filter(go_id == "GO:0006623")
## this only lists 45

write.table(GO_0006623, "/home/coyote/part3_ec.tsv", sep="\t", row.names = F, quote = F)

## which are returned from YeastMine but are missing from Ensembl?
#setdiff(yeast.mine$V2, GO_0006623$ensembl_gene_id)

