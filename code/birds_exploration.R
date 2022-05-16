# Script to begin initial prioritisation index
rm(list = ls())

###### Load required libraries ########
library(ape)

####### Load in data #########
example <- read.tree("../data/example_bird.tre")
likelihoods <- read.csv("../data/selected_birds_likelihoods.csv", header = TRUE)

# Check if all of the cost assessed birds have a corresponding phylogeny entry
length(likelihoods$Species) == sum(likelihoods$Species %in% example$tip.label)

# Calculate distances between species
example_dist <- cophenetic.phylo(example)

# Number of species in table
no_spec <- length(likelihoods$Species)

# Calculate prioritisation index
prior_score <- rep(NA, no_spec)

for (i in 1:no_spec) {
  spec <- likelihoods$Species[i]
  if (sum(example_dist[spec, ] / 2 < 10 & example_dist[spec, ] != 0,
      na.rm = T) == 0) {
    close_extinction <- 1
  } else {
    close_extinction <-
      likelihoods$Extinction[which(example_dist[spec, ] / 2 < 10
        & example_dist[spec, ] != 0)]
  }
  total_close_extinction <- prod(close_extinction, na.rm = TRUE)
  related_survival <- 1 - total_close_extinction
  prior_score[i] <- likelihoods$Extinction * related_survival
}

averages <- rowMeans(prior_score)

prior_matrix <- data.frame(spec, prior_score, averages)
prior_matrix <- prior_matrix[order(prior_matrix[, 8], decreasing = T), ]

png("../results/thresholds_scores.png")
par(mfrow = c(2, 3))
for (i in 1:6) {
  hist(prior_score[, i], xlim = c(0.2, 1), ylim = c(0, 500),
       main = paste("Threshold", thresholds[i], "mya"), xlab = "Priority score")
}
dev.off()

write.csv(prior_matrix, file = "../results/example_prior_matrix.csv")
write.csv(example_dist, file = "../results/example_dist_matrix.csv")

##### Assess the given prioritisation values
sum(Species$GE == 4, na.rm = T)
sum(prior_matrix[, 2] == 0.97, na.rm = T)
