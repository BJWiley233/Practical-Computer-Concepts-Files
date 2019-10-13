x <- read.csv("~/dots.csv", na.strings = c("NA", "NaN", "..", ""), stringsAsFactors = FALSE)
splitNames = strsplit(names(x), "\\..|\\_")
lastElement <- function(x) {x[length(x)]}
sapply(splitNames, lastElement)
names(x) <- sapply(splitNames, lastElement)
splitNames = strsplit(names(x), [\\..][\\_])


grep("[a-zA-Z]+mean.*|[' ']+mean.*", x[,1])
grep("^[^mean]", x[,1])