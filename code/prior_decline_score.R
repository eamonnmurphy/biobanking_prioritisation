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
dist_prob <- matrix(nrow = 6253, ncol = 6253)

for (t in 1:100) {
  # Calculate distances between species
  dist <- cophenetic.phylo(phy.block.1000[[t]])
  
  dist_prob <- exp(-(dist / 2))
   # 1.071773463 ^ (-dist / 2)
  
  # Calculate prioritisation index
  prior_score <- rep(NA, 6253)
  spec_can_help <- rep(NA, 6253)
  spec_cant_help <- rep(NA, 6253)
  
  for (i in 1:6253) {
    spec <- Species$Species[i]
    for (j in 1:6253) {
      spec_can_help[j] <- spec_survival[j] * dist_prob[i,j]
    }
    spec_cant_help <- 1 - spec_can_help
    prob_no_help <- prod(spec_cant_help, na.rm = T)
    prob_any_help <- 1 - prob_no_help
    prior_score[i] <- spec_extinction[i] * prob_any_help
  }
  
  prior.df[t,] <- prior_score
}

prior.df[101,] <- colMeans(prior.df[1:100,], na.rm = T)

ordered.prior.df <- prior.df[,order(prior.df[101,], decreasing = T)]

write.csv(prior.df, file = "../results/initial_prior_matrix.csv")
write.csv(ordered.prior.df, file = "../results/initial_ordered_prior.csv")
