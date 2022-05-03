# Script to begin initial prioritisation index

###### Load required libraries ########
library(ape)

####### Load in data #########
load("../data/100_mammal_trees_with_2020_RL.RData")
likelihoods <- read.csv("../data/survival_likelihoods.csv")

##### Perform analysis on example tree #######
example <- phy.block.1000[[1]]

# Calculate distances between species
example_dist <- cophenetic.phylo(example)

spec <- dimnames(example_dist)[[1]]
spec_GE <- rep(NA, 6253)
spec_survival <- rep(NA, 6253)
spec_extinction <- rep(NA, 6253)
for (i in 1:6253) {
  spec_GE[i] <- Species$GE[which(Species$Species == spec[i])]
  try(spec_survival[i] <- 
        likelihoods$Survival[which(likelihoods$GE == spec_GE[i])], silent = T)
  try(spec_extinction[i] <- 
        likelihoods$Extinction[which(likelihoods$GE == spec_GE[i])], silent = T)
}


# Calculate prioritisation index
prior_score <- rep(NA, 6253)
for (i in 1:6253) {
  close_extinction <- spec_extinction[which(example_dist[i,] / 2 < 10 & example_dist[i,] != 0)]
  total_close_extinction <- prod(close_extinction, na.rm = TRUE)
  related_survival <- 1 - total_close_extinction
  prior_score[i] <- spec_extinction[i] * total_close_extinction
}

prior_matrix <- data.frame(spec, prior_score)
prior_matrix <- prior_matrix[order(prior_matrix[,2], decreasing = T),]

write.csv(prior_matrix, file = "../results/example_prior_matrix.csv")
