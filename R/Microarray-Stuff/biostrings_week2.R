library(Biostrings)

gr <- GRanges(seqnames = "chr1", ranges = IRanges(start = 1:10, width = 3))
rl <- coverage(gr)
rl


dna1 = DNAString("ACGT-G")
dna2 <- DNAStringSet(c("ACG", "ACGT", "ACGTT"))
dna2[[1]]
names(dna2) <- paste0("seq", 1:3)
rev(dna1)

rev(dna2)
require(foreach)
foreach(x = dna2) %do% rev(x)
reverse(dna2)

translate(dna2)

alphabetFrequency(dna2)

letterFrequency(dna2, letters = "GC")
dinucleotideFrequency(dna2)
trinucleotideFrequency(dna2)

consensusMatrix(dna2)

AAString()
GENETIC_CODE # trinucleotide DNA to AA
#GENETIC_CODE_TABLE
AMINO_ACID_CODE # 1 letter AA code
RNA_GENETIC_CODE # trinucleotide RNA to AA

library(BSgenome)
available.genomes()
BiocManager::install("BSgenome.Scerevisiae.UCSC.sacCer3")


library("BSgenome.Scerevisiae.UCSC.sacCer2")
data(BSgenome.Scerevisiae.UCSC.sacCer2)
BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")

Scerevisiae
seqnames(Scerevisiae)
seqlengths(Scerevisiae)

Scerevisiae$chrI
letterFrequency(Scerevisiae$chrI, "GC")
letterFrequency(Scerevisiae$chrI, "GC", as.prob = T)
param = new("BSParams", X = Scerevisiae, FUN = letterFrequency)
bsapply(param, "GC")
unlist(bsapply(param, "GC"))

unlist(bsapply(param, "GC"))/seqlengths(Scerevisiae)
sum(unlist(bsapply(param, "GC")))/sum(seqlengths(Scerevisiae))
bsapply(param, "GC", as.prob = TRUE)
unlist(bsapply(param, "GC", as.prob = TRUE))
#unlist(bsapply(param, "GC"))/seqlengths(Scerevisiae)

library(BSgenome)
library("BSgenome.Scerevisiae.UCSC.sacCer2")
dnaseq <- DNAString("ACGTACGT")
matchPattern(dnaseq, Scerevisiae$chrI)
countPattern(dnaseq, dnaseq)
vmatchPattern(dnaseq, Scerevisiae)
dnaseq == reverseComplement(dnaseq)

matchPWM()
pairwiseAlignment(DNAString("ACGT-ACGTACCCCGT-ACGT"), DNAString("ACACGTACGTGTACGTACGTACGT"))

library(BSgenome)
vi = matchPattern(dnaseq, Scerevisiae$chrI)
vi
ranges(vi)
alphabetFrequency(vi)
shift(vi, 10)
Scerevisiae$chrI[57942:57949]

gr = vmatchPattern(dnaseq, Scerevisiae)
vi2 = Views(Scerevisiae, gr)
vi2
width(vi2)
seqnames(vi2)

library(AnnotationHub)
ahub = AnnotationHub()
# library("BSgenome.Scerevisiae.UCSC.      sacCer2      ")
qh = query(ahub, c("sacCer2", "genes"))

## SGD https://www.yeastgenome.org/ Saccharomyces Genome Database (SGD)
genes = qh[[1]]
genes = qh[["AH7048"]]
genes = ahub[["AH7048"]]
prom = promoters(genes)

prom = trim(prom)

table(width(prom))
promView = Views(Scerevisiae, prom)
class(prom)
head(promView)

promView[[1]]
Scerevisiae$chrI[128802:131001]

gcProm = letterFrequency(promView, "GC", as.prob = T)
plot(density(gcProm))
abline(v=.38)
param = new("BSParams", X = Scerevisiae, FUN = letterFrequency)
sum(unlist(bsapply(param, "GC")))/sum(seqlengths(Scerevisiae))

#Rle
library(GenomicRanges)
rl = Rle(c(1,1,1,1,1,1,2,2,2,2,2,4,4,2))
runLength(rl)
rl
runValue(rl)
ir = IRanges(start = c(2,8), width=4)
aggregate(rl, ir, FUN = mean)
mean(rl[2:5])
mean(rl[8:11])


ir = IRanges(start = 1:5, width = 3)
ir
?coverage
coverage(ir)

slice(rl, 2)

vi = Views(rl, IRanges(c(2,8), width = 2))
mean(vi)

gr <- GRanges(seqnames = "chr1", ranges = IRanges(start = 1:10, width = 3))
coverage(gr)
rl <- coverage(gr)
rl
vi = Views(rl, GRanges("chr1", ranges = IRanges(3,7)))
vi = Views(rl, as(GRanges("chr1", ranges = IRanges(3,7)), "IntegerRangesList"))

##1

