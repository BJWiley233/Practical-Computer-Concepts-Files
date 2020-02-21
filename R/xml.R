library("XML")

xmlfile <- xmlTreeParse("books.xml",useInternalNodes = TRUE)
# the xml file is now saved as an object you can easily work with in R:
xmlfile <- xmlTreeParse("pubmed_result.xml",useInternalNodes = TRUE)
xmlParse("pubmed_result.xml",useInternalNodes = TRUE)
# Use the xmlRoot-function to access the top node
xmltop <- xmlRoot(xmlfile)

# have a look at the XML-code of the first subnodes:
num_books <- xmlSize(xmltop)
xmltop[1]
xmltop[[1]]
# number of element nodes
num_elements <- xmlSize(xmltop[[1]])
xmltop[[2]]
xpathSApply(xmltop, "/book", xmlValue)
xmltop[[1]][[1]]
xmltop[[1]][[2]]
xmltop[[1]][[3]] %>% xmlValue

# extract the tag name of an XMLNode object
xmlName(xmltop)
xmlName(xmltop[[1]])
xmlName(xmltop[[2]])

lib <- xmlChildren(xmltop)
# these base R functions work by walking the tree structure
names(xmltop)
names(xmltop[[1]])

# extract all Values associated with the first node
xmlValue(xmltop[[1]])

xmlValue(xmltop[[1]][[2]], recursive = FALSE)

xmlSApply(xmltop,xmlValue) #row per book values concatenated

xmlApply(xmltop[[1]],xmlValue) # lists

xmlApply(xmltop[[1]],function(x) {xmlValue(x)} )

xmlApply(xmltop,function(x) {xmlValue(x)} ) #value per book

dd <- unlist(xmlSApply(xmltop,function(x) {xmlValue(x)} ))


# initialize the space for the vectors
lib_g <- matrix(data = NA, nrow=num_books, ncol =num_elements)
for (i in seq_along(1:num_books)) {
        v <- vector(mode="character", length=num_elements)
        lib_g[i,] <- v
}
for (i in seq_along(1:num_books)) {
        hold <- unlist(xmlApply(xmltop[[i]],xmlValue))
        print(hold)
        lib_g[i,] <- hold
}
# apply xmlSApply to top and every child node of xmltop
#sapply simplifies the structure of the return value to an array
lib_list <- xmlSApply(xmltop,function(x) xmlSApply(x, xmlValue))
lib_list
# transpose the array
t(lib_list)
book_df <- as.data.frame(t(lib_list))
# this has duplicate row names so
#print(book_df) will generate an error
# so remove the row names
rownames(book_df) <- c()
print(book_df)

# or you can use a tibble which will always remove
# rownames
book_tibble <- as_data_frame(t(lib_list))

# is there a simpler solution?
unlist(xmlApply(xmltop[[1]],xmlValue))
unlist(xmlApply(xmltop[[2]],xmlValue))

unlist(xmlApply(xmltop[[1]],xmlAttrs))

# specify an XPATH of the nodes you want
italian <- getNodeSet(xmltop,
                      '/bookstore/book/title[@lang="it"]')
xmlSApply(italian,xmlValue)

english <- getNodeSet(xmltop,
                      '/bookstore/book/title[@lang="en"]')
xmlSApply(english,xmlValue)

# not what you want to use
xmlApply(xmltop,function(x) {xmlValue(x)} )

xmlApply(xmltop,function(x) {xmlValue(x)} )
