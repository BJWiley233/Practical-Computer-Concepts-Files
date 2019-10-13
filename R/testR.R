library("RSQLite")
db<-dbConnect(SQLite(),dbname="Authors.sqlite")
summary(db)
dbSendQuery(conn=db, "DROP TABLE IF EXISTS Authors")
dbGetQuery(conn=db, "CREATE TABLE Authors
            (AuthorID INTEGER PRIMARY KEY, -- Autoincrement 
            AuthorName TEXT,
            AuthorDetails TEXT)")

dbGetQuery(conn=db, "CREATE TABLE Authors(
					 AuthorID INTEGER PRIMARY KEY, -- Autoincrement 
           AuthorName TEXT,
           AuthorDetails TEXT)"
           )

dbWriteTable(conn=db, "Authors", data.frame(AuthorName ='Khaled Hosseini',
                                            AuthorDetails ='Afghan-born American novelist and physician'), 
             append = T,
             row.names = FALSE)
dbReadTable(db, "Authors")
dbGetQuery(conn=db, "SELECT * FROM Authors")
dbListTables(db)
dbListFields(db, "Authors")


library(RCurl)
library(XML)
getURL<-function(pid){
        URL<-paste("https://www.cityofboston.gov/assessing/search/?pid=",pid,sep="")
        return(URL)
}
pid<-"0402236000"
url<-getURL(pid)
browseURL(url)
XML::htmlTreeParse()
webpage<-RCurl::getURL(url, .opts=list(useragent="Mozila 5.0"))
tc<-textConnection(webpage)
webpage<-readLines(tc)
close(tc)
head(webpage,5)
library("httr")
d1 <- GET(url)
head(d1)
update.packages("RCurl")

?read_html
library(rvest)
silly_webpage <- read_html(url)
selector <- "//*[@id='topNavLinks']//a"
header <- silly_webpage %>% html_nodes(xpath = selector) %>% html_text()








selector <- "//*/table[@width='100%'][@cellpadding='0']/tr[3]//td"
id <- silly_webpage %>% html_nodes(xpath = selector) %>% html_text()
selector <- "//*/table[@width='100%'][@cellpadding='0']/tr[9]//td"
owner <- silly_webpage %>% html_nodes(xpath = selector) %>% html_text()

RSQLite::dbSe