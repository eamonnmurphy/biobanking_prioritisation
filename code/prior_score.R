# Script to calculate average prioritisation indexes
rm(list = ls())

###### Load required libraries ########
library(ape)

####### Load in data #########
load("../data/cleaned_mammal_trees_2020.RData")
likelihoods <- read.csv("../data/survival_likelihoods.csv")

##### Prepare objects which will store results #####
prior.df <- data.frame(matrix(nrow = 101, ncol = 6253))
rownames(prior.df) <- c(seq(1, 100), "Average")
colnames(prior.df) <- Species$Species


# Precalculate survival and extinction likelihoods
spec_survival <- rep(NA, 6253)
spec_extinction <- rep(NA, 6253)
for (i in 1:6253) {
  try(spec_survival[i] <- 
        likelihoods$Survival[which(likelihoods$GE == Species$GE[i])], silent = T)
  try(spec_extinction[i] <- 
        likelihoods$Extinction[which(likelihoods$GE == Species$GE[i])], silent = T)
}

##### Iterate through each tree for analysis ######
for (t in 1:100) {
  # Calculate distances between species
  dist <- cophenetic.phylo(phy.block.1000[[t]])
  
  # Calculate prioritisation index
  prior_score <- rep(NA, 6253)
  for (i in 1:6253) {
    spec <- Species$Species[i]
    if (sum(dist[spec,] / 2 < 10 & dist[spec,] != 0, na.rm = T) == 0) {
      close_extinction <- 1
    } else {
      close_extinction <- 
        spec_extinction[which(dist[Species$Species[i],] / 2 < 10 
                              & dist[Species$Species[i],] != 0)]
    }
    total_close_extinction <- prod(close_extinction, na.rm = TRUE)
    related_survival <- 1 - total_close_extinction
    prior_score[i] <- spec_extinction[i] * related_survival
  }
  
  prior.df[t,] <- prior_score
}

prior.df[101,] <- colMeans(prior.df[1:100,], na.rm = T)

ordered.prior.df <- prior.df[,order(prior.df[101,], decreasing = T)]

write.csv(prior.df, file = "../results/initial_prior_matrix.csv")
write.csv(ordered.prior.df, file = "../results/initial_ordered_prior.csv")
