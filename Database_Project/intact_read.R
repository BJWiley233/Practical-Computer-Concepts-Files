library(stringr)
library(qdapRegex)

intact <- read.table("/home/coyote/JHU_Fall_2020/Biological_DBs/Project/data/intact_cut_direction.txt", 
                   header = T, sep = "\t", na.strings = "-", quote = "\"",
                   comment.char = "")
intact$Alias.es..interactor.B[6]
intact_copy = intact
colnames(intact_copy)

intact_copy$X.ID.s..interactor.A <- gsub(".*:", "", intact_copy$X.ID.s..interactor.A)
intact_copy$X.ID.s..interactor.A <- ifelse(grepl("EBI-[0-9]+", intact_copy$X.ID.s..interactor.A), 
       intact_copy$X.ID.s..interactor.A, gsub("-.*", "", intact_copy$X.ID.s..interactor.A))

intact_copy$ID.s..interactor.B <- gsub(".*:", "", intact_copy$ID.s..interactor.B)
intact_copy$ID.s..interactor.B <- ifelse(grepl("EBI-[0-9]+", intact_copy$ID.s..interactor.B),
                                       intact_copy$ID.s..interactor.B, gsub("-.*", "", intact_copy$ID.s..interactor.B))

gene.name.prefered <- function(x) {
  vector <- str_split(x, "\\|")[[1]]
  gnp <- vector[grepl("\\(gene name\\)", vector)][1]
  ## CHEBI molecule
  if(is.na(gnp)) {
    gnp <- vector[grepl("\\(display_short\\)", vector)][1]
    gnp <- toupper(str_match(gnp,"psi-mi:\\s*(.*?)\\s*\\(display_short\\)")[,2])
  } else {
  gnp <- toupper(str_match(gnp,"uniprotkb:\\s*(.*?)\\s*\\(gene name\\)")[,2])
  }
  return(gnp)
}

alt.names <- function(x) {
  vector <- str_split(x, "\\|")[[1]]
  altNames <- vector[grepl("\\(gene name synonym\\)", vector)]
  altNames <- paste(unlist(qdapRegex::ex_between(altNames, "uniprotkb:", "(gene name synonym)")),
        collapse = "|")
  ## CHEBI molecule
  if(altNames=="") {
    altNames <- vector[grepl("\\(synonym\\)", vector)]
    altNames <- paste(unlist(qdapRegex::ex_between(altNames, ":", "(synonym)")),
                      collapse = "|")
  }
  return(ifelse(altNames=="", NA, altNames))
}

intact_copy$geneNamePreferredA <- unlist(lapply(intact_copy$Alias.es..interactor.A, gene.name.prefered))
## if less than 8 chars then geneNamesAlternative in UniProt table, else alternateNames in UniProt table
intact_copy$altNamesA <- unlist(lapply(intact_copy$Alias.es..interactor.A, alt.names))


intact_copy$geneNamePreferredB <- unlist(lapply(intact_copy$Alias.es..interactor.B, gene.name.prefered))
## if less than 8 chars then geneNamesAlternative in UniProt table, else alternateNames in UniProt table
intact_copy$altNamesB <- unlist(lapply(intact_copy$Alias.es..interactor.B, alt.names))

intact_copy$detectionMethod <- unlist(ex_between(intact_copy$Interaction.detection.method.s., "(", ")"))

intact_copy$pubmedID <- gsub("\\|.*", "", intact_copy$Publication.Identifier.s.)

get.organism <- function(x) {
  organism <- ifelse(is.na(ex_between(x, "(", "(")[[1]][1]), 
                     ex_between(x, "(", ")"), 
                     ex_between(x, "(", "(")[[1]][1])
  return(organism)
}

intact_copy$organism.dataA <- gsub(".*\\|", "", intact_copy$Taxid.interactor.A)
intact_copy$taxidA <- unlist(ex_between(intact_copy$organism.dataA, "taxid:", "("))
intact_copy$organismA <- unlist(lapply(intact_copy$organism.dataA, get.organism))

