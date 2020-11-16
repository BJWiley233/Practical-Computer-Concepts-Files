library(RMySQL)
library(DBI)
library(shiny)
library(shinythemes)
library(shinyWidgets)
library(dqshiny)


loadData <- function(query) {
  db <- RMySQL::dbConnect(RMySQL::MySQL(),
                          db = "protTest",
                          username = "root",
                          password = "**",
                          host = "127.0.0.1")
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}
protein.families.query <- sprintf("SELECT DISTINCT headProteinFamily 
                                   FROM proteinsUniprot")
protein.families <- loadData(protein.families.query)
organisms.query <- sprintf("SELECT DISTINCT organism 
                            FROM proteinsUniprot")
organism <- loadData(organisms.query)

data.query <- sprintf("SELECT headProteinFamily, organism, geneNamePreferred, uniProtID
                       FROM proteinsUniprot")
data <- loadData(data.query)

# gene.name.fam.query <- function(family) {
#     query <- sprintf("SELECT DISTINCT geneNamePreferred
#                       FROM proteinsUniprot
#                       WHERE  headProteinFamily = '%s'", family)
# }
# q <- gene.name.fam.query("kinase")
# loadData(q)

ui <- fluidPage(theme = shinytheme("slate"),
  navbarPage(
    "Protein Substrates",
    
    tabPanel(title = "Graph",
             h1(strong("Get neo4j Substrate Graph")), hr(),
             h4("Filters"), column(8), h6("\t\t\tFor substrates direction=down & length=1"), hr(),
             fluidRow(column(4, pickerInput("headProteinFamily", "Protein Family:",
                                            choices = protein.families$headProteinFamily,
                                            #selected = protein.families$headProteinFamily,
                                            selected = "kinase",
                                            multiple = TRUE,
                                            options = list(`actions-box` = TRUE))),
                      #column(4, uiOutput("geneName_choice")),
                      column(3, autocomplete_input("geneNamePreferred", "Gene Name: (type to choose IDs)", 
                                                   options = data$geneNamePreferred,
                                                   create = T)),
                      column(1),
                      column(2, selectInput("direction", "Path Direction", 
                                            choices = c("down", "up"), selected = "down")),
                      column(2, textOutput("text"))),
            
             fluidRow(column(4, pickerInput("proteinOrganism", "Organism:",
                                            choices = organism$organism,
                                            selected = organism$organism,
                                            multiple = TRUE,
                                            options = list(`actions-box` = TRUE))),
                      column(3, autocomplete_input("uniProtID", "UniProt ID:",
                                                   options = data$uniProtID)),
                      column(1),
                      column(2, selectInput("length", "Path Length", 
                                            choices = 0:5, selected = 1)),
                      column(2, textOutput("text2"))),

             tableOutput("tb_chosen")
             ),
    tabPanel("RoadMap", ## Place the Schema Here for databases, Python, R, MySQL, neo4j, shiny output
             img(src = "Selection_621.png")
    )
    
  )
)
                
                
