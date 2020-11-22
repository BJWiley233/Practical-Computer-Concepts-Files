library(RMySQL)
library(DBI)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(dqshiny)
library(DT)
library(shinyjs)

loadData <- function(query) {
  db <- RMySQL::dbConnect(RMySQL::MySQL(),
                          db = "protTest",
                          username = "root",
                          password = "**",
                          host = "127.0.0.1")
  dat <- dbGetQuery(db, query)
  dbDisconnect(db)
  dat
}
protein.families.query <- sprintf("SELECT DISTINCT headProteinFamily 
                                   FROM proteinsUniprot")
protein.families <- loadData(protein.families.query)
organisms.query <- sprintf("SELECT DISTINCT organism 
                            FROM proteinsUniprot")
organism <- loadData(organisms.query)

dat.query <- sprintf("SELECT headProteinFamily, organism, geneNamePreferred, uniProtID
                      FROM proteinsUniprot")
dat <- loadData(dat.query)

library(neo4r)
library(magrittr)
library(httr)
library(igraph)
library(dplyr)
library(purrr)
library(rlist)

con <- neo4j_api$new(url = "http://localhost:7474", 
                     db = "protTest", user = "neo4j", 
                     password = "**", isV4 = TRUE)
status_code(GET("http://localhost:7474"))



getGraph <- function(UP.id, direction, length, limit=10) {
  
  if (direction=="down") {
    direct.str <- sprintf("-[:INTERACTION*0..%d]->", length)
  } else if (direction=="up") {
    direct.str <- sprintf("<-[:INTERACTION*0..%d]-", length)
  } else {
    direct.str <- sprintf("<-[:INTERACTION*0..%d]->", length)
  }
  
  G <- sprintf(
    "MATCH p = (n:Protein {uniprotID:'%s'})%s() 
      WITH *, relationships(p) AS rs
      UNWIND rs AS relType
      RETURN 
      	startNode(last(rs)).name AS Protein1, 
          relType['name'] AS `Interaction type`,
      	endNode(last(rs)).name AS Protein2, 
          rs AS `Relationship details`, p AS Path
      LIMIT %d",  UP.id, direct.str, limit
  ) %>%
    call_neo4j(con, type="graph")
  
  if (length(G)==0) {
    return("No results in graph. Try another protein.")
  } else{
    #G2 <- G
    G$nodes$properties <- lapply(G$nodes$properties, 
                                 function(x) list.remove(x, c("altProtNames", "altGeneNames")))

    G$nodes <- G$nodes %>%
      unnest_nodes(what = "properties")
    
    G$relationships <- G$relationships %>%
      unnest_relationships() %>%
      select(startNode, endNode, type, everything())
    
    graph_object <- igraph::graph_from_data_frame(
      d = G$relationships, 
      directed = TRUE, 
      vertices = G$nodes
    )
    
    plot(graph_object, edge.label=G$relationships$name,
         vertex.label=G$nodes$name, edge.label.cex=0.8,
         vertex.label.cex=0.7) 
  }

}


#G <- getGraph('Q05655', direction="down", length=1, limit=10)
#G <- getGraph("88888", direction="down", length=1, limit=10)

ui <- uiOutput("uiStub")

server <- function(input, output, session) {
  cat("Session started.\n")                               # this prints when a session starts
  onSessionEnded(function() {cat("Session ended.\n\n")})  # this prints when a session ends
  
  output$uiStub <- renderUI(
    fluidPage(
      theme = shinytheme("slate"),
      fluidRow(column(12, h1("Protein Substrates"))),
      fluidRow(column(12,
                      HTML("<h3><a href='?RoadMap'>RoadMap</a> | ",
                           "<a href='?Search'>Search</a> |",
                           "<a href='?Forum'>Forum</a> |",
                           "<a href='?page3'>Nothing</a>",
                           "</h3>"))
      ),
      uiOutput("pageStub")
    )
  )
  
  validFiles = c("RoadMap.R", "Search.R", "Graph.R", "Forum.R")
  
  fname = isolate(session$clientData$url_search)
  if (nchar(fname)==0) { fname = "?RoadMap"}
  fname = paste0(substr(fname, 2, nchar(fname)), ".R") # remove leading "?", add ".R"
  
  cat(paste0("Session filename: ", fname, ".\n"))      # print the URL for this session
      
  if(!fname %in% validFiles){                          # is that one of our files?
    output$pageStub <- renderUI(tagList(              # 404 if no file with that name
      fluidRow(
        column(5,
               HTML("<h2>404 Not Found Error:</h2><p>That URL doesn't exist. Use the",
                    "menu above to navigate to the page you were looking for.</p>")
        )
      )
    ))
    return()    # to prevent a "file not found" error on the next line after a 404 error
  }
  source(fname, local=TRUE)                            # load and run server code for this page
}

# Run the application
shinyApp(ui = ui, server = server)