intact_copy$organism.dataB <- gsub(".*\\|", "", intact_copy$Taxid.interactor.B)
intact_copy$taxidB <- unlist(ex_between(intact_copy$organism.dataB, "taxid:", "("))
intact_copy$organismB <- unlist(lapply(intact_copy$organism.dataB, get.organism))

intact_copy$interactionType <- unlist(ex_between(intact_copy$Interaction.type.s., "(", ")"))
intact_copy$sourceDB <- unlist(ex_between(intact_copy$Source.database.s., "(", ")"))
intact_copy$interactionID <- gsub("\\|.*", "", intact_copy$Interaction.identifier.s.)
intact_copy$interactionID <- gsub("intact:", "", intact_copy$interactionID)

intact_copy$biologicalRoleA <- unlist(ex_between(intact_copy$Biological.role.s..interactor.A, "(", ")"))
intact_copy$biologicalRoleB <- unlist(ex_between(intact_copy$Biological.role.s..interactor.B, "(", ")"))

colnames(intact_copy)
intact_copy2 <- intact_copy[,c("X.ID.s..interactor.A","ID.s..interactor.B","geneNamePreferredA",
                               "geneNamePreferredB","altNamesA","altNamesB","taxidA","taxidB",
                               "organismA","organismB","detectionMethod","interactionType",
                               "interactionID","biologicalRoleA","biologicalRoleB","pubmedID","sourceDB")]


intact_copy2$isNegative <- NA
intact_copy2[,"direction"] <- ""

## only call negative if there in an inhibitor
## A and B can both be inhibitor but neo4j is directional so 
## instead making 2 relationships just using A inhibits B
## Future work would be to do more analysis on these biological roles 
## in IntAct
## https://www.ebi.ac.uk/ols/ontologies/mi/terms?iri=http%3A%2F%2Fpurl.obolibrary.org%2Fobo%2FMI_0500&viewMode=All&siblings=true
for (i in 1:nrow(intact_copy2)) {
  if (is.na(intact_copy2[i,"biologicalRoleB"])) {
    intact_copy2[i,"direction"]="A->A"
  } else if (intact_copy2[i,"biologicalRoleA"]=="inhibitor") {
    intact_copy2[i,"isNegative"]=T
    intact_copy2[i,"direction"]="A->B"
  } else if (intact_copy2[i,"biologicalRoleB"]=="inhibitor") {
    intact_copy2[i,"isNegative"]=T
    intact_copy2[i,"direction"]="B->A"
  } else if (grepl("target", intact_copy2[i,"biologicalRoleA"])) {
    intact_copy2[i,"isNegative"]=F
    intact_copy2[i,"direction"]="B->A"
  } else if (grepl("target", intact_copy2[i,"biologicalRoleB"])) {
    intact_copy2[i,"isNegative"]=F
    intact_copy2[i,"direction"]="A->B"
  } else if (grepl("acceptor", intact_copy2[i,"biologicalRoleA"])) {
    intact_copy2[i,"isNegative"]=F
    intact_copy2[i,"direction"]="B->A"
  } else if (grepl("acceptor", intact_copy2[i,"biologicalRoleB"])) {
    intact_copy2[i,"isNegative"]=F
    intact_copy2[i,"direction"]="A->B"
  } else {
    intact_copy2[i,"direction"]="A->B"
  }
}

colnames(intact_copy2)
write.table(intact_copy2, "/home/coyote/JHU_Fall_2020/Biological_DBs/Project/data/intact_cleaned_R.txt", 
            row.names = F, sep="\t", quote=F)
intact_copy2$altNamesA
# unique(intact_copy[,c("biologicalRoleA","biologicalRoleB")])
# intact_copy[318,]
# intact_copy[318:319, c(16,18:20,22:32)]
# unique(intact_copy$biologicalRoleB)
# library(dplyr)
# 
# intact_copy %>%
#   select(biologicalRoleA, biologicalRoleB) %>%
#   group_by(biologicalRoleA, biologicalRoleB) %>%
#   tally() %>%
#   arrange(desc(n)) %>%
#   print(n=25)



