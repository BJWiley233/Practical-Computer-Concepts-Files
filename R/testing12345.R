library(rvest)

# Number 1
page <- read_html("https://www.yelp.com/search?find_desc=burgers&start=0&l=Boston,MA")

# list the children of the <html> element (the whole page)
html_children(page)

# get the root of the actual html body
root <- html_nodes(page, 'body')
bodyNodes <- html_nodes(page, 'body>*')
length(html_nodes(page, 'body>*'))
idAttsInBody <- html_attr(bodyNodes, 'id')
length(idAttsInBody[!is.na(idAttsInBody)])
unique(html_name(bodyNodes))
for (i in seq_along(bodyNodes)) {
        print(html_name(bodyNodes[i]))
        
}

# Number 2
get_yelp_sr_multiple_page <- function(keyword, pages = c(0.6, 1, 2), loc="Boston, MA") {

        get_data <- function(items){
                r.names <- items %>% 
                        html_nodes(".alternate__373c0__1uacp .link-size--inherit__373c0__2JXk5") %>% 
                        html_text(trim=T)
                
                r.urls <- items %>% 
                        html_nodes(".alternate__373c0__1uacp .link-size--inherit__373c0__2JXk5") %>%
                        html_attr("href")
                
                # could not figure out get missing data for this one for any keywords.
                r.addresses <- items %>% 
                        html_nodes("address") %>% 
                        html_text(trim=T)
                
                # this first r.phones does not work for schools or hospital keyword but works for burgers
                r.phones <- items %>% 
                        html_nodes(".text-align--right__373c0__3fmmn.border-color--default__373c0__2oFDT>.lemon--div__373c0__1mboc.display--inline-block__373c0__2de_K.border-color--default__373c0__2oFDT:not(.u-space-t1)") %>%                             
                        html_text()
                if (length(r.phones) == 0) { # doesn't work either for other key words (ie 'hospitals' and 'schools').
                        r.phones <- items %>% 
                                html_nodes(".display--inline-block__373c0__2de_K") %>%
                                html_text()
                }
                
           
                # code online to set nodes in Df
                #bind_rows(lapply(xml_attrs(r.phones), function(x) data.frame(as.list(x), stringsAsFactors=FALSE)))
                
                #PERFECT
                r.stars <- items %>% 
                        html_nodes(".overflow--hidden__373c0__8Jq2I") %>% 
                        html_attr("aria-label")
              
                r.prices <- items %>%
                        html_nodes(".priceCategory__373c0__3zW0R") %>% 
                        html_text() 
                r.newprices <- sub("[^[$]+", "\\1", r.prices)
                r.newprices[r.newprices == ''] = NA
                
                #PERFECT for burgers not for anything else
                r.reviews <- items %>% html_nodes(".text-color--mid__373c0__3G312.text-align--left__373c0__2pnx_") %>%
                        html_text()
                
                #tibble(
                        #name = r.names,
                        #url = r.urls,
                        #prices = r.newprices
                        # <---- Insert here more variables ------>
                #)
                
                data.frame(
                        r.names,
                        r.urls,
                        r.addresses,
                        #r.phones,
                        #r.stars,
                        r.newprices,
                        #r.reviews,
                        stringsAsFactors=F
                        )
        }

        # Number 3
        for (i in pages) {
                if (i %% 1 == 0 && i > 0) {
                        ####################### Test
                        page30 <- toString((i*30)-30)
                        yelp_url <- 'https://www.yelp.com/search?find_desc=%s&start=%s&l=%s'
                        yelp_url_new <- sprintf(yelp_url, URLencode(keyword), URLencode(page30), URLencode(loc))
                        print(yelp_url_new)
                        yelpsr <- read_html(yelp_url_new)
                        
                        items <- yelpsr %>%
                                html_nodes(".mainContentContainer__373c0__32Mqa")
                        
                        ######################
                        
                        # 3
                        print(paste0("Page: ",i))
                        lapply(items, get_data) %>%
                                bind_rows() %>%
                                print()
                }
                Sys.sleep(.5) #Number 4
        }
        
}
                                     # Number 3        
get_yelp_sr_multiple_page("schools", pages = c(1, 2), loc="Boston, MA")

### test help
keyword = 'schools'
loc = "Boston, MA"
i = 2
