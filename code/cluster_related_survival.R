# Script to calculate priority scores based on bird data

# Load in required libraries
source("related_survival_functions.R")

# Read in job number (will serve as threshold / model selector)
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Load in data

if (iter %% 2 == 0) {
    taxa <- "bird"
} else if (iter %% 2 == 1) {
    taxa <- "mammal"
}

models <- c("50", "500", "pessimistic")

# Select the model and threshold to use
if (iter %% 3 == 0) {
    model <- models[3]
} else {
    model <- models[iter %% 3]
}

load(paste("cleaned_", taxa, "_trees_2020.RData", sep = ""))

threshold <- 10

assign(paste("like", model, sep = "_"), read.csv(file =
    paste(taxa, "s_", model, "_likelihoods.csv", sep = "")))

# Calculate the priority scores
if (taxa == "mammal") {
    prior_table <- prior_calc(phy.block.1000, thresh = threshold,
        species = get(paste("like", model, sep = "_"))$species,
        ext_like = get(paste("like", model, sep = "_")))
} else if (taxa == "bird") {
    prior_table <- prior_calc(bird.species, thresh = threshold,
        species = get(paste("like", model, sep = "_"))$species,
        ext_like = get(paste("like", model, sep = "_")))
}

filename <- paste(taxa, "_",
    model, "_rs_", threshold, "mya.csv", sep = "")

write.csv(prior_table, file = filename)
