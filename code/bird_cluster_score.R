# Script to calculate priority scores based on bird data

# Load in required libraries
library(jurassicpark)

# Read in job number (will serve as threshold / model selector)
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Load in data
load("cleaned_bird_trees_2020.RData")
models <- c("50", "500", "pessimistic")

# Select the model and threshold to use
if (iter %% 3 == 0) {
    model <- models[3]
} else {
    model <- models[iter %% 3]
}
threshold <- as.integer((iter + 2) / 3)

assign(paste("like", model, sep = "_"), read.csv(file =
    paste("birds", model, "likelihoods.csv", sep = "_")))

# Calculate the priority scores
prior_table <- prior_calc(bird.trees, thresh = threshold,
    species = get(paste("like", model, sep = "_"))$species,
    ext_like = get(paste("like", model, sep = "_")))

filename <- paste(model, "_score_", threshold, "mya.csv", sep = "")

write.csv(prior_table, file = filename)
