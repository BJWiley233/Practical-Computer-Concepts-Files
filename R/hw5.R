#1

farmers_market = read.csv("Export.csv", stringsAsFactors = F, na.strings=c("NA","NaN", ""))
#names(farmers_market[,c(3:11)])
farmers_market <- farmers_market[,c(3:11)]
#farmers_market$FB_Old <- farmers_market$Facebook   
#test = c("https://www.facebook.com/pages/12th-Brandywine-Urban-Farm-Community-Garden/253769448091860", "https://www.facebook.com/CommunityFoodAction/")

# for (i in seq_along(test)) {
#     if (grepl("facebook.com", tolower(test[i]))) {
#         if (grepl("facebook.com/pages", tolower(test[i]))) {
#            farmers_market$FacebookNew[i] <- gsub("^.*facebook.com/pages/\\s*|\\s*/.*$", '', test[i])
#         } else {
#             gsub("^.*facebook.com/\\s*|\\s*/.*$", '', test[i])
#             }
#     } else {
#         test[i]
#     }
# }
#fb <- c("http://fb.me/BrewsterHistoricalSocietyFarmersMarket", "https://www.facebook.com/Danville.VT.Farmers.Market/",
#        "https://www.facebook.com/ManhattanGreenmarkets", "https://www.facebook.com/pages/ManhattanGreenmarkets/4444",
#        "//www.fb.com/gggg", "https://www.facebook.com/30aFarmersMarket?ref=h",
#        "https://www.facebook.com/Danville.VT.Farmers.Market", "facebook.com/test")
#gsub(".*[_]([^.]+)[.].*", "\\1", "MA0051_IRF2.xml")

#gsub(".*")

#grepl(".*(facebook.com/)([^?]+)[?].*$", fb, ignore.case = T)
# gsub(".*(facebook.com/)([^?]+)[?].*$", "\\2", fb, ignore.case = T)
# 
# grepl(".*(fb\\.me/)([^.]+)$", fb, ignore.case = T)
# gsub(".*(fb\\.me/)([^.]+)$", "\\2", fb, ignore.case = T)
# gsub(".*(fb\\.me/)", "", fb, ignore.case = T)
# 
# gsub(".*(fb.com/)([^.]+)$", "\\2", fb, ignore.case = T)
# 
# gsub(".*(facebook.com/)([^.]+)$", "\\2", fb, ignore.case = T)
# gsub(".*(facebook.com/)([^/]+)[/]", "\\2", fb, ignore.case = T)
# 
# gsub(".*(facebook.com/)([^/]+)[/]|.*(facebook.com/)", "\\2", fb, ignore.case = T)
# gsub(".*(facebook.com/pages/)([^.]+)[/].*", "\\2", fb, ignore.case = T)
# gsub(".*(facebook.com/)([^?]+)[?].*$", "\\2", fb, ignore.case = T)
# gsub(".*(facebook.com/)([^/]+)[/] | .*(facebook.com/)", "\\2", fb, ignore.case = T)
# grepl(".*(facebook.com/)([^/]+)[/]|.*(facebook.com/)", fb, ignore.case = T)

#########2
for (i in seq_along(farmers_market$Facebook)) {
    if (grepl("facebook.com/", farmers_market$Facebook[i], ignore.case = T)) {
        if (grepl("facebook.com/pages", farmers_market$Facebook[i], ignore.case = T)) {
            farmers_market$FacebookNew[i] <- gsub("^.*facebook.com/pages/\\s*|\\s*/.*$", '', farmers_market$Facebook[i], ignore.case = T) 
        } else if (grepl(".*(facebook.com/)([^.]+)$|.*(facebook.com/)", farmers_market$Facebook[i], ignore.case = T)) {
            if (grepl(".*(facebook.com/)([^?]+)[?].*$", farmers_market$Facebook[i], ignore.case = T)) {
                farmers_market$FacebookNew[i] <- gsub(".*(facebook.com/)([^?]+)[?].*$", "\\2", farmers_market$Facebook[i], ignore.case = T)
            } else {
            farmers_market$FacebookNew[i] <- gsub(".*(facebook.com/)([^/]+)[/]|.*(facebook.com/)", "\\2", farmers_market$Facebook[i], ignore.case = T)
            }
        } 
    } 
    else {
        farmers_market$FacebookNew[i] <- farmers_market$Facebook[i]
    }
}

#https://stackoverflow.com/questions/12297859/remove-all-text-before-colon
# test <- "@sloccfm"
# grepl("@", tolower(test))
# gsub(".*@", '', test)

