myapp = oauth_app("twitter",
                  key="2ik9XH7MaGnhBXSnugoY0h9tj",secret="kYLTVI8xHpa3tGQlvDy9Jh5NPJQwLSNbjLDTVBxDcSAo5mtH2g")
sig = sign_oauth1.0(myapp,
                    token = "1669006962-BOESLroGZdwl6F1deKbsOHWt2WuzEBCJ1QyBygp",
                    token_secret = "0y7uQy3Jfw4aQRZwTN6gMQsFwLfIpayhNHmz0vsWoqpRN")
homeTL = GET("https://api.twitter.com/1.1/statuses/home_timeline.json", sig)
json1 = content(homeTL)

json2 = jsonlite::fromJSON(toJSON(json1))


## https://github.com/r-lib/httr/blob/master/demo/oauth2-github.r
library(httr)
oauth_endpoints("github")
myapp <- oauth_app("github",
                   key = "91ea2cacc3e6de72dfd3",
                   secret = "f1711475615fc0c2cfe26081302c4c11b11a7427")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

gtoken <- config(token = github_token)
req <- GET("https://api.github.com/users/jtleek/repos", gtoken)
stop_for_status(req)
json3 <- content(req)
json4 = jsonlite::fromJSON(toJSON(json3))
json5 <- as.data.frame(json4)
answer <- json5[which(json5$name == "datasharing"), ]

x <- read_fwf(
        file="http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for",   
        skip=4,
        fwf_widths(c(13, 7, 3, 9, 4, 9, 4, 9, 4)))

x <- readLines(con=url("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"))

# Skip 4 lines
x <- x[-(1:4)]

mydata2 <- data.frame(var1 = substr(x,2,10),
                     var2 = substr(x, 16,19),
                  
                     var3 = substr(x, 20, 23),
                     var4 = substr(x, 29, 32)  # and so on and so on
)
?substr

df <- read.fwf(
        file=url("http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"),
        widths=c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4),
        skip=4
)

set.seed(13435)
X <- data.frame("var1"=sample(1:5),"var2"=sample(6:10),"var3"=sample(11:15))
X <- X[sample(1:5),]; X$var2[c(1,3)] = NA
X
?order
X[,order(-X[4,])] ##arrange columns by rows
X[order(-X$var1),] ##arrange rows by columns
##same as
arrange(X,desc(var1))