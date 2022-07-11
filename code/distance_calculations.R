# Script to calculate all of the phylogenetic distances and store results

# Mammals first
load("cleaned_mammal_trees_2020.RData")

dist <- matrix(nrow = 6253, ncol = 6253)

for (i in seq_len(100)) {
    dist <- ape::cophenetic.phylo(phy.block.1000[[i]])
    write.csv(dist, file = paste(
        "mammal_dist_", 
        i, ".csv", sep = ""))
}

rm(list = ls())
# birds next
load("cleaned_bird_trees_2020.RData")

dist <- matrix(nrow = 10988, ncol = 10988)

for (i in seq_len(100)) {
    dist <- ape::cophenetic.phylo(bird.trees[[i]])
    write.csv(dist,file = paste(
        "bird_dist_", 
        i, ".csv", sep = ""))
}

rm(list = ls())
