# Load necessary libraries
library(igraph)
library(wdnet)
library(ggplot2)
library(tidyr)
library(xtable)
library(boot)
# Read the data
edges <- read.csv("/Users/huzeyu/Desktop/network analysis/raw data/Edges_Weighted.csv")

# Create a graph object
g <- graph_from_data_frame(d = edges, directed = FALSE)

# Add weights to the graph edges
E(g)$weight <- edges$Weight

# Convert the graph to an adjacency matrix with weights
adj_matrix <- get.adjacency(g, attr = "weight", sparse = FALSE)

# Create the data array for analysis
hospital_data <- array(adj_matrix, dim = c(nrow(adj_matrix), ncol(adj_matrix), 1))

# Function to generate assortativity
generate_assortativity <- function(data = hospital_data, alpha = 1) {
  # Generate weighted and undirected networks
  data_ud <- array(NA, dim = dim(data))
  data_ud[] <- apply(data, 3, function(M) {
    temp <- netbackbone(M, alpha = alpha, weighted = TRUE, directed = FALSE)
    return(temp$AdjacencyMatrix)})
  
  # Weighted assortativity
  assort_total <- apply(data_ud, 3, function(M) {wdnet::assortcoef(adj = M)$outin})
  result <- rbind(assort_total)
  rownames(result) <- c("total")
  return(result)
}

## Choose different backbone levels: alpha = 10^-2, 10^-3, 10^-4, etc.
## The backbone is based on "Xu, M. and Liang, S., Input-output networks offer new insights 
## of economic structure".
## Alternative is to use a fixed threshold.
## If both alpha and a fixed threshold are given, the fixed threshold is used.
## Weights can be kept or removed.
## Direction can be kept or removed.

netbackbone <- function(M, alpha = 0.05, thres.fixed = NA,
                        weighted = TRUE, directed = FALSE) {
  ## if using the fixed threshold
  n <- dim(M)[1]
  if (is.na(thres.fixed) == FALSE) {
    thres <- thres.fixed
    M[M < thres] <- 0
  }
  
  ## if using filter method
  if (missing(thres.fixed)|is.na(thres.fixed)) {
    ## normalized out-weight and in-weight
    w_norm_out <- M/rowSums(M) ## produce NaNs for the nodes with no outgoing edges
    w_norm_in <- t(t(M)/colSums(M)) ## produce NaNs for the nodes with no incoming edges
    ## adjacency matrix ignoring weight
    A <- M
    A[A > 0] <- 1
    A_out <- rowSums(A)
    A_in <- colSums(A)
    ## alpha matrices for filtration
    alpha_out <- (1 - w_norm_out)^(A_out - 1) ## A_out = 1 always produces alpha_out = 1
    alpha_in <- t((t(1 - w_norm_in))^(A_in - 1)) ## A_in = 1 always produces alpha_in = 1
    alpha_out[alpha_out < alpha] <- 0
    alpha_out[alpha_out > alpha] <- 1
    alpha_out <- 1 - alpha_out
    alpha_in[alpha_in < alpha] <- 0
    alpha_in[alpha_in > alpha] <- 1
    alpha_in <- 1 - alpha_in
    ## indicate which edges to be kept
    alpha_tot <- alpha_out + alpha_in
    alpha_tot[alpha_tot > 0] <- 1
    M <- M*alpha_tot
    ## assign 0 to NaNs, as they have no incoming edge, outgoing edge or both
    M[is.nan(M)] <- 0
    ## threshold corresponding to alpha
    thres <- min(M[M != 0], na.rm = TRUE)
  }
  if (!weighted) {
    M[M > 0] <- 1
  }
  if (!directed) {
    M <- M + t(M)
    M <- M - diag(diag(M), n)/2
    warning("The resulting threshold is before merging the directed edges!")
  }
  return(list(AdjacencyMatrix = M, Threshold = thres))
}


# Generate the assortativity matrix
assortativity_results <- generate_assortativity(hospital_data, alpha = 0.05)

# Print the assortativity results
print(xtable(assortativity_results, digits = c(0, rep(3, ncol(assortativity_results)))))

generate_assortativity_sequence <- function(x) {
  data <- hospital_data
  
  # Generate weighted and undirected networks at significance level x
  data_ud_x <- array(NA, dim = dim(data))
  data_ud_x[] <- apply(data, 3, function(M) {
    temp <- netbackbone(M, alpha = x, weighted = TRUE, directed = FALSE)
    return(temp$AdjacencyMatrix)})
  
  # Weighted assortativity
  assort_total <- apply(data_ud_x, 3, function(M) {wdnet::assortcoef(adj = M)$outin})
  
  result <- rbind(assort_total)
  return(result)
}

# Generate assortativity coefficients at a sequence of significance levels
alpha_seq <- seq(0.001, 0.999, 0.001)
assort_seq_results <- mapply(generate_assortativity_sequence, alpha_seq)



# Convert the results to a data frame
assort_seq_df <- data.frame(alpha = alpha_seq, assort = assort_seq_results)

# Plot the relationship between assortativity and alpha
ggplot(assort_seq_df, aes(x = alpha, y = assort)) + 
  geom_line(color = "purple") + 
  xlab("delta") + 
  ylab("assortativity") + 
  theme(panel.spacing = unit(1, "lines"), 
        legend.position = "bottom", 
        legend.spacing.x = unit(0.5, "cm"), 
        strip.background = element_rect(fill = "grey60", color = "grey60"))