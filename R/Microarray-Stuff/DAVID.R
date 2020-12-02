## write top 5 up and down to file
write.table(diff.exp.genes, file = "diff.exp.genes.txt", quote=F, sep="\t", row.names = F)
## list of the probes for NCBI David
write.table(diff.exp.genes$probe, file = "probes.txt", quote=F, sep="\t", row.names = F,
            col.names = F)


setwd("/home/coyote/JHU_Fall_2020/Data_Analysis/project")
diff.exp.genes2 <- read.table(file = "diff.exp.genes.txt", sep="\t", header=T)
class(diff.exp.genes2$probe)
class(diff.exp.genes$probe)
class(diff.exp.genes$probe)
## got fix your java certificates first
## https://support.bioconductor.org/p/72188/
library(RDAVIDWebService)
david <- DAVIDWebService$new(email="bwiley4@jh.edu", url="https://david.ncifcrf.gov/webservice/services/DAVIDWebService.DAVIDWebServiceHttpSoap12Endpoint/")
result <- addList(david, diff.exp.genes$probe,
                  idType="AFFYMETRIX_3PRIME_IVT_ID",
                  listName="Top5All", listType="Gene")

## see 39 of the 40 probe ids were annotated
david
## get GO and Paths/interactions, need to set at least 1 annotation 
## that has 100% of the IDs so there are rows for each annotation = number of IDs
## that is pretty silly
setAnnotationCategories(david, c("GOTERM_CC_DIRECT",
                                 "KEGG_PATHWAY", "REACTOME_PATHWAY",
                                 "MINT", "INTACT", "UCSC_TFBS", "ENSEMBL_GENE_ID"))
## or just get GO and Ensemble ID
#setAnnotationCategories(david, c("GOTERM_CC_DIRECT", "ENSEMBL_GENE_ID"))

## get annotations selected, returns sparse matrix for your probes for each annotation
## need novel way to convert below
annotTable <- RDAVIDWebService::getFunctionalAnnotationTable(david)
memberships <- RDAVIDWebService::membership(annotTable)
annotTable@Genes ## gene names
nrow(annotTable@Genes) ## 40 since I have 4 groups, you should have 10

## now there are only 39 rows find which id is missing
## since we can't set annotTable@Genes[,"ID"] as names with 40 on list of 39
nrow(memberships$KEGG_PATHWAY) ## this is 40
all(lapply(memberships, function(x) nrow(x))==nrow(diff.exp.genes)) ## now all are 40 in length good, 10 for you


## add full genes names to your results
library("dplyr")
diff.exp.genes.with.names <- left_join(diff.exp.genes, annotTable@Genes[,1:2], by=c("probe"="ID"))



## BELOW to add column for go ids and columns for go terms
## GO comes with a dictionary mapping of ids to terms, pretty nice
go.matrix <- as.data.frame(memberships$GOTERM_CC_DIRECT)
go.dict <- annotTable@Dictionary$GOTERM_CC_DIRECT
## above is not real dict, lists are real dicts in R
go.dict.real.dict <- setNames(split(go.dict[,2], seq(nrow(go.dict))), go.dict[,1])
## Example 'endoplasmic reticulum'
go.dict.real.dict$`GO:0005783`

## create adjacency lists from sparse go matrix for ids and use dict for terms
go.ids.per.probe <- apply(go.matrix, 1, function(x) colnames(go.matrix)[which(x==TRUE)])
names(go.ids.per.probe) <- annotTable@Genes[,"ID"]
go.terms.per.probe <- lapply(go.ids.per.probe, function(x) sapply(x, function(y) go.dict.real.dict[[y]]))
names(go.terms.per.probe) <- annotTable@Genes[,"ID"]

