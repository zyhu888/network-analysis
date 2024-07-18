library(igraph)
library(wdnet)

# Read data
edges <- read.csv("/Users/huzeyu/Desktop/network analysis/raw data/Edges_Weighted.csv")

# Create graph object
g <- graph_from_data_frame(d = edges, directed = FALSE)

# Add weights to graph edges
E(g)$weight <- edges$Weight

# Convert the graph to a weighted adjacency matrix
adj_matrix <- as_adjacency_matrix(g, attr = "weight", sparse = FALSE)

# Create data array for analysis
hospital_data <- array(adj_matrix, dim = c(nrow(adj_matrix), ncol(adj_matrix), 1))

gen_assort <- function(data) {
  # Calculate weighted assortativity
  assortativity <- apply(data, 3, function(M) {
    wdnet::assortcoef(adj = M, directed = FALSE)
  })
  return(assortativity)
}

# Calculate the original assortativity
original_assortativity <- gen_assort(data = hospital_data)

# Jackknife resampling
jackknife_assortativities <- numeric(length = nrow(edges))

for (i in 1:nrow(edges)) {
  # Create a new graph by removing the i-th edge
  g_jackknife <- delete_edges(g, E(g)[i])
  
  # Convert the new graph to a weighted adjacency matrix
  adj_matrix_jackknife <- get.adjacency(g_jackknife, attr = "weight", sparse = FALSE)
  
  # Create data array for the jackknife sample
  hospital_data_jackknife <- array(adj_matrix_jackknife, 
                                   dim = c(nrow(adj_matrix_jackknife), 
                                           ncol(adj_matrix_jackknife), 1))
  
  # Calculate the assortativity for the jackknife sample
  jackknife_assortativities[i] <- gen_assort(data = hospital_data_jackknife)
}

# Calculate the Jackknife estimate of the mean assortativity
jackknife_mean <- mean(jackknife_assortativities)

# Calculate the Jackknife standard error
jackknife_se <- sqrt(((nrow(edges) - 1) / nrow(edges)) * 
                       sum((jackknife_assortativities - jackknife_mean)^2))

# Calculate the 95% confidence interval
ci_lower <- original_assortativity - 1.96 * jackknife_se
ci_upper <- original_assortativity + 1.96 * jackknife_se

# Print results
cat("Original Assortativity:", original_assortativity, "\n")
cat("Jackknife Mean:", jackknife_mean, "\n")
cat("Jackknife Standard Error:", jackknife_se, "\n")
cat("95% Confidence Interval: [", ci_lower, ", ", ci_upper, "]\n")