rank <- function(state, outcome, num = "best") {
        outcome1 <- read.csv("~/outcome-of-care-measures.csv", colClasses = "character")
        if (!any(state == outcome1$State)) {
                stop(print("error not a state"))
        }
        else if ((outcome %in% c("heart attack", "heart failure", "pneumonia")) == FALSE) {
                stop(print("error not an outcome"))
        }
        else if (((num %in% c("worst", "best")) || is.numeric(num)) == FALSE) {
                stop(print("error invalid rank"))
        }
        
        
        outcome2 <- subset(outcome1, state == State) 
        if (outcome == "heart attack") {
                col <- 11
        }
        else if (outcome == "heart failure") {
                col <- 17
        }
        else {
                col <- 23
        }
        
        
        outcome2[ ,col] <- as.numeric(outcome2[ ,col])
        data <- na.omit(outcome2[order(outcome2[ ,col],outcome2[,2]), ])
      
        
        if (toupper(num) == "BEST"){
                num <- 1
        }
        else if (toupper(num) == "WORST") {
                num <- nrow(data)
        }
       
        
        return(data[num,2])
}