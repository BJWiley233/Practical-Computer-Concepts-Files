complete <- function (directory, id=1:332) {
        directory = "~/onedrive/documents/R/specdata"
        data <- data.frame()
        for (i in id) {
                if (i <=9) {
                        dataCSV <- read.table(paste(directory,"/00", as.character(i),".csv", sep = ""), sep = ",",
                                   as.is =T, header = T)
               
                }
                else if (i <=99) {
                        dataCSV <- read.table(paste(directory,"/0", as.character(i),".csv", sep = ""), sep = ",", 
                                           as.is =T, header = T)
                
                }
                else if (i <=999) {
                        dataCSV <- read.table(paste(directory,"/", as.character(i),".csv", sep = ""), sep = ",", 
                                           as.is =T, header = T)
                
                }
                else{
                        
                }
        
        nobs <- sum(complete.cases(dataCSV))
        data9 <- data.frame(i, nobs)
        data <- rbind(data,data9)
        
        }
        
        return(data)
}
