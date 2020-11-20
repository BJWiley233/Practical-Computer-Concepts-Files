library(biomaRt)

human.var <- useMart(biomart = "ENSEMBL_MART_SNP",
                     dataset = "hsapiens_snp",
                     host = "uswest.ensembl.org")

var.dat <- getBM(attributes = c("ensembl_gene_stable_id", "consequence_type_tv", "refsnp_id", 
                                "ensembl_peptide_allele",
                                "sift_prediction"),
                 filters = c("ensembl_gene", "consequence_type_tv"),
                 values = c("ENSG00000143819", "protein_altering_variant"),
                 mart = human.var,
                 uniqueRows=T)
head(var.dat, 50)
unique(var.dat$consequence_type_tv)
var.dat[var.dat$consequence_type_tv == "protein_altering_variant", ]

listFilters(human.var)

human.mart <- useMart(biomart = "ENSEMBL_MART_ENSEMBL",
                      dataset = "hsapiens_gene_ensembl",
                      host = "useast.ensembl.org")
listMarts()
listDatasets(human.var)

human.var <- useMart(biomart = "ENSEMBL_MART_SNP",
                     dataset = "hsapiens_snp",
                     host = "uswest.ensembl.org")

var.dat <- getBM(attributes = c("ensembl_gene_stable_id", "consequence_type_tv", "refsnp_id", 
                                "ensembl_peptide_allele",
                                "sift_prediction"),
                 filters = c("ensembl_gene"),
                 values = c("ENSG00000143819"),
                 mart = human.var,
                 uniqueRows=T)
head(var.dat)


searchFilters(human.var, "gene")  
listFilters(human.var)
listAttributes(human.var)
searchAttributes(human.var, "gene")
  
ENm008 <- read.table("/home/coyote/Downloads/Galaxy1-[UCSC_Main_on_Human__knownGene_(chr16_1-500,000)](1).bed",
                     header=F)

hist(ENm008$V10, breaks=c(0:18), main="breaks=0:18")

breaks=18
hist_breaks = seq(min(ENm008$V10), max(ENm008$V10), by=((max(ENm008$V10) - min(ENm008$V10))/(breaks - 1))) # giving c (0:18)
hist(ENm008$V10, breaks=hist_breaks, main="wrong start for breaks 1:18") 


breaks=18
hist_breaks = seq(min(ENm008$V10) - 1, max(ENm008$V10), by=((max(ENm008$V10) - min(ENm008$V10))/(breaks - 1))) # giving c (0:18)
hist(ENm008$V10, breaks=hist_breaks, main="correct start for breaks 0:18") 

transcripts <- ENm008$V4
# remove version
transcripts <- gsub("\\..*", "", transcripts)
# sanity make sure 198
length(unique(transcripts))


  gene.data <- getBM(attributes=c("ensembl_transcript_id", "ensembl_transcript_id"),
                   filters="ensembl_transcript_id",
                   values=transcripts,
                   mart=human.mart)

# biomaRt not working have to use interface
# Error: failed to load external entity "http://www.ensembl.org/info/website/archives/index.html?redirect=no"
write.table(transcripts, "part2.txt", row.names=F, quote=F, col.names=F)

biomart.web <- read.csv("/home/coyote/Downloads/mart_export(1).txt")
length(unique(biomart.web$Gene.stable.ID))  

# missing 1 here
nrow(biomart.web)

# which one?
transcripts[!transcripts %in% biomart.web$Transcript.stable.ID]

part2 <- read.csv("/home/coyote/Downloads/ensembl-export.csv")
strsplit(unique(part2$Conseq..Type),"~")

sapply(as.character(unique(part2$Conseq..Type)), function(x) strsplit(x, "~"))
unique(unlist(sapply(as.character(unique(part2$Conseq..Type)), function(x) strsplit(x, "~"))))
