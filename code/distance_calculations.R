# Script to calculate all of the phylogenetic distances and store results

# Mammals first
load("../data/cleaned_mammal_trees_2020.RData")

dist <- matrix(nrow = 6253, ncol = 6253)

for (i in seq_len(100)) {
    dist <- ape::cophenetic.phylo(phy.block.1000[[i]])
    
}