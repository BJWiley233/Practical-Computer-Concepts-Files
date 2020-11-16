library(RMySQL)
library(shiny)
library(shinythemes)
library(shinyWidgets)

server <- function(input, output, session) {
  
  # nameInput <- reactive({
  #   if (input$geneNamePreferred == "") {
  #     #output$text <- renderText({ "blank" }) 
  #     text <- "blank"
  #   } else if (length(input$geneNamePreferred)==0) {
  #     text <- "is zero"
  #   } else {
  #     text <- "not blank"
  #     update_autocomplete_input(session, "uniProtID", "UniProt ID:",
  #                               options = data[data$headProteinFamily %in% input$headProteinFamily &
  #                                              data$organism %in% input$proteinOrganism &
  #                                              data$geneNamePreferred == input$geneNamePreferred, "uniProtID"])
  #   }
  #   text
  # })
  # 
  # output$text <- renderText({ nameInput() }) 
  
  nameDelete <- reactive({
    if (nchar(input$geneNamePreferred) == 0) {
      text <- nchar(input$geneNamePreferred) ## WILL BE 0
      update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                                options = data[data$headProteinFamily %in% input$headProteinFamily &
                                               data$organism %in% input$proteinOrganism, "uniProtID"])
    } else {
      text <- length(input$geneNamePreferred) ## WILL BE 1
      UP.ids <- data[data$headProteinFamily %in% input$headProteinFamily &
                   data$organism %in% input$proteinOrganism &
                   data$geneNamePreferred %in% input$geneNamePreferred,
                   "uniProtID"]
      if (length(UP.ids)==1) UP.ids = list(UP.ids)
  
      update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                                options = UP.ids)

    }
    text
  })

  output$text <- renderText({ nameDelete() })
  
  observe({
     update_autocomplete_input(session, "geneNamePreferred", "Gene Name: (type to choose IDs)",
                  options = data[data$headProteinFamily %in% input$headProteinFamily &
                                 data$organism %in% input$proteinOrganism, "geneNamePreferred"])

     update_autocomplete_input(session, "uniProtID", "UniProt ID:",
                               options = data[data$headProteinFamily %in% input$headProteinFamily &
                                              data$organism %in% input$proteinOrganism,
                                              "uniProtID"])
     output$text2 <- renderText({ input$uniProtID })

  })
  
  output$tb_chosen <- renderTable(subset(data, 
                                         data$headProteinFamily %in% input$headProteinFamily &
                                         data$geneNamePreferred %in% input$geneNamePreferred &
                                         data$organism %in% input$proteinOrganism),
                                  rownames = T)
  
  
  # output$geneName_choice <- renderUI({
  #   autocomplete_input("geneNamePreferred", "Gene Name:", 
  #               options = data[data$headProteinFamily %in% input$headProteinFamily &
  #                              data$organism %in% input$proteinOrganism, "geneNamePreferred"])
  # })
  
  # output$uniProtID_choice <- renderUI({
  #   autocomplete_input("uniProtID", "UniProt ID:", 
  #                      options = data[data$headProteinFamily %in% input$headProteinFamily &
  #                                     data$organism %in% input$proteinOrganism, "uniProtID"])
  # })
  
}