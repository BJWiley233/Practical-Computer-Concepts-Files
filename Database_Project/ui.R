# library(shiny)
# library(shinythemes)
# library(shinyWidgets)
# library(dqshiny)

ui <- fluidPage(theme = shinytheme("slate"),
  navbarPage(
    "Protein Substrates",
    
    tabPanel(title = "Graph",
             h1(strong("Get neo4j Substrate Graph")), hr(),
             h4("Filters"), column(8), h6("For substrates direction=down & length=1"), hr(),
             fluidRow(column(4, pickerInput("headProteinFamily", "Protein Family:",
                                            choices = protein.families$headProteinFamily,
                                            #selected = protein.families$headProteinFamily,
                                            selected = "kinase",
                                            multiple = TRUE,
                                            options = list(`actions-box` = TRUE))),
                      #column(4, uiOutput("geneName_choice")),
                      column(3, autocomplete_input("geneNamePreferred", "Gene Name: (type to choose IDs)", 
                                                   options = dat$geneNamePreferred,
                                                   create = T)),
                      column(1),
                      column(2, selectInput("direction", "Path Direction", 
                                            choices = c("down", "up", "both"), 
                                            selected = "down")),
                      column(2, textOutput("text"))),
            
             fluidRow(column(4, pickerInput("proteinOrganism", "Organism:",
                                            choices = organism$organism,
                                            selected = organism$organism,
                                            multiple = TRUE,
                                            options = list(`actions-box` = TRUE))),
                      column(3, autocomplete_input("uniProtID", "UniProt ID:",
                                                   options = dat$uniProtID)),
                      column(1),
                      column(2, selectInput("length", "Path Length", 
                                            choices = 0:5, selected = 1)),
                      column(2, textOutput("text2"))),

             fluidRow(column(7, DT::dataTableOutput("tb_chosen")),
                      column(1),
                      column(3, sliderInput("limit", "Limit Results to:", min=1, max=200, value=10))),
             fluidRow(column(8, textOutput("text3")), 
                      column(1, actionButton("getGraph", "Get Graph"))),
             plotOutput("plot")
             ),
    tabPanel("RoadMap", ## Place the Schema Here for databases, Python, R, MySQL, neo4j, shiny output
             img(src = "Selection_621.png")
    )
    
  )
)
                
                
