best <- function(state, outcome) {
        outcome1 <- read.csv("~/outcome-of-care-measures.csv", colClasses = "character")
        if (!any(state == outcome1$State)) {
                stop(print("error not a state"))
        }
        else if ((outcome %in% c("heart attack", "heart failure", "pneumonia")) == FALSE) {
                stop(print("error not an outcome"))
        }

        outcome2 <- subset(outcome1, state == State) 
        if (outcome == "heart attack") {
                col <-11
        }
        else if (outcome == "heart failure") {
                col <-17
        }
        else {
                col <- 23
        }
        
        minRate <- which(as.numeric(outcome2[, col]) == min(as.numeric(outcome2[,col]), na.rm = TRUE))
        hospitals <- outcome2[minRate, 2]
        hospitals <- sort(hospitals, decreasing = TRUE)
        
        return(hospitals)
}

