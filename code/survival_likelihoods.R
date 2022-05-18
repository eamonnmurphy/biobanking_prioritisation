# Create a csv with converted survival likelihoods from GE status

# Load in necessary libraries
library(stringr)
library(jurassicpark)

# Precalculate survival and extinction likelihoods for mammals
load("../data/cleaned_mammal_trees_2020.RData")

mammals_50 <- likelihood_calc(Species$Species, Species$GE)

# Create a csv file to store the likelihoods
write.csv(mammals_50, file = "../data/mammals_50_likelihoods.csv",
      row.names = FALSE)

# Convert bird endangerment status for expenditure data
birds <- read.csv("../data/bird_downlisting_expenditure.csv", header = TRUE)

species <- str_replace_all(birds[, 2], "[^[:alnum:]]", "_")
species <- sub("_", "", species)

status <- birds[, 3]

birds_50 <- likelihood_calc(species, status)

write.csv(birds_50, file = "../data/birds_50_likelihoods.csv",
      row.names = FALSE)