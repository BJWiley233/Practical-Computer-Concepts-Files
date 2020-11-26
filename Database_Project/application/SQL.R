output$pageStub <- renderUI(
  fluidPage(theme = "slate.min.css",
            tags$style(
                       # HTML("
                       #  .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter,
                       #  .dataTables_wrapper .dataTables_info
                       #    {
                       #    color: #a9a8ae;
                       #  }
                       #  .dataTables_wrapper .dataTables_paginate .paginate_button {
                       #    color: #a9a8ae !important;
                       #  }")
              HTML("
               .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter {
                 color: #a9a8ae;
               ")
            ),
            # Application title
            titlePanel("SQL"),
            fluidRow(column(8, DT::dataTableOutput("schema")),
                     #useShinyjs(),
                     #inlineCSS(list("table" = "font-size: 10px")),
                     column(4, textAreaInput("sql", "SQL Query")))
  )
  
)

observe({
  
  
  
  
  
})

output$schema <- DT::renderDataTable(datatable(
                      schema.mysql,  style = "bootstrap", class = "compact",
                      filter = "top",
                      options = list(
                        initComplete = JS(
                          "function(settings, json) {",
                          "$(this.api().table().header()).css({'color': '#fff'});",
                          "}"),
                        autoWidth = T,
                        columnDefs = list(
                          list(
                            targets = c(1,2,4,5,7,8),
                            render = JS(
                              "function(data, type, row, meta) {",
                              "return type === 'display' && data.length > 15 ?",
                              "'<span title=\"' + data + '\">' + data.substr(0, 15) + '...</span>' : data;",
                              "}"))),
                        scrollX='400px'), 
                      callback = JS('table.page(3).draw(false);'),
                      colnames = c("Element Name", "Table Name", "Description",
                                   "Source","Data Type", "Node or Edge", 
                                   "Neo4j Elem. Name", "Neo4j Data Type"),
                      escape = F
)
)
