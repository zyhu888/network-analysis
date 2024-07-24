##########################################
#### Calculate weighted assortativity ####
##########################################
gen_assort <- function(data) {
  assortativity <- apply(data, 3, function(M) {
    wdnet::assortcoef(adj = M, directed = FALSE)
  })
  return(assortativity)
}
