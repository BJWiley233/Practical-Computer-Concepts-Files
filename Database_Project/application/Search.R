# Already inside server
output$pageStub <- renderUI(fluidPage(theme = shinytheme("slate"),
                                      
  titlePanel(title = "Search"),
  
  fluidRow(column(4, h4("Filters")), column(8, h6("\tFor substrates direction=down & length=1"))),
           
  fluidRow(column(4, pickerInput("headProteinFamily", "Protein Family:",
                                choices = protein.families$headProteinFamily,
                                #selected = protein.families$headProteinFamily,
                                selected = "kinase",
                                multiple = TRUE,
                                options = list(`actions-box` = TRUE))),
   
          column(3, autocomplete_input("geneNamePreferred", "Gene Name: (type to choose IDs)", 
                                       options = dat$geneNamePreferred, 
                                       value = session$input$geneNamePreferred,
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
                                choices = 1:5, selected = 1)),
           column(2, textOutput("text2"))),
  
  fluidRow(column(7), column(1, textOutput("upID")),
           column(3, sliderInput("limit", "Limit Results to:", min=1, max=200, value=10))),
  
  fluidRow(column(7, DT::dataTableOutput("tb_chosen")), column(1),
           column(1, actionButton("getGraph", "Get Graph")),
           column(3, textOutput("text3")))
  )
)

observe({
  update_autocomplete_input(session, "geneNamePreferred", "Gene Name: (type to choose IDs)",
                            options = dat[dat$headProteinFamily %in% input$headProteinFamily &
                                          dat$organism %in% input$proteinOrganism, "geneNamePreferred"])
  
  update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                            options = dat[dat$headProteinFamily %in% input$headProteinFamily &
                                          dat$organism %in% input$proteinOrganism,
                                          "uniProtID"])
  
  output$text <- renderText({ nchar(input$geneNamePreferred) })
  output$text2 <- renderText({ length(input$tb_chosen_cells_selected) })
  
  req(input$geneNamePreferred)
  
  # if delete Gene Name
  if (nchar(input$geneNamePreferred) == 0) {
    update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                              options = dat[dat$headProteinFamily %in% input$headProteinFamily &
                                            dat$organism %in% input$proteinOrganism, "uniProtID"],
                              value = "", create=T)
  } else {
    UP.ids <- dat[dat$headProteinFamily %in% input$headProteinFamily &
                    dat$organism %in% input$proteinOrganism &
                    dat$geneNamePreferred %in% input$geneNamePreferred,
                  "uniProtID"]
    if (length(UP.ids)==1) { UP.ids = list(UP.ids) }

    update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                              options = UP.ids,
                              value = "", create=T)
  }
  
  ## if selecting from table
  if(length(input$tb_chosen_cells_selected)==0) {
    
  } 
  else {
    indices <- input$tb_chosen_cells_selected
    UP.ids <- dat[dat$headProteinFamily %in% input$headProteinFamily &
                  dat$organism %in% input$proteinOrganism &
                  dat$geneNamePreferred %in% input$geneNamePreferred,
                  "uniProtID"]
    if (length(UP.ids)==1) {
      value <- UP.ids
      UP.ids = list(UP.ids)
    } else {
      value <- UP.ids[indices[1]]
    }
    
    update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                              options = UP.ids, create = F,
                              value = value)  
    
  }
  output$upID <- renderText({ input$uniProtID })
  
  
})



observeEvent(input$getGraph, {
  submit.click()
  req(input$uniProtID)
})


submit.click <- reactive({
  if (input$uniProtID == "" || input$direction == "" || input$length < 1) {
    output$text3 <- renderText({ "Error" })
  } else {
    output$text3 <- renderText({ paste(input$uniProtID, input$direction, 
                                       as.numeric(input$length), as.numeric(input$limit)) })
    
    fname = paste0("Graph", ".R") # remove leading "?", add ".R"
    cat(paste0("Session filename: ", fname, ".\n"))      # print the URL for this session
    source(fname, local=TRUE)
    update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                              options = dat[dat$headProteinFamily %in% input$headProteinFamily &
                                              dat$organism %in% input$proteinOrganism, "uniProtID"],
                              value = input$uniProtID, create=T)
  }
  
})


output$tb_chosen <- DT::renderDataTable(
                        datatable(subset(dat,
                                         dat$headProteinFamily %in% input$headProteinFamily &
                                         dat$geneNamePreferred %in% input$geneNamePreferred &
                                         dat$organism %in% input$proteinOrganism),
                                  selection=list(mode = "single", target = "cell")))


                
                
