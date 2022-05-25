# Script to clean provided data on species status
rm(list = ls())


##### Load required libraries

##### Load in data ######
load("../data/100_mammal_trees_with_2020_RL.RData")

for (i in 1:6253) {
  if (is.na(Species$GE[i]))
    Species$GE[i] <- 1
}

save(phy.block.1000, Species, file = "../data/cleaned_mammal_trees_2020.RData")

rm(list = ls())

load("../data/100_bird_trees_with_2020_RL.RData")

for (i in 1:length(bird.species$Species)) {
  if(is.na(bird.species$GE[i]))
    bird.species$GE[i] <- 1
}

save(bird.trees, bird.species, file = "../data/cleaned_bird_trees_2020.RData")