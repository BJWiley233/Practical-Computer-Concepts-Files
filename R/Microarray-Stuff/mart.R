library(biomaRt)

hgvs <- c("NC_000011.9:g.534286C>A", "NC_0000X.10:g.534286C>A", 
          "NC_000011.9:g.534285C>T")

## update format for myvariant"
hgvs_ <- gsub("NC_[0-9]{4}", "chr", hgvs)

## match only first occurrence of pattern requires ancoring to beginning,
## using ? for lazy and in R \\1 is same as $1 in Bash
## https://stackoverflow.com/questions/48465393/regex-matching-only-first-occurrence-per-line
hgvs_1 <- gsub("^([^\\.\\d+]*?)\\.\\d+", "\\1", hgvs_)

## use "myvariant" package to get rs ids
rs_ids <- getVariants(hgvs_1)$dbsnp.rsid

my_variant <- rs_ids[1]
snpmart <- useMart(biomart = "ENSEMBL_MART_SNP",
                   dataset = "hsapiens_snp",
                   host = "useast.ensembl.org")

attrs <- c("chr_name", "chrom_start", "chrom_end", "chrom_strand", "refsnp_id")
desc <- getBM(attributes = attrs,
              filters = "snp_filter",
              values = my_variant,
              mart = snpmart)
desc
name <- desc$chr_name[1]


attrs_phen <- c("chr_name", "chrom_start", "chrom_end", "chrom_strand", "refsnp_id", "allele",
                "clinical_significance", "associated_gene", "phenotype_description")
filters <- c("snp_filter", "chr_name")
desc_phen <- getBM(attributes = attrs_phen,
                   filters = filters,
                   values = list(my_variant, name),
                   mart = snpmart)
desc_phen


attrs_var_pub <- c("chr_name", "chrom_start", "chrom_end", "chrom_strand", "refsnp_id", "allele",
                   "associated_variant_risk_allele", "associated_gene", "ensembl_peptide_allele")
filters <- c("snp_filter", "chr_name")
desc_var <- getBM(attributes = attrs_var_pub,
                  filters = filters,
                  values = list(my_variant, name),
                  mart = snpmart)
listAttributes(snpmart)$name

## since we don't know which one of the peptide variants is correct we will
## need to get creative and query the variants from UCSC
desc_var[desc_var$associated_variant_risk_allele == "A", ]

desc_var[desc_var$associated_variant_risk_allele == "A", ][1, ]