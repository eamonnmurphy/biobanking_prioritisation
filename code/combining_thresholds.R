# Script to combine results from various thresholds

# Load in necessary libraries
library(dplyr)
library(plotrix)
library(ape)

# Load in data
file_list <- list.files("../results/mammal_thresholds/", pattern = "*.csv")
thresh_results <- lapply(paste("../results/mammal_thresholds/",
                    file_list, sep = ""), read.csv, row.names = 1)

thresh <- array(unlist(thresh_results), dim = c(6253, 101, 20))

# List species names
species <- rownames(thresh_results[[1]])

# Average results across thresholds
scores <- thresh[, 101, ]

means <- apply(scores, 1, mean)

results <- data.frame(species, means)

ordered <- arrange(results, desc(means))

# Attempt to produce color scale tree
load("../data/cleaned_mammal_trees_2020.RData")
example <- phy.block.1000[[1]]

colfunc <- colorRampPalette(c("red", "yellow", "black"))
scale <- colfunc(10)
tip_col <- rep(scale[10], length(species))

spec_order <- ordered[match(example$tip.label, ordered$species), ]

for (i in seq_len(9)) {
    tip_col <- ifelse(spec_order$means > i * 0.1, scale[10 - i], tip_col)
}

#plot(ordered$means, col = tip_col)

png(filename = "../results/mammal_colored_tree.png",
    width = 9600, height = 9600)
plot.phylo(example, tip.col = tip_col, no.margin = TRUE, type = "fan")
dev.off()

######### Replicate for birds #########
thresh_results <- lapply(paste("../results/25_may_bird_thresholds/50_score_",
                    seq_len(20), "mya.csv", sep = ""), read.csv, row.names = 1)

thresh <- array(unlist(thresh_results), dim = c(10988, 101, 20))

# List species names
species <- rownames(thresh_results[[1]])

# Average results across thresholds
scores <- thresh[, 101, ]

means <- apply(scores, 1, mean)

weight_mean <- function(scores, weights = seq(0.05, 1, length.out = 20)) {
    weighted <- sum(scores * weights) / sum(weights)
    return(weighted)
}

weighted_means <- apply(scores, 1, weight_mean)

results <- data.frame(species, means, weighted_means)

ordered <- arrange(results, desc(weighted_means))

# Attempt to produce color scale tree
load("../data/cleaned_bird_trees_2020.RData")
example <- bird.trees[[1]]

colfunc <- colorRampPalette(c("red", "yellow", "black"))
scale <- colfunc(10)
tip_col <- rep(scale[10], length(species))

spec_order <- results[match(example$tip.label, results$species), ]

for (i in seq_len(9)) {
    tip_col <- ifelse(spec_order$means > i * 0.1, scale[10 - i], tip_col)
}

#plot(ordered$means, col = tip_col)

png(filename = "../results/bird_colored_tree.png", width = 9600, height = 9600)
plot.phylo(example, tip.col = tip_col, no.margin = TRUE, type = "fan")
dev.off()