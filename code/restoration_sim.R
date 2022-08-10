# # Script to calculate remaining species under extinction scenarios
source("extsim_functions.R")
set.seed(123)
sims <- 2
max_biobanked <- 1000
thresh <- 10
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Check which of four scenarios to calculate
if (iter == 1) {
    taxa <- "bird"
    type <- "random"
} else if (iter == 2) {
    taxa <- "bird"
    type <- "optimised"
} else if (iter == 3) {
    taxa <- "mammal"
    type <- "random"
} else if (iter == 4) {
    taxa <- "mammal"
    type <- "optimised"
}

# Load in the likelihood table
like <- read.csv(paste(taxa, "s_50_likelihoods.csv", sep = ""))

base_res <- run_sim(like, sims)

base_avg <- average_calc(base_res)

base_extinctions <- nrow(like) - sum(base_avg$survival)

print(paste(taxa, ":", base_extinctions))

# quick test of proper restoration check
if (taxa == "bird") {
    priorities <- priority_builder(paste("50_score_", thresh, "mya.csv",
        sep = ""))
} else if (taxa == "mammal") {
    priorities <- priority_builder(paste("ordered_prior_score_", thresh,
        "mya.csv", sep = ""))
}

bb <- seq(from = 0, to = max_biobanked, length.out = 101)
restoration <- matrix(nrow = sims, ncol = length(bb))
if (type == "random") {
    restoration <- sapply(bb, random_restoration_prioritised,
        sim_res = base_res, taxa = taxa, sims = sims, thresh = thresh)
} else if (type == "optimised") {
    restoration <- sapply(bb, optimised_restoration_prioritised,
        sim_res = base_res, priorities = priorities, taxa = taxa, sims = sims,
        thresh = thresh)
}

write.csv(restoration, file = paste(taxa, type, "restoration_scores.csv",
    sep = "_"), row.names = FALSE)
