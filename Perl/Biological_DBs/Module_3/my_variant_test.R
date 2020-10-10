BiocManager::install("myvariant")
library(myvariant)
CDK7 <- myvariant::queryVariant(q="CDK7", facets="clinvar.gene.id")
first_hit <- CDK7$hits[1, ]
colnames(first_hit)
first_hit$cadd

first_hit$cadd$encode
first_hit$cadd$polyphen
