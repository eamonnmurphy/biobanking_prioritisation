# Script to combine results from various thresholds
comb_array <- array(dim = c(101, 6253, 20))

for (i in 1:20) {
    comb_array[, , 1] <- 
    read.csv(paste("../results/ordered_prior_score_", i, "mya.csv"))
}