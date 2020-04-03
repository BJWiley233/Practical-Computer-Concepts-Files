# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(version = "3.10")
# 
# BiocManager::install("myvariant")
# BiocManager::install("biomaRt")
# install.packages("RCurl", dependencies = T)

library(biomaRt)
library(myvariant)
library(RCurl)

x <- RCurl::getURL("https://raw.githubusercontent.com/BJWiley233/Practical-Computer-Concepts-Files/master/linux_shell/variant/snps.txt")
#hgvs <- c("NC_000011.9:g.534286C>A", "NC_0000X.10:g.534286C>A", 
#          "NC_000011.9:g.534285C>T")
hgvs <- strsplit(x, "\n")[[1]]

## update format for myvariant"
hgvs_ <- gsub("NC_[0-9]{4}", "chr", hgvs)

## match only first occurrence of pattern requires ancoring to beginning,
## using ? for lazy and in R \\1 is same as $1 in Bash
## https://stackoverflow.com/questions/48465393/regex-matching-only-first-occurrence-per-line
hgvs_1 <- gsub("^([^\\.\\d+]*?)\\.\\d+", "\\1", hgvs_)

## use "myvariant" package to get rs ids
rs_ids <- getVariants(hgvs_1)$dbsnp.rsid

all_variant_dna <- strsplit(substr(hgvs, nchar(hgvs)-3+1, nchar(hgvs)), ">")
variant <- sapply(all_variant_dna, function(x){paste0(x[1],">",x[2])})

library(plyr)
alleles <- lapply(all_variant_dna, function(x) {mapvalues(x,
                                                          from = c("A", "C", "G", "T"),
                                                          to = c("T", "G", "C", "A"))}
)
alleles_df <- sapply(alleles, function(x){paste0(x[1],">",x[2])})
chromEnd <- gsub(".*:g\\.", "", hgvs)
chromEnd <- as.numeric(gsub('\\D+','', chromEnd))

data <- data.frame("HGVS"=hgvs, "rs_id"=rs_ids, "variant"=variant, "alleles"=alleles_df,
                   "chromStart"=chromEnd-1, "chromEnd"=chromEnd, "codons"=NA,
                   "peptides"=NA, "peptides2"=NA, stringsAsFactors = FALSE)

## see if we can get peptide data
snpmart <- useMart(biomart = "ENSEMBL_MART_SNP",
                   dataset = "hsapiens_snp",
                   host = "useast.ensembl.org")
attrs_pep <- c("refsnp_id", "chr_name", "ensembl_peptide_allele")
filters <- c("snp_filter")
desc_pep <- getBM(attributes = attrs_pep,
                  filters = filters,
                  values = list(rs_ids),
                  mart = snpmart)
desc_pep
listAttributes(snpmart)

## We get duplicate rows for ch_name and peptides and there is indication which is 
## the peptide mutation for our given variant, it lists rows for all variants
## we'd have to go into Ensemble to manually look at each variant.  Or
## we can get creative like below using mySQL interface into UCSC.  We also see
## that for rs889438737 there is no peptide as this is aligned to chimp

# install.packages("RMySQL")
# install.packages("seqinr")
library(RMySQL)  ## to connect to UCSC
library(seqinr)  ## for peptide data

con_ucsc <- dbConnect(RMySQL::MySQL(), 
                      db = "hg19", 
                      user = "genome", 
                      host = "genome-mysql.soe.ucsc.edu")

## found coding snpCodingDb here http://genomewiki.ucsc.edu/genecats/index.php/SNP_Track_QA
## below code fills in the amino acid residue creatively by matching the coding alleles
## that are complement to the template ref and alt bases.
for(row in 1:nrow(data)) {
  if (! is.na(data[row, "rs_id"])) {
    
    coding <- dbGetQuery(conn = con_ucsc, 
                         statement = sprintf(
                           "SELECT bin, chromStart, chromEnd, alleles, codons, peptides, strand
                              FROM snp151CodingDbSnp 
                              WHERE name='%s'", data[row, "rs_id"])
    )
    coding
    
    if (nrow(coding) >=1) {
      coding2 <- coding[1, ]
      coding2.vars <- c("alleles", "codons", "peptides")
      coding2[coding2.vars] <- lapply(coding2[coding2.vars],
                                      function(x) {strsplit(x, ",")})
      
      matching <- match(strsplit(data[row, "alleles"], ">")[[1]], coding2$alleles[[1]])
      
      coding2[coding2.vars] <- lapply(coding2[coding2.vars], 
                                      function(x) { list(x[[1]][matching]) })
      
      coding2$peptides2 <-  paste(aaa(coding2$peptides[[1]]), collapse = ">")
      
      data[row, "codons"] <- paste(coding2$codons[[1]], collapse = ">")
      data[row, "peptides"] <- paste(coding2$peptides[[1]], collapse = ">")
      data[row, "peptides2"] <- coding2$peptides2
    }
  }
  
}

write.csv(data, "HGVS_protein.csv", row.names = F)

## next query biomart for NC_000011.9:g.534286C>A variant in rs_ids[1]

## we query for different atrtributes as Ensembl will duplicate rows
## we add to many columns and there's no MySQL interface I know of
## files are for Pubmed IDs, Phenotype, and Ensemble Transcripts IDs 

desc_Pubmed <- getBM(attributes =  c("title", "pmid"),
                       filters = "snp_filter",
                       values = list(rs_ids[1]),
                       mart = snpmart)
desc_Pubmed$link = paste0("http://europepmc.org/article/MED/",desc_Pubmed$pmid)
write.csv(desc_Pubmed, "HGVS_desc_Pubmed.csv", row.names = F)


desc_Pheno <- getBM(attributes =  c("phenotype_description"),
                     filters = "snp_filter",
                     values = list(rs_ids[1]),
                     mart = snpmart)
write.csv(desc_Pubmed, "HGVS_desc_Pheno.csv", row.names = F)


desc_Ensemble <- getBM(attributes =  c("distance_to_transcript", "ensembl_transcript_stable_id",
                               "chrom_strand", "ensembl_gene_stable_id"),
                  filters = "snp_filter",
                  values = list(rs_ids[1]),
                  mart = snpmart)
write.csv(desc_Ensemble, "HGVS_desc_Ensemble.csv", row.names = F)



