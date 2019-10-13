getwd()
R.home()
list.files(getwd())
dir(getwd())

library(XML)

xmlfile2 <- xmlTreeParse("pubmed_result.xml")

xmltop2 <- xmlRoot(xmlfile2)
xmlName(xmltop2)
num_articles <- xmlSize(xmltop2)
xmlName(xmltop2[[1]])
xmlName(xmltop2[[4]])
xmlName(xmltop2[[5]])

xmltop2[[1]]
xmlName(xmltop2[[1]][[2]])
xmltop2[[1]][[2]]        

#### doesnt work
url <- "http://www.statistics.life.ku.dk/primer/mydata.xml"
data <- xmlToDataFrame(url)

###
path <- system.file("exampleData", "mtcars.xml", package="XML")
doc <- xmlTreeParse(path, useInternal = TRUE)
root <- xmlRoot(doc)

read.table(text = xpathSApply(root, "//record", xmlValue), 
           col.names = xpathSApply(root, "//variable", xmlValue))
