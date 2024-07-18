library(igraph)
library(wdnet)

# Read data
edges <- read.csv("/Users/huzeyu/Desktop/network analysis/raw data/Edges_Weighted.csv")

# Create graph object
g <- graph_from_data_frame(d = edges, directed = FALSE)

# Add weights to graph edges
E(g)$weight <- edges$Weight

# Convert the graph to a weighted adjacency matrix
adj_matrix <- get.adjacency(g, attr = "weight", sparse = FALSE)

# Create data array for analysis
hospital_data <- array(adj_matrix, dim = c(nrow(adj_matrix), ncol(adj_matrix), 1))

gen_assort <- function(data) {
  # Calculate weighted assortativity
  assortativity <- apply(data, 3, function(M) {
    wdnet::assortcoef(adj = M, directed = FALSE)
  })
  
  return(assortativity)
}

# Calculate weighted assortativity
result <- gen_assort(data = hospital_data)

print(result)

