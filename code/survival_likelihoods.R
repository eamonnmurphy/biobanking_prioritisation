# Create a csv with converted survival likelihoods from GE status

# Load in necessary libraries
library(stringr)
library(jurassicpark)

# Precalculate survival and extinction likelihoods for mammals
load("../data/cleaned_mammal_trees_2020.RData")

mammals_50 <- likelihood_calc(Species$Species, Species$GE)
mammals_500 <- likelihood_calc(Species$Species, Species$GE,
      model = "iucn_500_years")
mammals_pessimistic <- likelihood_calc(Species$Species, Species$GE,
      model = "pessimistic")

# Create a csv file to store the likelihoods
write.csv(mammals_50, file = "../data/mammals_50_likelihoods.csv",
      row.names = FALSE)
write.csv(mammals_500, file = "../data/mammals_500_likelihoods.csv",
      row.names = FALSE)
write.csv(mammals_pessimistic,
      file = "../data/mammals_pessimistic_likelihoods.csv", row.names = FALSE)

# Convert bird endangerment status for expenditure data
load("../data/cleaned_bird_trees_2020.RData")

birds_50 <- likelihood_calc(bird.species$Species, bird.species$GE)
birds_500 <- likelihood_calc(bird.species$Species, bird.species$GE,
      model = "iucn_500_years")
birds_pessimistic <- likelihood_calc(bird.species$Species, bird.species$GE,
      model = "pessimistic")

# Create a csv file to store the likelihoods
write.csv(birds_50, file = "../data/birds_50_likelihoods.csv",
      row.names = FALSE)
write.csv(birds_500, file = "../data/birds_500_likelihoods.csv",
      row.names = FALSE)
write.csv(birds_pessimistic,
      file = "../data/birds_pessimistic_likelihoods.csv", row.names = FALSE)



# birds <- read.csv("../data/bird_downlisting_expenditure.csv", header = TRUE)

# species <- str_replace_all(birds[, 2], "[^[:alnum:]]", "_")
# species <- sub("_", "", species)

# status <- birds[, 3]

# birds_50 <- likelihood_calc(species, status)

# write.csv(birds_50, file = "../data/birds_50_likelihoods.csv",
#       row.names = FALSE)