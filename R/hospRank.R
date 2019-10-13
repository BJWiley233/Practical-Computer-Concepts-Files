rank <- function(state, outcome, num = "best") {
        outcome1 <- read.csv("~/outcome-of-care-measures.csv", colClasses = "character")
        if (!any(state == outcome1$State)) {
                stop(print("error not a state"))
        }
        else if ((outcome %in% c("heart attack", "heart failure", "pneumonia")) == FALSE) {
                stop(print("error not an outcome"))
                else if (((num %in% c("worst", "best")) || is.numberic(num)) == FALSE)
                        stop(print("error invalid rank"))
        }
        
        outcome2 <- subset(outcome1, state == State) 
        if (outcome == "heart attack") {
                col <-1
        }
        else if (outcome == "heart failure") {
                col <-17
        }
        else {
                col <- 23
        }
        
        
        data[, col] <- as.numeric(data[, col]) 
        data <- na.omit(outcome2[order(outcome2$col),])
        
        if (toupper(num) == "Best"){
                num == 1
        }
        else if (toupper(num) == "Worst") {
                num == nrows(data)
        }
        
        
        return(data[[num,2]])
}