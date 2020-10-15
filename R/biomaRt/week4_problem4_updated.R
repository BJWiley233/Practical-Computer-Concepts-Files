#' 4. 1.25 pts. Use the web-based Biomart in Ensembl to create a dataset and save it as a TSV, CSV, or XLS file. Use the following parameters to make the dataset:
#' Dataset:
#' Ensembl Genes 93 (or the latest version)
#' Mouse genes (GRCm38.p6) (or the latest version)
#' 
#' Filters:
#' Chromosome 11
#' Band E2 only
#' Transcript count >=7
#' Limit to genes with RefSeq protein (peptide) IDs only
#' 
#' Attributes:
#' Default attributes
#' Add “RefSeq Protein (peptide) ID”
#' Get all the results, export the results to a file, and submit the file.

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
filters[grep("[Rr]ef[Ss]eq", filters$description), ]
filters[grep("[Bb]and", filters$name), ] ## there is "band start" & "band end" filter but there is plain "band" filter
filters[grep("[Bb]and", filters$description), ] ## double check


mouse.results <- getBM(attributes = c("chromosome_name", "start_position", "end_position", "strand",
                                      "transcript_count", "refseq_peptide", "band"),
                       filters = c("chromosome_name", "transcript_count_greater_than", 
                                   "with_refseq_peptide", "band_start", "band_end"),
                       values = list(11, 7, TRUE, "E2", "E2"),
                       mart = mouse.mart)
head(mouse.results)

## we need to filter on just band E2 with dplyr
# library(dplyr)
# mouse.results.E2band <- mouse.results %>%
#                           filter(band == "E2")
mouse.results.E2band = mouse.results

## there will be multiple rows for same start and end position
## because there are multiple peptide entries, for example 
## there are 3 NP entries for start=120610087 & end=120617936
## this is similar to SQL when you do inner joins on tables
head(mouse.results.E2band)

## how many results
nrow(mouse.results.E2band)

## what is min start and max end positions
min(mouse.results.E2band$start_position)
max(mouse.results.E2band$end_position)

## what is min and max transcript count
min(mouse.results.E2band$transcript_count)
max(mouse.results.E2band$transcript_count)

## write to tsv
write.table(mouse.results.E2band, "week4_problem4.tsv", 
            sep = "\t", row.names = F, quote = F)

## create GRanges object with metadata
library(GenomicRanges)
granges <- with(mouse.results.E2band, GRanges(chromosome_name,
                                              IRanges(start=start_position, end=end_position,
                                                      names=refseq_peptide,
                                                      transcript_count=transcript_count,
                                                      band=band),
                                              strand=strand),
)

## sort the Granges
sorted.granges<- sort(granges, by = ~ start)

sorted.granges

## how many on each strand
table(strand(sorted.granges))
## mostly on negative strand

## write to bed with rtracklayer
library(rtracklayer)
rtracklayer::export.bed(con="week4_problem4.bed", sorted.granges)


