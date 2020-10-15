#' Part 3 - biomaRt
#' 1. What Ensembl genes are in a 100,000 base pair region of chromosome 20 from 5.0 to 5.3 Mb? What chromosome band are they on, what strand, and what type of genes are they?
#' Hint: Attributes are: hgnc_symbol, band, strand, gene_biotype
#' 2. Are there OMIM genes in this same region? Use "hgnc_symbol","band","strand","gene_biotype","mim_morbid_accession","mim_morbid_description" for the Attributes.

library(biomaRt)

human.mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                      dataset = "hsapiens_gene_ensembl",
                      host = "useast.ensembl.org")

listAttributes(human.mart)[grep("^mim", listAttributes(human.mart)$name), ]

dat <- getBM(attributes = c("hgnc_symbol", "chromosome_name", "start_position",
                            "end_position", "band", "strand", "gene_biotype", "ensembl_gene_id",
                            "mim_morbid_accession", "mim_morbid_description"),
             filters = c("chromosome_name"),
             values = 20,
             mart = human.mart,
             uniqueRows = T)



library(GenomicRanges)

gr1 = with(dat, GRanges(chromosome_name, 
                        IRanges(start=start_position, end=end_position, names = hgnc_symbol, 
                                band=band, gene_biotype=gene_biotype, 
                                ensembl_gene_id=ensembl_gene_id,
                                mim_morbid_accession=mim_morbid_accession,
                                mim_morbid_description=mim_morbid_description),
                        strand=strand))

gr1.new <- gr1[BiocGenerics::width(gr1) <= 100000]  

gr1.new

gr2 <- GRanges(seqnames = 20,
               ranges = IRanges(start = 5000000, end = 5300000))

partial.overlaps <- findOverlaps(query = gr1.new, subject = gr2, type = "any")

#findOverlaps(query = gr1.new, subject = gr2, type = "within")


final.answer <- gr1.new[queryHits(partial.overlaps)]
options("showHeadLines"=length(final.answer))

## part 1 gene names
final.answer$ensembl_gene_id

## part 2 OMIM annotations
final.answer[!is.na(final.answer$mim_morbid_accession)]
## The only OMIM gene is PCNA.  The disease is ATLD2
## for ATAXIA-TELANGIECTASIA-LIKE DISORDER 2
## which effect excision repair so it makes sense that it
## is involved with gene in DNA replication!

