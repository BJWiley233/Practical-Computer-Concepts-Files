library(biomaRt)


human.mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                      dataset = "hsapiens_gene_ensembl",
                      host = "useast.ensembl.org")

#listAttributes(human.mart)
listFilters(human.mart)[grep("chromosomal_region", listFilters(human.mart)$name),]
dat <- getBM(attributes = c("hgnc_symbol", "chromosome_name", "start_position",
                              "end_position", "band", "strand", "gene_biotype", "ensembl_gene_id"),
             filters = c("chromosome_name"),
             values = 20,
             mart = human.mart,
             uniqueRows = T)

# gives 1458 rows
nrow(dat)



library(GenomicRanges)
## GRanges from Bioconductor is SWEET
## https://web.mit.edu/~r/current/arch/i386_linux26/lib/R/library/GenomicRanges/html/GRanges-class.html
## in the IRanges call you can name all you metadeta, i.e. the data past the "|"
## it just can't be "seqnames", "ranges", "strand", "seqlevels", "seqlengths", 
## "isCircular", "start", "end", "width", or "element".
## So here is where we can put the band and biotype information
gr1 = with(dat, GRanges(chromosome_name, 
                         IRanges(start=start_position, end=end_position, names = hgnc_symbol, 
                                 band=band, gene_biotype=gene_biotype, 
                                 ensembl_gene_id=ensembl_gene_id),
                         strand=strand))

## take a look at GRanges
## more at Dr. Hansen's page (He is at JHU!)
## https://kasperdanielhansen.github.io/genbioconductor/html/GenomicRanges_GRanges_Usage.html#granges-metadata
gr1

## how many are <= 100k in length we can subset just like a data frame
## see "width", "start", "end" functionsfrom BiocGenerics
#gr1.new <- gr1[BiocGenerics::width(gr1) <= 300000]  
gr1.new <- gr1[BiocGenerics::width(gr1) <= 100000] 

## gives us 1375 genes 
gr1.new


## from Biostars post, we don't need the completely overlapping
## because that would be >300,000 in length.  We just need
## to actually do type = 'any' and this will give us overlaping 
## and within, see my comment in Biostars
## https://www.biostars.org/p/98151/

## first we create are 300 kb range for Chr20, i.e. our subject
gr2 <- GRanges(seqnames = 20,
               ranges = IRanges(start = 5000000, end = 5300000))

## partial overlaps first, i.e. start just before 5000000,
## or end just past 5300000
partial.overlaps <- findOverlaps(query = gr1.new, subject = gr2, type = "any")

## below would just give use genes that were within the subject between 
## there are the same because not gene overlap the start or end
## test making the gr2 ranges above with "start = 4869000, end = 5310000"
findOverlaps(query = gr1.new, subject = gr2, type = "within")

## since GRanges is sorted automatically by the custructor you will get 
## index hits, again subset like a dataframe
final.answer <- gr1.new[queryHits(partial.overlaps)]
width(final.answer)
## Questions

## What Ensemble genes are <= 100 kb long in the 300 kb range 5.0 to 5.3 mb?
## There are 12
## https://stackoverflow.com/questions/16949545/show-all-lines-in-genomicrange-package-output
options("showHeadLines"=length(final.answer))
final.answer

  final.answer$ensembl_gene_id
## What are their names if protein coding?
names(final.answer)[!names(final.answer) == ""]
## Ah ha PCNA the Sliding clamp that surrounds DNA during replication!

## what chromsome band(s)
factor(final.answer$band)
## bands p12.3 & p13

## what strand and counts, returns a RLE
BiocGenerics::strand(final.answer)
## There are 10 (-) then 1 (+) then 1 (-)

## What are the bio types?
factor(final.answer$gene_biotype)
## see levels, there are:
## lncRNA, misc_RNA, processed_pseudogene, protein_coding, rRNA_pseudogene snoRNA

## how many of each
table(final.answer$gene_biotype)
## 4 lncRNA and 3 protein_coding