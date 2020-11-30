
library(neo4r) ## from github
library(magrittr)
library(httr)
library(igraph)
library(dplyr)
library(purrr)
library(rlist)
library(igraph)
library(plotly)

con <- neo4j_api$new(url = "http://localhost:7474", 
                     db = "protTest", user = "neo4j", 
                     password = "Swimgolf1212**", isV4 = TRUE)
status_code(GET("http://localhost:7474"))



getGraph <- function(UP.id, direction, length, limit=10) {
  
  if (direction=="down") {
    direct.str <- sprintf("-[:INTERACTION*1..%d]->", length)
  } else if (direction=="up") {
    direct.str <- sprintf("<-[:INTERACTION*1..%d]-", length)
  } else {
    direct.str <- sprintf("<-[:INTERACTION*1..%d]->", length)
  }
  
  G <- sprintf(
    "MATCH p = (n:Protein {uniprotID:'%s'})%s() 
      WITH *, relationships(p) AS rs
      RETURN 
        p
      LIMIT %d",  UP.id, direct.str, limit
  ) %>%
    call_neo4j(con, type="graph")
  
  
  if (length(G)==0) {
    return("No results in graph. Try another protein.")
  } else {
    
    G$nodes$properties <- lapply(G$nodes$properties, 
                                 function(x) list.remove(x, c("altProtNames", "altGeneNames")))
    
    G$nodes <- G$nodes %>%
      unnest_nodes(what = "properties")
    
    G$relationships <- G$relationships %>%
      unnest_relationships() %>%
      select(startNode, endNode, type, everything())

    
    return(G)
  }
  
}

normalize <- function(x) {x / sqrt(sum(x^2))}

direction <- "down"
length <- 1
name <- "Setd2"
UP.id <- "E9Q5F9"
limit <- 25


G2 <- getGraph(UP.id, direction=direction, length=length, limit=limit)

##################################################################
# graph_object <- igraph::graph_from_data_frame(
#   d = G2$relationships, 
#   directed = TRUE, 
#   vertices = G2$nodes
# )

# plot(graph_object, edge.label=G2$relationships$name,
#      vertex.label=G2$nodes$name, edge.label.cex=0.8,
#      vertex.label.cex=0.7) 
##################################################################
relation <- data.frame(G2$relationships)
relation <- relation %>% rename(reaction=name)
G3 <- G2$nodes[c("id", "organism", "taxid", "name", "uniprotID")] 


df1 <- left_join(relation, G3, by = c("startNode"="id"))
df2 <- left_join(df1, G3, by = c("endNode"="id"))
df3 <- df2[c("name.x", "uniprotID.x", "taxid.x", "organism.x",
             "name.y", "uniprotID.y", "taxid.y", "organism.y",
             "reaction", "entries")]

x <- df3$entries[[14]]
df3$entries <- sapply(df3$entries, function(x) {
  l = jsonlite::fromJSON(x[[1]])
  string = ""
  if (!is.null(l$interactionID)) {
    if (grepl("EBI-[0-9]+", l$interactionID)) {
      l$interactionID = sprintf("<a href=https://www.ebi.ac.uk/intact/interaction/%s>%s</a>",
                                     l$interactionID, l$interactionID)
    } else if (grepl("CLE[0-9]+", l$interactionID)) {
      link.id <- ex_between(l$`publicationID(s)`, "[", "]")[[1]]
      publication <- ex_between(l$`publicationID(s)`, "<%", "[")[[1]]
      publication <- gsub("%", "", publication)
      l$`publicationID(s)` = sprintf("<a href=https://www.ebi.ac.uk/merops/cgi-bin/refs?id=%s>%s</a>",
                                          link.id, publication)
    }
  }
  for (j in paste(names(l), ":", l, "\n"))
    string = paste(string, j)
  return(trimws(string, which="both"))
})




#grepl('PhosphoSitePlus', df3$entries)
links <- apply(df3, 1, function(row) {
  if (grepl('PhosphoSitePlus', row[["entries"]])) {
    row[["uniprotID.x"]] <- sprintf("<a href=https://www.phosphosite.org/uniprotAccAction?id=%s>%s</a>", 
                                    row[["uniprotID.x"]], row[["uniprotID.x"]])
    row[["uniprotID.y"]] <- sprintf("<a href=https://www.phosphosite.org/uniprotAccAction?id=%s>%s</a>", 
                                    row[["uniprotID.y"]], row[["uniprotID.y"]])
  } else {
    row[["uniprotID.x"]] <- sprintf("<a href='https://www.uniprot.org/uniprot/%s'>%s</a>", 
                                    row[["uniprotID.x"]], row[["uniprotID.x"]])
    row[["uniprotID.y"]] <- sprintf("<a href='https://www.uniprot.org/uniprot/%s'>%s</a>", 
                                    row[["uniprotID.y"]], row[["uniprotID.y"]])
  }
  c(row[["uniprotID.x"]], row[["uniprotID.y"]])
})
# dim(links)
# dim(t(links))
df3[,c("uniprotID.x", "uniprotID.y")] <- t(links)

# df3$uniprotID.y <- sprintf("<a href='https://www.uniprot.org/uniprot/%s'>%s</a>", 
#                            df3$uniprotID.y, df3$uniprotID.y)

