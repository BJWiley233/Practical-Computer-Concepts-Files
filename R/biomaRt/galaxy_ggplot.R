#' Plot data from Galaxy bed file because ggplot2 is not
#' that customizable in  Galaxy
#' Also will read in RS ids export  from 

#' Part 2
#' c. (0.25 pts) Draw a histogram of the number of exons in each gene.  You may use any tools. 
#' Check out details on BED12 format here if you're not sure which column to use. Play around 
#' with the parameters to produce a graph that looks good. Don't forget to label the x axis! 
#' Submit the histogram.

## Plot hist on column 10 of BED12 for CDS exon number
bed <- read.table("/home/coyote/Downloads/Galaxy1-[UCSC_Main_on_Human__knownGene_(chr16_1-500,000)].bed",
                  header=F)

library(ggplot2)
ggplot(bed, aes(x=V10, fill=..count..)) +
  geom_histogram(binwidth = 1) +
  ggtitle("Histogram Gene (Transcript) count with X number of Exons") +
  xlab("Number of Exons") +
  theme(axis.text.x = element_text(angle=45)) + 
  scale_x_continuous(breaks=seq(min(bed$V10), max(bed$V10), by=1)) +
  scale_fill_gradient("Legend", low="yellow", high = "red")

table(bed$V10)

#' Part 2
#' a. (0.25 pts) Use Galaxy to query for hg38 genes in ENCODE region ENm008 (chr16:1-500000) from the UCSC 
#' Main table browser at UCSC (group: Genes and Gene Predictions, track: GENCODE v32 or newer, output format: BED). 
#' On the next page, choose Whole Gene. How many genes were identified?

# write transcript ids to table without version id
write.table(gsub("\\..*", "", bed$V4), quote = F, file="transcripts", col.names=F, row.names=F) 

# read result from Ensembl BioMart
biomart <- read.table("/home/coyote/Downloads/mart_export(3).txt", sep="\t", header=T)
length(unique(biomart$Gene.stable.ID))


#' Part 3
#' Using IGV for hg19, load dbSNP 1.4.7 or newer (i.e. Available Datasets > Annotations > Variation and Repeats > dbSNP 1.4.7) 
#' and an exome sequencing track from the 1000 Genomes project (1000 Genomes > Alignments > GBR > exome > HG00096 exome). 
#' Go to the EPHX1 gene and zoom in on the exon #4.
#' a. (0.25 pts) How many SNPs overlap this exon and what are the SNP IDs?

## read in export from All SNPs(147) - Simple Nucleotide Polymorphisms (dbSNP 147) 
test <- read.table("/home/coyote/Downloads/part3_out", header=T,
                   sep="\t", comment.char = "")
cat(test$name, sep = ", ")
paste(test$name, collapse = ", ")
test[, 5]