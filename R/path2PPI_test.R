BiocManager::install("Path2PPI", version = "3.8")
browseVignettes("Path2PPI")
library(Path2PPI)
library(stringr)
library(dplyr)
library(tidyverse)
data(ai)
ls()
human.ai.irefindex
str(human.ai.irefindex)
con <- file("yeast_panserina.out","r")
field_line <- readLines(con,n=4)
close(con)





con <- file("yeast_panserina.out", "r")
while(TRUE) {
        line = readLines
        if(grepl('^(# Fields:)', line)) break
}
close(con)


newline <- str_remove(line, '^(# Fields: )')
test_pa2humanBlast <- read.table("human_panserina.out")
test_pa2yeastBlast <- read.table("yeast_panserina.out")
test <- read.table("test.txt")
names(test_pa2humanBlast) <- strsplit(newline, ", ")[[1]]

pa2humanBlast <- separate(data = test_pa2humanBlast, 
                          col = 'query acc.ver', 
                          into = c("tr", "query acc.ver", "name"),
                          sep = "([\\|])")

ppi <- Path2PPI("Autophagy induction", "Podospora anserina", "5145")
ppi <- addReference(ppi, "Homo sapiens", "9606", human.ai.proteins, 
                    human.ai.irefindex, pa2human.ai.homologs)
ppi <- addReference(ppi, "Saccharomyces cerevisiae (S288c)", "559292", 
                    yeast.ai.proteins, yeast.ai.irefindex, 
                    pa2yeast.ai.homologs) 
showReferences(ppi)
interactions <- showReferences(ppi, species="9606", 
                               returnValue="interactions")
head(interactions)
ppi <- predictPPI(ppi,h.range=c(1e-60,1e-20))

set.seed(12) #Set random seed
coordinates <- plot(ppi, return.coordinates=TRUE)
