# Script to convert the distance matrices into likelihoods of usefulness
rm(list = ls())

### Load the required packages

# Load in example data
dist <- read.csv("../results/example_dist_matrix.csv", header = T, row.names = 1)

likelihood <- matrix(1.071773463 ^ (-dist / 2))
