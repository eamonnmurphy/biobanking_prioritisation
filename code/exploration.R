# Script to begin initial prioritisation index
rm(list = ls())

###### Load required libraries ########
library(ape)

####### Load in data #########
load("../data/cleaned_mammal_trees_2020.RData")
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
prior_score <- matrix(nrow = 6253, ncol = 6)
thresholds <- c(1,2,3,5,10,20)

for (j in 1:6) {
for (i in 1:6253) {
  if (sum(example_dist[i,] / 2 < thresholds[j] & example_dist[i,] != 0, na.rm = T) == 0) {
    close_extinction <- 1
  } else {
    close_extinction <- 
      spec_extinction[which(example_dist[Species$Species[i],] / 2 < 10 
                            & example_dist[Species$Species[i],] != 0)]
  }
  total_close_extinction <- prod(close_extinction, na.rm = TRUE)
  related_survival <- 1 - total_close_extinction
  prior_score[i,j] <- spec_extinction[i] * related_survival
}
}

averages <- rowMeans(prior_score)

prior_matrix <- data.frame(spec, prior_score, averages)
prior_matrix <- prior_matrix[order(prior_matrix[,8], decreasing = T),]

png("../results/thresholds_scores.png")
par(mfrow = c(2,3))
for (i in 1:6) {
  hist(prior_score[,i], xlim = c(0.2,1), ylim = c(0,500),
       main = paste("Threshold", thresholds[i], "mya"), xlab = "Priority score")
}
dev.off()

write.csv(prior_matrix, file = "../results/example_prior_matrix.csv")
write.csv(example_dist, file = "../results/example_dist_matrix.csv")

##### Assess the given prioritisation values
sum(Species$GE == 4, na.rm = T)
sum(prior_matrix[,2] == 0.97, na.rm = T)
