library(biomaRt)


human.mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                      dataset = "hsapiens_gene_ensembl",
                      host = "useast.ensembl.org")

searchAttributes("s[Bb]and")
listAttributes(human.mart)$description
searchFilters(human.mart, "[Bb]and")

dat <- getBM(attributes = c("hgnc_symbol", "chromosome_name", "start_position",
                            "end_position", "band", "strand", "gene_biotype", "ensembl_gene_id",
                            "Gene % GC content", "PROSITE patterns ID"),
             filters = c("chromosome_name", "band_start", "band_end"),
             values = list(17, "q21.31", "q21.31"),
             mart = human.mart,
             uniqueRows = T)
sum(table(dat$gene_biotype))

searchAttributes(human.mart, "PROSITE patterns ID")

dat1 <- getBM(attributes = c("hgnc_symbol", "percentage_gene_gc_content", "scanprosite"),
             filters = c("chromosome_name", "band_start", "band_end"),
             values = list(17, "q21.31", "q21.31"),
             mart = human.mart,
             uniqueRows = T)
dat1[dat1$hgnc_symbol=="BRCA1", ]

library(dplyr)


dat1 %>% 
  select(hgnc_symbol, percentage_gene_gc_content) %>%
  distinct(hgnc_symbol, percentage_gene_gc_content) %>%
  arrange(desc(percentage_gene_gc_content)) %>%
  top_n(10)

dat1 %>% 
  select(hgnc_symbol, scanprosite) %>%
  filter(scanprosite != "") %>%
  distinct()