colnames(df3) <- c("Protein", "Protein UniProt ID", "Protein taxid", "Protein organism",
                   "Substrate", "Substrate UniProt ID", "Substrate taxid", "Substrate organism",
                   "Reaction type", "Reaction info")


df3$`Reaction info` <- lapply(df3$`Reaction info`, function(x) gsub(',"', ', "', x))

# library(plotly)
# library(igraphdata)
# library(dplyr)
# library(jsonlite)
## this gets a nice dataframe for the edges
final <- G2$relationships %>%
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
  vertices = G2$nodes
)
index.protein.searched <- which(G2$nodes$uniprotID == UP.id)

L.g <- layout.circle(graph_object)
vs.g <- V(graph_object)
es.g <- get.edgelist(graph_object)

Nv.g <- length(vs.g) #number of nodes
Ne.g <- length(es.g[,1]) #number of edges

L.g <- layout.fruchterman.reingold(graph_object)
Xn.g <- L.g[,1]
Yn.g <- L.g[,2]

v.colors <- c("dodgerblue", "green", "yellow")
# for different interactions types 
e.colors <- c("orchid", "orange", "turquoise", "grey", "purple", "black", "darkblue", "")

#vertex_attr(graph_object, "UniProt ID", index = V(graph_object)) <- node.data.g$uniprotID
v.attrs <- vertex_attr(graph_object)
edge_attr(graph_object, "color", index = E(graph_object)) <- 
  e.colors[as.factor(edge_attr(graph_object)$name)]
e.attrs <- edge_attr(graph_object)
as.factor(e.attrs$name)

v.attrs$label[[21]] = "Protein"
# Creates the nodes (plots the points)
as.factor(data.frame(v.attrs$label))
#colors <- v.colors[as.factor(v.attrs$label)]
colors <- v.colors[forcats::fct_rev(as.factor(data.frame(v.attrs$label)))]
colors[index.protein.searched] <- "red"
network.g <- plot_ly(x = ~Xn.g, y = ~Yn.g, #Node points
                   mode = "text+markers", 
                   text = vs.g$name, 
                   hoverinfo = "text",
                   hovertext = paste0("Name: ", v.attrs$name, "\n",
                                     "UniProt ID: ", v.attrs$uniprotID, "\n",
                                     "Organism: ", v.attrs$organism, "\n",
                                     "TaxID: ", v.attrs$taxid),
                   marker = list(
                     color = colors,
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
  if (all(dir == 0)) {
    new.p1 <- c(Xn.g[v1.g], Yn.g[v1.g])*(.9999)
    new.p2 <- c(Xn.g[v1.g], Yn.g[v1.g])*(1.0001)
  } else {
    new.p1 <- c(Xn.g[v0.g], Yn.g[v0.g]) + .2*normalize(dir)
    new.p2 <- c(Xn.g[v1.g], Yn.g[v1.g]) + -.1*normalize(dir)
  }
  
  edge_shape.g = list(
    type = "line",
    line = list(color = e.attrs$color[i], width = 2, layer="below"),
    opacity = 0.7,
    x0 = new.p1[1],
    y0 = new.p1[2],
    x1 = new.p2[1],
    y1 = new.p2[2],
    name = e.attrs$name[i]
    # x0 = Xn.g[v0.g],
    # y0 = Yn.g[v0.g],
    # x1 = Xn.g[v1.g],
    # y1 = Yn.g[v1.g]
  )
  
  edge_shapes.g[[i]] <- edge_shape.g
}


axis.g <- list(title = "", showgrid = FALSE, 
             showticklabels = FALSE, zeroline = FALSE)
title <- ifelse(length==1 & direction=="down",
                sprintf("%s Substrates", name),
                sprintf("%s Paths", name))

p.g <- layout(
  network.g,
  title = list(text=title, 
               font=list(size=25)
               ),
  shapes = edge_shapes.g,
  xaxis = axis.g,
  yaxis = axis.g,
  showlegend=TRUE
) %>% add_trace(type="scatter")



arrow.x.start <- lapply(edge_shapes.g, function(x) x$x0) 
arrow.x.end <- lapply(edge_shapes.g, function(x) x$x1) 
arrow.y.start <- lapply(edge_shapes.g, function(x) x$y0) 
arrow.y.end <- lapply(edge_shapes.g, function(x) x$y1) 


ent <- lapply(e.attrs$entries, function(x) {
  string = ""
  l <- list()
  for (i in 1:length(x)) {
    string <- paste0(string, i, ". ")
    l[[i]] = jsonlite::fromJSON(x[i][[1]])
    for (j in paste(names(l[[i]]), ":", l[[i]], "\n")) {
      string = paste0(string, j)
    }
  }
  return(string)
})

x=e.attrs$entries[[1]]

p.g %>% plotly::add_trace(type = 'scatter') %>%
  
  plotly::add_annotations( x = ~arrow.x.end,
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
  
  plotly::add_annotations( x = ~arrow.x.end,
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

par(mar=c(1,1,1.4,1))
plot(NULL ,xaxt='n',yaxt='n',bty='n',ylab='',xlab='', xlim=0:1, ylim=0:1)
legend("topleft", legend = levels(as.factor(e.attrs$name)), lty = 1, lwd = 3, 
       col = c(unique(e.colors))[1:nlevels(as.factor(e.attrs$name))], ncol=5,
       box.lty = 0, cex=1.2)
mtext("Reaction type", at=0.2, cex=2)
  