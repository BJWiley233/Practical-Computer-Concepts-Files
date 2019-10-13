pollutantmean <- function (directory, pollutant, id=1:332) {
        directory = "~/onedrive/documents/R/specdata"
        
        data <- data.frame()
        for (i in id) {
                if (i <=9) {
                        path <- as.data.frame(read.table(paste(directory,"/00", as.character(i),".csv", sep = ""), sep = ",",
                                   as.is =T, header = T))
                        data <- rbind(data, path)
                }
                else if (i <=99) {
                        path <- as.data.frame(read.table(paste(directory,"/0", as.character(i),".csv", sep = ""), sep = ",", 
                                           as.is =T, header = T))
                        data <- rbind(data, path)
                }
                else if (i <=999) {
                        path <- as.data.frame(read.table(paste(directory,"/", as.character(i),".csv", sep = ""), sep = ",", 
                                           as.is =T, header = T))
                        data <- rbind(data, path)
                }
                else{
                        
                }
        }
        
        return(mean(data[,pollutant], na.rm = TRUE))
}
