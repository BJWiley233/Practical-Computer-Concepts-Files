library(biomaRt)
    
listMarts()
mouse.mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                      dataset = "mmusculus_gene_ensembl",
                      host = "useast.ensembl.org")

## find the attribute names
attrs <- listAttributes(mouse.mart)
attrs[grep("start_position", attrs$name), ]
attrs[grep("count", attrs$name), ]
attrs[grep("[Rr]ef[Ss]eq", attrs$description), ]
attrs[grep("[Bb]and", attrs$name), ] ## no "band start" or "band end" atrribute but there is plain "band" attribute
attrs[grep("[Bb]and", attrs$description), ] ## double check

filters <- listFilters(mouse.mart)
filters[grep("[Tt]ranscript", filters$name), ]
filters[grep("RefSeq", filters$description), ]
filters[grep("[Bb]and", filters$name), ] ## there is "band start" & "band end" filter but there is plain "band" filter
filters[grep("[Bb]and", filters$description), ] ## double check

## so here's the flaw with biomaRt and it may be a server side issue
## attributes are columnn of a table, you should be able to filter on any
## attribute but there are way more attributes that filters which makes
## NO sense!  There must be something on on backend.  There is NO FILTER for
## "band", only band_start and band_end, also which are not attributes
## so we have to filter the dataframe afterwards for the band.  So silly!
## You CAN'T eat your cake and you CAN'T have it too :(
mouse.results <- getBM(attributes = c("chromosome_name", "start_position", "end_position",
                                      "transcript_count", "refseq_peptide", "band"),
                       filters = c("chromosome_name", "transcript_count_greater_than", 
                                   "with_refseq_peptide"),
                       values = list(11, 6, TRUE),
                       mart = mouse.mart)
mouse.results  

library(dplyr)
mouse.results.E2band <- mouse.results %>%
                          filter(band == "E2")

## there will be multiple rows for same start and end position
## because there are multiple peptide entries, for example 
## there are 3 NP entries for start=120610087 & end=120617936
## this is similar to SQL when you do inner joins on tables
head(mouse.results.E2band)
nrow(mouse.results.E2band)

## what is min start and max end positions
min(mouse.results.E2band$start_position)

write.table(mouse.results.E2band, "week4_problem4.tsv", 
            sep = "\t", row.names = F, quote = F)