## make GO ID dataframe and join
## set the collapse to any delimter you want with your annotations
## NCBI David uses comma separated
## This is really a matrix need to convert
## https://stackoverflow.com/questions/4227223/convert-a-list-to-a-data-frame
goid.list <- lapply(go.ids.per.probe, function(x) paste0(x, collapse = ", "))
goid.df <- data.frame(matrix(unlist(goid.list), nrow=length(goid.list), byrow = T), stringsAsFactors = FALSE)
colnames(goid.df) <- "goIDs"
rownames(goid.df) <- annotTable@Genes[,"ID"]
goid.df$ID <- annotTable@Genes[,"ID"]
## add go terms to differential expression dataframe
diff.exp.genes.with.names.goids <- left_join(diff.exp.genes.with.names, 
                                             goid.df, by=c("probe"="ID"))


# same for terms
goTerm.list <- lapply(go.terms.per.probe, function(x) paste0(x, collapse = ", "))
goTerm.df <- data.frame(matrix(unlist(goTerm.list), nrow=length(goTerm.list), byrow = T), 
                        stringsAsFactors = FALSE)
colnames(goTerm.df) <- "goTerms"
rownames(goTerm.df) <- annotTable@Genes[,"ID"]
goTerm.df$ID <- annotTable@Genes[,"ID"]
## add go terms to differential expression dataframe
diff.exp.genes.with.names.goidsAndTerms <- left_join(diff.exp.genes.with.names.goids, 
                                                     goTerm.df, by=c("probe"="ID"))


cat(sum(diff.exp.genes.with.names.goidsAndTerms$goIDs != ""), "entries for", "Go IDs")
cat(sum(diff.exp.genes.with.names.goidsAndTerms$goTerms != ""), "entries for", "Go Terms")
## so for me two of the probes matched (SOX5) so 37 is really 36

################################################################################################
## repeat for other annotations but make individual dataframes
## i.e. the original columns of diff.exp.genes and new column for 
## each of "KEGG_PATHWAY", "REACTOME_PATHWAY", "MINT", "INTACT", "UCSC_TFBS"
memberships <- RDAVIDWebService::membership(annotTable)
names(memberships)
# memberships$KEGG_PATHWAY
# annotation <- "KEGG_PATHWAY"

# make annotation dataframe function
make.annot.df <- function(annotation) {
  matrix <- as.data.frame(memberships[[annotation]])
  annot.per.probe <- apply(matrix, 1, function(x) colnames(matrix)[which(x==TRUE)])
  names(annot.per.probe) <- annotTable@Genes[,"ID"]
  
  annot.list <- lapply(annot.per.probe, function(x) paste0(x, collapse = ", "))
  annot.df <- data.frame(matrix(unlist(annot.list), nrow=length(annot.list), byrow = T), 
                         stringsAsFactors = FALSE)
  colnames(annot.df) <- annotation
  rownames(annot.df) <- annotTable@Genes[,"ID"]
  annot.df$ID <- annotTable@Genes[,"ID"]
  ## add add annotation to differential expression dataframe with full gene names
  diff.exp.genes.with.names.annot <- left_join(diff.exp.genes.with.names, 
                                               annot.df, by=c("probe"="ID"))
  cat(sum(diff.exp.genes.with.names.annot[annotation] != ""), "entries for", annotation)
  
  diff.exp.genes.with.names.annot
}

## KEGG
kegg.df <- make.annot.df("KEGG_PATHWAY")  ## SOX5 empty
head(kegg.df)

## REACTOME
reactome <- make.annot.df("REACTOME_PATHWAY") ## SOX5 empty
head(reactome)

## IntAct, lot of entries here!
intact <- make.annot.df("INTACT") ## again SOX5 twice so really 31
intact[intact$probe=="203072_at", "INTACT"]

## MINT
mint <- make.annot.df("MINT") ## SOX5 so 16

## UCSC_TFBS
ucsc.tfbs <- make.annot.df("UCSC_TFBS") ## SOX5 so 38
ucsc.tfbs[ucsc.tfbs$probe=="230441_at", "UCSC_TFBS"]