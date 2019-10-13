## install.packages("XLConnect")
## install.packages("formattable")
 install.packages("plotly")
library(XLConnect)
library(formattable)
library(plotly)

demoExcelFile <- "~/Test.xlsx"
wb <- loadWorkbook(demoExcelFile)
data <- readWorksheet(wb, sheet = "sheet1",startRow = 1, startCol = 1, check.names = FALSE)
names(data)[2:31] <- format(as.Date(names(data)[2:31], format = "%m/%d/%Y"))


for (i in 2:31) {
        data[,i] <- percent(data[,i], digits = 1, format = "f")   
}
for (i in 2:31){
        nam <- paste(names(data)[i]) 
        assign(nam, data[,c(1,i)])
}
dfList <- list()  ## create empty list
for (j in 1:30 ) {
        nam <- paste(names(data)[j+1]) 
        ##assign(nam, data[,c(1,i)])
        dfList[[j]] <- data.frame(assign(nam, data[,c(1,j+1)]))  ## create and add new data frame
                }



w <- plot_ly()

f <- list(
        ##family = "Courier New, monospace",
        size = 14,
        color = "black",
        face = "bold"
)
x <- list(
        title = "Day # Leads Baked",
        titlefont = f
)
y <- list(
        title = "L2O %",
        titlefont = f,
        tickformat = ".1%",
        ticklen = 1
)

m <- list(
        l = 80,
        r = 0,
        b = 50,
        t = 30,
        pad = 4
)

t = 2
for(line in dfList) {
        
        w <- add_trace(w, x=line[[1]], y=line[[2]], name = paste(names(data)[t]), mode = 'lines',
                                        evaluate = TRUE)
        t = t+1
}
w <- w %>% layout(title = "L2O Baking % Whoop Whoop!!", titlefont=list(face = "bold-italic"), xaxis = x, yaxis = y, margin = m)
w

Sys.setenv("plotly_username"="bjwiley23")
Sys.setenv("plotly_api_key"="otNz3C6GxWfpdcUzLks4")

plotly_POST(w, filename = "r-docs/test-baking")

update.packages(repos="https://mran.revolutionanalytics.com/snapshot/2017-02-16")