BiocManager::install("BSgenome.Hsapiens.UCSC.hg19")
library(BSgenome.Hsapiens.UCSC.hg19)
Hsapiens
Hsapiens$chr22
letterFrequency(Hsapiens$chr22, "GC")/letterFrequency(Hsapiens$chr22, "ATGC")



##2
library(AnnotationHub)
ah <- AnnotationHub()
qh <- query(ah, c("H3K27me3", "H1 Cells"))
data_H1_H327Kme3 <- qh[["AH29892"]]

data_H1_H327Kme3_22 <- subset(data_H1_H327Kme3, seqnames == "chr22")
data_H1_H327Kme3_22_vi = Views(Hsapiens, data_H1_H327Kme3_22)
gcPeaks = letterFrequency(data_H1_H327Kme3_22_vi, "GC", as.prob = T)
mean(gcPeaks)

##3
data_H1_H327Kme3_22$signalValue
length(gcPeaks)
length(data_H1_H327Kme3_22$signalValue)
cor.test(gcPeaks, data_H1_H327Kme3_22$signalValue)



##4
fc_sig <- qh[["AH32033"]]
class(fc_sig)

## stupid that I have to do this twice
fc_sig_22 <- import(fc_sig, which = seqinfo(fc_sig)["chr22"], as = "Rle")
fc_sig_22_ = fc_sig_22[["chr22"]]
#Views(fc_sig_22_, ranges(data_H1_H327Kme3_22))
fc_mean = mean(Views(fc_sig_22_, ranges(data_H1_H327Kme3_22)))
cor.test(fc_mean, data_H1_H327Kme3_22$signalValue)

##5
sum(fc_sig_22_ >=1)



##6
qh_skin = query(ah, c("E055", "H3K27me3"))
fc_sig_skin <- qh_skin[["AH32470"]]
fc_sig_22_skin <- import(fc_sig_skin, which = seqinfo(fc_sig_skin)["chr22"], as = "Rle")
fc_sig_22_skin_ = fc_sig_22_skin[["chr22"]]

fc_sig_22_slice = slice(fc_sig_22_, upper = 0.5)
fc_sig_22_skin_slice = slice(fc_sig_22_skin_, lower = 2.0)
change_in_H3K27me3 = intersect(fc_sig_22_slice, fc_sig_22_skin_slice)

subset(intersect(fc_sig_22_slice, fc_sig_22_skin_slice), width > 500)
sum(width(change_in_H3K27me3)) ## answer

#####################
library(TxDb.Hsapiens.UCSC.hg19.knownGene)

txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene
genes_22 = subset(unlist(exonsBy(txdb, "gene")), seqnames == "chr22")
change_in_H3K27me3_gr = GRanges(seqnames = "chr22", strand = "+", ranges = change_in_H3K27me3)
H3K27me3_enrich_genes = intersect(change_in_H3K27me3_gr, genes_22)
H3K27me3_enrich_genes[width(H3K27me3_enrich_genes) > 200]

##7
library("BSgenome.Hsapiens.UCSC.hg19")
library(AnnotationHub)
ah = AnnotationHub()
qh = query(ah, c("hg19", "CpG Islands"))
cpg_data = qh[["AH5086"]]
cpg_data_22 = subset(cpg_data, seqnames == "chr22")
cpg_data_22_vi = Views(Hsapiens, cpg_data_22)


# act = dinucleotideFrequency(cpg_data_22_vi, as.prob = T)[, 7]
# exp = letterFrequency(cpg_data_22_vi, "C", as.prob = T) *
#            letterFrequency(cpg_data_22_vi, "G", as.prob = T)
# mean(act/exp)

widths = width(cpg_data_22_vi)
act = dinucleotideFrequency(cpg_data_22_vi)[, 7]/widths
exp = letterFrequency(cpg_data_22_vi, "C")/widths *
    letterFrequency(cpg_data_22_vi, "G")/widths
mean(act/exp)

##8
library(BSgenome.Hsapiens.UCSC.hg19)

countPattern("TATAAA", Hsapiens$chr22) + countPattern("TATAAA", reverseComplement(Hsapiens$chr22))

??TxDb.Hsapiens.UCSC.hg19.knownGene
##9
library(TxDb.Hsapiens.UCSC.hg19.knownGene)
library(BSgenome.Hsapiens.UCSC.hg19)

txdb = TxDb.Hsapiens.UCSC.hg19.knownGene
seqlevels(txdb) <- "chr22"

code_reg_22 = cdsBy(txdb)
nms = unique(names(code_reg_22))

trans_22 = subset(transcripts(txdb), tx_id %in% nms)
proms = promoters(trans_22, upstream = 900, downstream = 100)
vi = Views(Hsapiens, proms)
sum(vcountPattern("TATAAA", DNAStringSet(vi)) > 0)

##10
sum(width(slice(coverage(proms), lower = 2)))
    