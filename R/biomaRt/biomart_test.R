#' Used to test new biomaRt packages.  Contacted
#' Mike Smith author of package.
#' 
#' @author Brian

library("biomaRt")
BiocManager::install('grimbough/biomaRt')

ensembl = useEnsembl(biomart = "ENSEMBL_MART_ENSEMBL",
                     dataset = "hsapiens_gene_ensembl",
                     host = "uswest.ensembl.org")

affyids=c("202763_at","209310_s_at","207500_at")
getBM(attributes=c('affy_hg_u133_plus_2', 'entrezgene_id'), 
      filters = 'affy_hg_u133_plus_2', 
      values = affyids, 
      mart = ensembl)

source(file="/home/coyote/JHU_Fall_2020/Genome_Analysis/Module_4/week4_problem4_updated.R")
sessionInfo()
packageVersion("biomaRt")
library(remotes)
install_github('grimbough/biomaRt')
remove.packages("curl")
install.packages("curl")
BiocManager::install('grimbough/biomaRt')
remove.packages(c("curl", "httr"))
install.packages(c("curl", "httr"))
library(curl)
library(httr)
BiocManager::install(version = "3.11")
