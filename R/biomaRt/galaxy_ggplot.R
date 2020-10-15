#' Plot data from Galaxy bed file because ggplot2 is not
#' that customizable in  Galaxy
#' Also will read in RS ids export  from 


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

## read in export from All SNPs(147) - Simple Nucleotide Polymorphisms (dbSNP 147) 
test <- read.table("/home/coyote/Downloads/part3_out", header=T,
                   sep="\t", comment.char = "")
cat(test$name, sep = ", ")
paste(test$name, collapse = ", ")
test[, 5]