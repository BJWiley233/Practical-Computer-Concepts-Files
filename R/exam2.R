nyc_collisions <- read.csv("NYPD_Motor_Vehicle_Collisions.csv", header = T, stringsAsFactors = F)
nyc_collisions$DATE <- as.Date(nyc_collisions$DATE, format = '%m/%d/%Y')
sapply(nyc_collisions, class)
library(chron)
library(lubridate)
nyc_collisions$TIME <- times(paste(nyc_collisions$TIME, ":00"))
lubridate::month(head(nyc_collisions$DATE))
lubridate::day(head(nyc_collisions$DATE))
birthday_coll <- subset(nyc_collisions, month(DATE)==7 & day(DATE)==21)
birthday_coll$DATE

library(dplyr)


crashes_per_hour <- birthday_coll %>%
                        group_by(hour=chron::hours(TIME)) %>%
                        summarise(count=n())

# https://stackoverflow.com/questions/9946630/colour-points-in-a-plot-differently-depending-on-a-vector-of-values
cols <- colorRampPalette(c("yellow", "red"))
color_grad <- cols(23)[as.numeric(cut(crashes_per_hour$count, breaks = 23))]
# https://www.r-graph-gallery.com/213-rotating-x-axis-labels-on-barplot/
b <- with(crashes_per_hour, barplot(count, col = color_grad, 
                                    main = "July-21", xaxt="n", 
                                    las=1, xlab = "hour of day"))
text(b[,1], -4.0, srt = 60, adj = 1, xpd = TRUE, labels = crashes_per_hour$hour)

# search in google "geom_bar show all ticks"
ggplot(crashes_per_hour, aes(x=hour, y = count, fill = count)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "green", high = "red") +
    scale_x_continuous(breaks=0:23, labels = crashes_per_hour$hour) +
    ggtitle("July-21 by Hour")

manhattan <- subset(nyc_collisions, BOROUGH=="MANHATTAN")

manhattan_per_hour_percent <- manhattan %>%
                                group_by(hour=chron::hours(TIME)) %>%
                                summarise(Count=n()) %>%
                                mutate(Percent = Count/sum(Count))
#print(manhattan_per_hour_percent, n=24)
ggplot(manhattan_per_hour_percent, aes(x=hour, y = Percent, fill = Percent)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "green", high = "darkblue") +
    scale_x_continuous(breaks=0:23, labels = crashes_per_hour$hour) +
    # https://stackoverflow.com/questions/40675778/center-plot-title-in-ggplot2
    theme(plot.title = element_text(hjust = 0.5)) +
    ggtitle("Manhattan")


crashes_per_minute <- birthday_coll %>%
    group_by(minute=chron::minutes(TIME)) %>%
    summarise(count=n())
print(crashes_per_minute, n=60)
# search in google "rotate xaxis ticks in ggplot2"
ggplot(crashes_per_minute, aes(x=minute, y = count, fill = count)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "lightgrey", high = "black") +
    scale_x_continuous(breaks=0:59, labels = crashes_per_minute$minute) +
    theme(axis.text.x=element_text(angle = 45, hjust = 0),
          plot.title = element_text(hjust = 0.5)) +
    ggtitle("July-21 by Minute")
# or just do basic
ggplot(crashes_per_minute, aes(x=minute, y = count, fill = count)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "lightgrey", high = "black") +
    theme(plot.title = element_text(hjust = 0.5)) +
    ggtitle("July-21 by Minute")


#2
codes <- nyc_collisions %>%
    group_by(ZIP.CODE) %>%
    summarize(count=n()) %>%
    arrange(desc(-count))

print(codes[codes$count > 250,])

code_10000 <- subset(nyc_collisions, ZIP.CODE==10000)
code_10000_months <-  code_10000 %>%
                        group_by(month=month(DATE)) %>%
                        summarise(count=n())

ggplot(code_10000_months, aes(x=month, y = count, fill = count)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "lightpink", high = "darkred") +
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_x_continuous(breaks=1:12, labels = code_10000_months$month) +
    ggtitle("Zip-Code 10000")

# https://rpubs.com/jhofman/nycmaps
library(rgdal)
library(httr)
library(tidyr)
library(broom)
r <- GET('http://data.beta.nyc//dataset/0ff93d2d-90ba-457c-9f7e-39e47bf2ac5f/resource/35dd04fb-81b3-479b-a074-a27a37888ce7/download/d085e2f8d0b54d4590b1e7d1f35594c1pediacitiesnycneighborhoods.geojson')
nyc_neighborhoods <- readOGR(content(r,'text'), 'OGRGeoJSON', verbose = F)
nyc_neighborhoods_df <- tidy(nyc_neighborhoods)

ggplot() + 
    geom_polygon(data=nyc_neighborhoods_df, aes(x=long, y=lat, group=group)) +
    geom_point(aes(x=code_10000$LONGITUDE, y=code_10000$LATITUDE), col = "red") +
    # https://ggplot2.tidyverse.org/reference/coord_cartesian.html
    coord_cartesian(xlim = mean(code_10001[code_10000$LONGITUDE!=0,]$LONGITUDE, na.rm=T) + c(1,-1)*.05, 
                    ylim = mean(code_10001[code_10000$LATITUDE!=0,]$LATITUDE, na.rm=T)  + c(1,-1)*.05,
                    expand = TRUE,
                    default = FALSE, clip = "on")


long_lat <- data.frame(long=code_10000$LONGITUDE,lat=code_10000$LATITUDE)
long_lat <- na.omit(long_lat)
long_lat_spdf <- long_lat
coordinates(long_lat_spdf) <- ~long + lat
proj4string(long_lat_spdf) <- proj4string(nyc_neighborhoods)
matches <- over(long_lat_spdf, nyc_neighborhoods)
long_lat <- cbind(long_lat, matches)
head(long_lat)

leaflet(nyc_neighborhoods) %>%
    addTiles() %>%
    addPolygons(popup = ~neighborhood) %>% 
    addMarkers(~long, ~lat, popup = ~neighborhood, data = long_lat) %>%
    addProviderTiles("CartoDB.Positron") %>%
    setView(mean(code_10001[code_10000$LONGITUDE!=0,]$LONGITUDE, na.rm=T), 
            mean(code_10001[code_10000$LATITUDE!=0,]$LATITUDE, na.rm=T), zoom = 11)

plot(code_10000$LONGITUDE, code_10000$LATITUDE, main = "Zip 1000")


#3
body_fat <- read.csv("Bodyfat.csv")
body_fat.test <- glm(bodyfat ~ ., data = body_fat)
sort(summary(body_fat.test)$coef[2:15,4])

pairs(body_fat)

for (i in c(1,seq(from=3, to =15))) {
    lm(body_fat$bodyfat ~ body_fat[, i])$coef[1]
    lm(body_fat$bodyfat ~ body_fat[, i])$coef[2]
}
    
par(mfrow = c(3, 5))
for (i in c(1,seq(from=3, to =15))) {
    print(i)
    plot(body_fat[, i], body_fat$bodyfat, xlab = colnames(body_fat)[i])
    abline(lm(body_fat$bodyfat ~ body_fat[, i])$coef[1],
           lm(body_fat$bodyfat ~ body_fat[, i])$coef[2], col = "red", lw=2)
}

summary(body_fat.test)$coef[2:15,1]

test <- "6/14/2018"

gsub("^([^/]*/[^/]*)/.*$", "\\1", head(nyc_collisions$DATE))

time_test <- "18:05"
gsub("^*:$", "\\1", time_test)
strtoi(sub(".*:","",time_test))
