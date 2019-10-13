corr <- function (directory, threshold=0) {
        directory = "~/onedrive/documents/R/specdata"
        corr_vect <- NULL
        zero <- NULL
        for (i in 1:332) {
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
             
                data <- dataCSV[complete.cases(dataCSV),]
                
                if (nrow(data) == 0){
                        print(i)
                }
                else if (nrow(data) > threshold) {
                        corr_vect <- c(corr_vect, cor(data[,"sulfate"], data[,"nitrate"]))
                }
               
        }
        
        
      
        
}
x <- corr(directory,0)
sapply(x, corr)