#farmers_market$Twitt_Old <- farmers_market$Twitter


    
for (i in seq_along(farmers_market$Twitter)) {
    if (grepl("twitter.com/", farmers_market$Twitter[i], ignore.case = T) ||
        grepl("@", farmers_market$Twitter[i], ignore.case = T)) {
        if (grepl("twitter.com/", tolower(farmers_market$Twitter[i]))) {
            farmers_market$TwitterNew[i] <- gsub("^.*twitter.com/\\s*|\\s*/.*$", '', farmers_market$Twitter[i]) 
        } else {
            farmers_market$TwitterNew[i] <- gsub(".*@", '', farmers_market$Twitter[i])
        }
    } else {
        farmers_market$TwitterNew[i] <- farmers_market$Twitter[i]
    }
}

#x <-  "twitter.com/brian"
#gsub('^.*twitter.com/\\s*|\\s*/.*$', '', x)




######3)
# test <- c("WaterColor (Santa Rosa Beach, Florida)", "Louisville/Jefferson County metro government (balance)",
#           "Phoenixville, Pottstown, Coatesville, Parkesburg, West Chester, Kennett Square and Oxford", "Philly")
# 
# 
# grepl("[(,/]", test)
# 
# gsub("[(,/].*", '', test)

# can't fix everything
for (i in seq_along(farmers_market$city)) {
    if (grepl("[(,/]", farmers_market$city[i])){
        farmers_market$NewCity[i] <- gsub("[(,/].*", '', farmers_market$city[i])
    } else {
        farmers_market$NewCity[i] <- farmers_market$city[i]
    } 
}

# test <- c("Corner of Ferry and Metcalf",
#           "102 N. Main St.",
#           "301 DeForest Loop",
#           "West Street and Salt Street",
#           "1221 South Main Street",
#           "4540 Ebert Rd.",
#           "139 North 3rd Avenue",
#           "68 Broad Street Road",
#           "1039 South St",
#           "Bobbrd State rd",
#           "bstreet str",
#           "10 st gangband",
#           "And St",
#           "Yardlet Friends Meeting, 65 N. Main St.",
#           "Zafarano dr and San Ignacio rd")


# grepl("[[:space:]]st\\.", test, ignore.case = T)  
# grepl("[[:space:]]st( |$)", test, ignore.case = T)
# grepl("[[:space:]]street", test, ignore.case = T)
# 
# 
# grepl("[[:space:]]rd\\.", test, ignore.case = T)
# grepl("[[:space:]]rd( |$)", test, ignore.case = T)
# grepl("[[:space:]]road", test, ignore.case = T)
# 
# 
# 
# gsub("[[:space:]]st\\.|[[:space:]]st|[[:space:]]street", ' St', test, ignore.case = T)
# gsub("[[:space:]]rd\\.|[[:space:]]rd|[[:space:]]road", ' Rd', test, ignore.case = T)
# gsub("[[:space:]]dr\\.|[[:space:]]dr|[[:space:]]drive", ' Dr', test, ignore.case = T)
# gsub("[[:space:]]and[[:space:]]", ' & ', test, ignore.case = T)



#farmers_market$old_street <- farmers_market$street
library(dplyr)
farmers_market$newStreet <- gsub("[[:space:]]st\\.|[[:space:]]st|[[:space:]]street", ' St', farmers_market$street, ignore.case = T) %>%
    gsub("[[:space:]]rd\\.|[[:space:]]rd|[[:space:]]road", ' Rd', ., ignore.case = T) %>%
    gsub("[[:space:]]dr\\.|[[:space:]]dr|[[:space:]]drive", ' Dr', ., ignore.case = T) %>%
    gsub("[[:space:]]and[[:space:]]", ' & ', ., ignore.case = T)


#4)
#
farmers_market %>% 
        #select(c("Website", "Facebook", "Twitter", "Youtube", "OtherMedia", "State")) %>%
        group_by(State) %>%
        summarise(Num_Markets = n(),
                  FB_Percent = 100 - 100*sum(is.na(Facebook))/n(), 
                  TW_Percent = 100 - 100*sum(is.na(Twitter))/n(),
                  #fb=sum(is.na(Facebook)),
                  OL_Percent = 100 - 100*sum(is.na(Facebook) & is.na(Twitter))/n(),
                  NO_OL_Percent = 100 - 100*sum(is.na(Facebook) & is.na(Twitter) & is.na(Website) & is.na(Youtube) & is.na(OtherMedia))/n()
                  )


cols <- c("Website", "Facebook", "Twitter", "Youtube", "OtherMedia")

# this here     .[cols]   means this here  farmers_market[cols] 
farmers_market %>% 
    mutate(all_NA = rowSums(is.na(.[cols])) == length(cols)) %>%
    group_by(State) %>%
    summarise(Num_Markets = n(),
              FB_Percent = 100 - 100*sum(is.na(Facebook))/n(), 
              TW_Percent = 100 - 100*sum(is.na(Twitter))/n(),
              OL_Percent = 100 - 100*sum(is.na(Facebook) & is.na(Twitter))/n(),
              NO_OL_Percent = 100 - 100*sum(all_NA)/n())
