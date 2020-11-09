library(neo4r)
library(magrittr)
con <- neo4j_api$new(
  url = "http://localhost:7474",
  user = "neo4j", 
  password = "********"
)

con <- neo4j_api$new(url = "http://localhost:7474", 
                     db = "protein-test", user = "neo4j", 
                     password = "Swimgolf1212**", isV4 = TRUE)
con$ping()

library(httr)
GET("http://localhost:7474")
status_code(GET("http://localhost:7474"))

sprintf(
"MATCH p = (n:Protein { name:'%s' })<-[:REGULATES*1..%d]->(b:Protein)
WITH *, relationships(p) AS rs
RETURN
  startNode(last(rs)).name AS Protein1,
  last(rs).direction AS Regulates,
  endNode(last(rs)).name AS Protein2,
  length(p) AS pathLength", 'C', 2) %>%
  call_neo4j(con)

G <- sprintf(
"MATCH p = (n:Protein { name:'%s' })<-[:REGULATES*1..%d]->(b:Protein)
WITH *, relationships(p) AS rs
RETURN
  p", 'C', 2) %>%
  call_neo4j(con, type="graph")

G
class(G$nodes$properties)
#sapply(G$nodes$properties, function(x) x$name)
library(ggraph)
library(igraph)

library(dplyr)
library(purrr)
# Create a dataframe with col 1 being the ID, 
# And columns 2 being the names
G$nodes <- G$nodes %>%
  unnest_nodes(what = "properties") #%>% 
  # We're extracting the first label of each node, but 
  # this column can also be removed if not needed
  #mutate(label = map_chr(label, 1))
head(G$nodes)



G$relationships <- G$relationships %>%
  unnest_relationships() %>%
  select(startNode, endNode, type, everything())
head(G$relationships)

graph_object <- igraph::graph_from_data_frame(
  d = G$relationships, 
  directed = TRUE, 
  vertices = G$nodes,
)
plot(graph_object, edge.label=G$relationships$direction,
     vertex.label=G$nodes$name, edge.label.cex=2, 
     edge.color=ifelse(G$relationships$direction=="+", "red", "blue"),
     edge.label.color=ifelse(G$relationships$direction=="+", "red", "blue"))











# library(ggraph)
# graph_object %>%
#   ggraph() + 
#   geom_node_label(aes(label = label)) +
#   geom_edge_link() + 
#   theme_graph()
# 
# class(graph_object)
# 
# "MATCH (n)-[r]->(m)
#     RETURN n,r,m" %>%
#   call_neo4j(con)
