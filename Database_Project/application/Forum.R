output$pageStub <- renderUI(
  fluidPage(theme = "slate.min.css",
            tags$style(
              HTML("
               .dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter {
                 color: #a9a8ae;
               ")
            ),
            # Application title
            titlePanel("FORUM (Coming Soon. Check out Iris :)"),
            fluidRow(column(8, DT::dataTableOutput("schema")),
                     #useShinyjs(),
                     #inlineCSS(list("table" = "font-size: 10px")),
                     column(4, textAreaInput("sql", "SQL Query")))
  )
  
)


output$schema <- DT::renderDataTable(datatable(
  iris,  style = "bootstrap", class = "compact",
  filter = "top",
  options = list(
    initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'color': '#fff'});",
      "}"),
    autoWidth = T,
    columnDefs = list(
      list(
        targets = 5,
        render = JS(
          "function(data, type, row, meta) {",
          "return type === 'display' && data.length > 15 ?",
          "'<span title=\"' + data + '\">' + data.substr(0, 15) + '...</span>' : data;",
          "}"))),
    scrollX='400px'), 
  callback = JS('table.page(3).draw(false);'),
  escape = F
)
)
