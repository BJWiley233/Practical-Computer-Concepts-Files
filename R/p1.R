proftable <- function(file, lines=10) {
        # require(plyr)
        interval <- as.numeric(strsplit(readLines(file, 1), "=")[[1L]][2L])/1e+06
        profdata <- read.table(file, header=FALSE, sep=" ", comment.char = "",
                               colClasses="character", skip=1, fill=TRUE,
                               na.strings="")
        filelines <- grep("#File", profdata[,1])
        files <- aaply(as.matrix(profdata[filelines,]), 1, function(x) {
                paste(na.omit(x), collapse = " ") })
        profdata <- profdata[-filelines,]
        total.time <- interval*nrow(profdata)
        profdata <- as.matrix(profdata[,ncol(profdata):1])
        profdata <- aaply(profdata, 1, function(x) {
                c(x[(sum(is.na(x))+1):length(x)],
                  x[seq(from=1,by=1,length=sum(is.na(x)))])
        })
        stringtable <- table(apply(profdata, 1, paste, collapse=" "))
        uniquerows <- strsplit(names(stringtable), " ")
        uniquerows <- llply(uniquerows, function(x) replace(x, which(x=="NA"), NA))
        dimnames(stringtable) <- NULL
        stacktable <- ldply(uniquerows, function(x) x)
        stringtable <- stringtable/sum(stringtable)*100
        stacktable <- data.frame(PctTime=stringtable[], stacktable)
        stacktable <- stacktable[order(stringtable, decreasing=TRUE),]
        rownames(stacktable) <- NULL
        stacktable <- head(stacktable, lines)
        na.cols <- which(sapply(stacktable, function(x) all(is.na(x))))
        stacktable <- stacktable[-na.cols]
        parent.cols <- which(sapply(stacktable, function(x) length(unique(x)))==1)
        parent.call <- paste0(paste(stacktable[1,parent.cols], collapse = " > ")," >")
        stacktable <- stacktable[,-parent.cols]
        calls <- aaply(as.matrix(stacktable[2:ncol(stacktable)]), 1, function(x) {
                paste(na.omit(x), collapse= " > ")
        })
        stacktable <- data.frame(PctTime=stacktable$PctTime, Call=calls)
        frac <- sum(stacktable$PctTime)
        attr(stacktable, "total.time") <- total.time
        attr(stacktable, "parent.call") <- parent.call
        attr(stacktable, "files") <- files
        attr(stacktable, "total.pct.time") <- frac
        cat("\n")
        print(stacktable, row.names=FALSE, right=FALSE, digits=3)
        cat("\n")
        cat(paste(files, collapse="\n"))
        cat("\n")
        cat(paste("\nParent Call:", parent.call))
        cat(paste("\n\nTotal Time:", total.time, "seconds\n"))
        cat(paste0("Percent of run time represented: ", format(frac, digits=3)), "%")
        
        invisible(stacktable)
}
