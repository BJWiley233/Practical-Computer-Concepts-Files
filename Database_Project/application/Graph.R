
output$pageStub <- renderUI(fluidPage(theme = shinytheme("slate"),
  navbarPage("Graph and Data",
             tabPanel(title = "Graph",
                      mainPanel(
                        plotOutput("plot")
                      )
             ),
             tabPanel(title="Data Table"),
             tabPanel(title="PDB Structures"),
             tabPanel(title="PDB Binding Sites and Drugs")

    )
  )
)

#G <- getGraph('Q05655', direction="down", length=1, limit=10)
#G <- getGraph("88888", direction="down", length=1, limit=10)
observe({
  req(input$uniProtID)
  if (input$uniProtID != "") {
  output$plot <- renderPlot({
    #isolate({
    getGraph(input$uniProtID, input$direction,
             as.numeric(input$length), limit=as.numeric(input$limit))
    #})
  }, width=1200, height=800)
  } else {
    fluidRow(
      column(5,
             HTML("<h2>404 Missing UniProt ID:</h2><p>You either didn't enter a UniProt",
                  "ID or you when back to the Search tab. Please re-enter ID.</p>")
      ))
  }
})




            