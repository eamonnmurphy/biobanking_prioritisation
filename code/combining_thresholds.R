# Script to combine results from various thresholds

# Load in necessary libraries
library(dplyr)

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