# Script to calculate average prioritisation indexes
rm(list = ls())

###### Load required libraries ########
library(ape)
library(dplyr)

# Read in job number (will serve as threshold)
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

####### Load in data #########
load("cleaned_mammal_trees_2020.RData")
likelihoods <- read.csv("species_likelihoods.csv")

# Extract required info
spec_extinction <- likelihoods$extinction
spec_survival <- likelihoods$survival

##### Prepare objects which will store results #####
prior_df <- data.frame(matrix(nrow = 6253, ncol = 101))
colnames(prior_df) <- c(paste("Tree", seq(1, 100), sep = ""), "Average")
rownames(prior_df) <- Species$Species

##### Iterate through each tree for analysis ######
for (t in 1:100) {
  # Calculate distances between species
  dist <- cophenetic.phylo(phy.block.1000[[t]])

  # Calculate prioritisation index
  prior_score <- rep(NA, 6253)
  for (i in 1:6253) {
    spec <- Species$Species[i]
    # Set close extinction to 1 for species without close relative
    if (sum(dist[spec, ] / 2 < iter & dist[spec, ] != 0, na.rm = T) == 0) {
      close_extinction <- 1
    } else {  # Record extinction likelihood values for closely related
      close_extinction <-
        spec_extinction[which(dist[Species$Species[i], ] / 2 < iter
                              & dist[Species$Species[i], ] != 0)]
    }
    total_close_extinction <- prod(close_extinction, na.rm = TRUE)
    related_survival <- 1 - total_close_extinction
    prior_score[i] <- spec_extinction[i] * related_survival
  }

  prior_df[, t] <- prior_score
}

prior_df[, 101] <- rowMeans(prior_df[, 1:100], na.rm = T)

ordered_prior_df <- arrange(prior_df, desc(Average))

filename <- paste("ordered_prior_score_", iter, "mya.csv", sep = "")

write.csv(ordered_prior_df, file = filename)
