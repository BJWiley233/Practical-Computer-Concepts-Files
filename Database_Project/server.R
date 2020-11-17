# library(shiny)
# library(shinythemes)
# library(shinyWidgets)

server <- function(input, output, session) {
  

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
     
     ## if delete Gene Name
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
       

  })
  
  output$tb_chosen <- DT::renderDataTable(
                                         datatable(subset(dat, 
                                         dat$headProteinFamily %in% input$headProteinFamily &
                                         dat$geneNamePreferred %in% input$geneNamePreferred &
                                         dat$organism %in% input$proteinOrganism),
                                         selection=list(mode = "single", target = "cell")))

}