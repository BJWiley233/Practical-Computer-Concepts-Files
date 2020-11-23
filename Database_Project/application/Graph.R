library(dplyr)

output$pageStub <- renderUI(fluidPage(theme = shinytheme("slate"),
  navbarPage("Graph and Data",
             tabPanel(title = "Graph",
                      mainPanel(
                        plotlyOutput("plot", width="1200px", height="800px")
                      )
             ),
             tabPanel(title="Data Table",
                      mainPanel(
                        fluidRow(column(8, DT::dataTableOutput("data_table")))
                      )
             ),
             tabPanel(title="PDB Structures",
                      mainPanel(
                        fluidRow(column(8, DT::dataTableOutput("PDB_Structures")))
                      )
             ),
             tabPanel(title="PDB Binding Sites and Drugs",
                      mainPanel(
                        fluidRow(column(8, DT::dataTableOutput("binding_drug")))
                      )
             )

    )
  )
)

#G <- getGraph('Q05655', direction="down", length=1, limit=10)
#G <- getGraph("88888", direction="down", length=1, limit=10)
observe({
  req(input$uniProtID)
  name <- dat[dat$uniProtID==input$uniProtID, "geneNamePreferred"]
  G <- getGraph(input$uniProtID, input$direction,
                as.numeric(input$length), limit=as.numeric(input$limit))
  if ("neo" %in% class(G)) {
    output$plot <- renderPlotly({
      # graph_object <- igraph::graph_from_data_frame(
      #   d = G$relationships, 
      #   directed = TRUE, 
      #   vertices = G$nodes
      # )
      # 
      # plot(graph_object, edge.label=G$relationships$name,
      #      vertex.label=G$nodes$name, edge.label.cex=0.8,
      #      vertex.label.cex=0.7) 
      
      final <- G$relationships %>%
        group_by(id, startNode, endNode) %>% 
        summarise(
          startNode=startNode,
          endNode=endNode,
          type=type,
          id=id,
          entries=list(unique(entries)),
          name=name) %>%
        relocate(id, .after = type) %>%
        distinct()
      
      graph_object <- igraph::graph_from_data_frame(
        d = final, 
        directed = TRUE, 
        vertices = G$nodes
      )
      
      L.g <- layout.circle(graph_object)
      vs.g<- V(graph_object)
      es.g <- get.edgelist(graph_object)
      
      Nv.g <- length(vs.g) #number of nodes
      Ne.g <- length(es.g[,1]) #number of edges
      
      L.g <- layout.fruchterman.reingold(graph_object)
      Xn.g <- L.g[,1]
      Yn.g <- L.g[,2]
      
      v.colors <- c("dodgerblue", "red", "yellow", "green")
      # for different interactions types 
      e.colors <- c("orchid", "orange", "black", "grey", "purple")
      
      #vertex_attr(graph_object, "UniProt ID", index = V(graph_object)) <- node.data.g$uniprotID
      v.attrs <- vertex_attr(graph_object)
      edge_attr(graph_object, "color", index = E(graph_object)) <- 
        e.colors[as.factor(edge_attr(graph_object)$name)]
      e.attrs <- edge_attr(graph_object)
      
      # Creates the nodes (plots the points)
      network.g <- plot_ly(x = ~Xn.g, y = ~Yn.g, #Node points
                           mode = "text+markers", 
                           text = vs.g$name, 
                           hoverinfo = "text",
                           hovertext = paste0("Name: ", v.attrs$name, "\n",
                                              "UniProt ID: ", v.attrs$uniprotID, "\n",
                                              "Organism: ", v.attrs$organism, "\n",
                                              "TaxID: ", v.attrs$taxid),
                           marker = list(
                             color = v.colors[as.factor(v.attrs$label)],
                             size = 20),
                           textfont = list(color = '#000000', size = 16, layer="above"),
      )
      
      #Create edges
      edge_shapes.g <- list()
      names(Xn.g) <- names(vs.g)
      names(Yn.g) <- names(vs.g)
      for(i in 1:Ne.g) {
        v0.g <- as.character(es.g[i,1])
        v1.g <- as.character(es.g[i,2])
        
        dir <- c(Xn.g[v1.g], Yn.g[v1.g]) - c(Xn.g[v0.g], Yn.g[v0.g])
        
        new.p1 <- c(Xn.g[v0.g], Yn.g[v0.g]) + .2*normalize(dir)
        new.p2 <- c(Xn.g[v1.g], Yn.g[v1.g]) + -.1*normalize(dir)
        
        edge_shape.g = list(
          type = "line",
          line = list(color = e.attrs$color[i], width = 2, layer="below"),
          opacity = 0.7,
          x0 = new.p1[1],
          y0 = new.p1[2],
          x1 = new.p2[1],
          y1 = new.p2[2]
        )
        
        edge_shapes.g[[i]] <- edge_shape.g
      }
      
      
      axis.g <- list(title = "", showgrid = FALSE, 
                     showticklabels = FALSE, zeroline = FALSE)
      title <- ifelse(length==1 & direction=="down",
                      sprintf("%s Substrates", name),
                      sprintf("%s Paths", name))
      
      p.g <- plotly::layout(
        network.g,
        title = list(text=title, 
                     font=list(size=25)
        ),
        shapes = edge_shapes.g,
        xaxis = axis.g,
        yaxis = axis.g,
        showlegend=FALSE,
        margin = list(l=50, r=50, b=100, t=100, pad=4)
      )
      
      
      arrow.x.start <- lapply(edge_shapes.g, function(x) x$x0) 
      arrow.x.end <- lapply(edge_shapes.g, function(x) x$x1) 
      arrow.y.start <- lapply(edge_shapes.g, function(x) x$y0) 
      arrow.y.end <- lapply(edge_shapes.g, function(x) x$y1) 
      
      
      ent <- lapply(e.attrs$entries, function(x) {
        string = ""
        t <- list()
        for (i in 1:length(x)) {
          string <- paste0(string, i, ". ")
          t[[i]] = jsonlite::fromJSON(x[i][[1]])
          for (j in paste(names(t[[i]]), ":", t[[i]], "\n")) {
            string = paste0(string, j)
          }
        }
        return(string)
      })
      
      
      p.g %>% add_trace(type = 'scatter') %>%
        
        add_annotations( x = ~arrow.x.end,
                         y = ~arrow.y.end,
                         xref = "x", yref = "y",
                         axref = "x", ayref = "y",
                         text = "",
                         hoverinfo = c(~arrow.x.end, ~arrow.y.end),
                         hovertext = paste(ent),
                         opacity = 0.7,
                         ax = ~arrow.x.end,
                         ay = ~arrow.y.end,
                         layer="below") %>%
        
        add_annotations( x = ~arrow.x.end,
                         y = ~arrow.y.end,
                         xref = "x", yref = "y",
                         axref = "x", ayref = "y",
                         text = "",
                         showarrow = T,
                         arrowcolor = ~e.attrs$color,
                         opacity = 0.7,
                         ax = ~arrow.x.start,
                         ay = ~arrow.y.start, 
                         layer="below")
      
    })
    
    ## get table from graph
    relation <- data.frame(G$relationships)
    relation <- relation %>% rename(reaction=name)
    G2 <- G$nodes[c("id", "organism", "taxid", "name", "uniprotID")] 
    
    df1 <- left_join(relation, G2, by = c("startNode"="id"))
    df2 <- left_join(df1, G2, by = c("endNode"="id"))
    df3 <- df2[c("name.x", "uniprotID.x", "taxid.x", "organism.x",
                 "name.y", "uniprotID.y", "taxid.y", "organism.y",
                 "reaction", "entries")]
    colnames(df3) <- c("Protein", "Protein UniProt ID", "Protein taxid", "Protein organism",
                       "Substrate", "Substrate UniProt ID", "Substrate taxid", "Substrate organism",
                       "Reaction type", "Reaction info")
    df3$`Reaction info` <- lapply(df3$`Reaction info`, function(x) gsub(',"', ', "', x))
    # https://community.rstudio.com/t/change-the-color-of-column-headers-in-dt-table/77343
    output$data_table <- DT::renderDataTable(
                            datatable(df3,
                                      options = list(
                                        initComplete = JS(
                                          "function(settings, json) {",
                                          "$(this.api().table().header()).css({'color': '#fff'});",
                                          "}"),
                                        # https://github.com/rstudio/DT/issues/171
                                        autoWidth = T,
                                        targets = 10,
                                        render = JS(
                                          "function(data, type, row, meta) {",
                                          "return type === 'display' && data.length > 60 ?",
                                          "'<span title=\"' + data + '\">' + data.substr(0, 60) + '...</span>' : data;",
                                          "}"),
                                        LengthMenu = c(5, 30, 50),
                                        columnDefs = list(list(
                                          className = 'dt-body-left')),
                                        pageLength = 10, server = T
                                      )
                            )
    )
    
    output$PDB_Structures <- DT::renderDataTable(
                                datatable(loadData(structures.query(input$uniProtID)),
                                          options = list(
                                            initComplete = JS(
                                              "function(settings, json) {",
                                              "$(this.api().table().header()).css({'color': '#fff'});",
                                              "}"))
                                )
    )
                            
  } else {
    output$plot <- renderPlot({ plot.new()
      text(x=0, y=1, labels="No data in neo4j for your protein!
There may be structure data on other tabs.
Check 'PDB Structures' or 'PDB Binding Sites and Drugs' tabs
or select a different UniProt ID", pos=4, col="red")
      })
    # output$pageStub <- renderUI(tagList(              # 404 if no file with that name
    #   fluidRow(
    #     column(5,
    #            HTML("<h2>No Data for your Protein:</h2><p>Select another UniProt ID</p>")
    #   )
    # )))
  }
})




            