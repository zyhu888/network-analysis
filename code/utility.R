##########################################
#### Calculate weighted assortativity ####
##########################################
gen_assort <- function(data) {
  assortativity <- apply(data, 3, function(M) {
    wdnet::assortcoef(adj = M, directed = FALSE)
  })
  return(assortativity)
}

##########################################
####### Filter nodes and calculate #######
## assortativity for given institutions ##
##########################################
calculate_assortativity_for_institution <- function(institution) {
  # Filter nodes that belong to the specified institution
  institution_nodes <- nodes[nodes$Institution == institution, ]
  
  # Extract the IDs of these filtered nodes
  institution_node_ids <- institution_nodes$Id
  
  # Filter edges where both Source and Target belong to the filtered nodes
  institution_edges <- edges[edges$Source %in% institution_node_ids & edges$Target %in% institution_node_ids, ]
  
  # Create graph object
  institution_g <- graph_from_data_frame(d = institution_edges, directed = FALSE)
  
  # Add weights to graph edges
  E(institution_g)$weight <- institution_edges$Weight
  
  # Convert the graph to a weighted adjacency matrix
  institution_adj_matrix <- as_adjacency_matrix(institution_g, attr = "weight", sparse = FALSE)
  
  # Create data array for analysis
  institution_data <- array(institution_adj_matrix, dim = c(nrow(institution_adj_matrix), ncol(institution_adj_matrix), 1))
  
  # Calculate assortativity
  institution_assortativity <- gen_assort(data = institution_data)
  cat("The assortativity coefficient for", institution, "is:", institution_assortativity, "\n")
}

##########################################
####### Filter nodes and calculate #######
## assortativity for given specialties  ##
##########################################
calculate_assortativity_for_specialty <- function(specialty) {
  # Filter nodes that belong to the specified specialty
  specialty_nodes <- nodes[nodes$Specialty == specialty, ]
  
  # Extract the IDs of these filtered nodes
  specialty_node_ids <- specialty_nodes$Id
  
  # Filter edges where both Source and Target belong to the filtered nodes
  specialty_edges <- edges[edges$Source %in% specialty_node_ids & edges$Target %in% specialty_node_ids, ]
  
  # Create graph object
  specialty_g <- graph_from_data_frame(d = specialty_edges, directed = FALSE)
  
  # Add weights to graph edges
  E(specialty_g)$weight <- specialty_edges$Weight
  
  # Convert the graph to a weighted adjacency matrix
  specialty_adj_matrix <- as_adjacency_matrix(specialty_g, attr = "weight", sparse = FALSE)
  
  # Create data array for analysis
  specialty_data <- array(specialty_adj_matrix, dim = c(nrow(specialty_adj_matrix), ncol(specialty_adj_matrix), 1))
  
  # Calculate assortativity
  specialty_assortativity <- gen_assort(data = specialty_data)
  cat("The assortativity coefficient for", specialty, "is:", specialty_assortativity, "\n")
}