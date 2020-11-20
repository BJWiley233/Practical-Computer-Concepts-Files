data <- read.csv("~/Downloads/gene_attribute_matrix.txt",
                 header=T, sep='\t', stringsAsFactors = F)

data2 <- data[-1, -2]
data3 <- data2
rownames(data3) <- data3$X.
data3 <- data3[, -1]

data4 <- data3
data4[2:dim(data3)[2]] <- sapply(data4[2:dim(data3)[2]], as.numeric)

# THE ROWS ARE THE Genes!!!!!!!!!!!!!!!!!!!!!!!
# THE COLUMNS ARE THE TFs
# REMEMBER THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
"BRCA1" %in% row.names(data4)
ncol(data4["BRCA1", ])
data4["BRCA1", data4["BRCA1", ]==1]
length(data4["BRCA1", data4["BRCA1", ]==1])

