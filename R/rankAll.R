rankAll <- function(outcome, num = "best") {
        outcome1 <- read.csv("~/outcome-of-care-measures.csv", colClasses = "character")
        if ((outcome %in% c("heart attack", "heart failure", "pneumonia")) == FALSE) {
                stop(print("error not an outcome"))
        }
        else if (((num %in% c("worst", "best")) || is.numeric(num)) == FALSE) {
                stop(print("error invalid rank"))
        }
        
        
        if (outcome == "heart attack") {
                col <- 11
        }
        else if (outcome == "heart failure") {
                col <- 17
        }
        else {
                col <- 23
        }
        
        outcome1[ ,col] <- as.numeric(outcome1[ ,col])
        outcome2 <- outcome1[!is.na(outcome1[ ,col]), ]
        split <- split(outcome1, outcome1$State)
        
        answer <- sapply(split, function (x, num) {
                x <- x[order(x[ ,col], x$Hospital.Name), ]
                if (toupper(num) == "BEST"){
                        num <- x$Hospital.Name[1]
                }
                else if (toupper(num) == "WORST") {
                        num <- x$Hospital.Name[nrow(x)]
                }       
                else {
                        num <- x$Hospital.Name[num]
                }
        }, num)
        
    
        return(data.frame(hospital = unlist(answer)))
}