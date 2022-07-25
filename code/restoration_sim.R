# # Script to calculate remaining species under extinction scenarios
source("extsim_functions.R")
set.seed(123)
sims <- 10

# Base scenario
thresh <- 10
# Calculate no. of mammals surviving 50 year scenario
like <- read.csv("mammals_50_likelihoods.csv")

base_res <- run_sim(like, sims)

base_avg <- average_calc(base_res)

base_extinctions <- nrow(like) - sum(base_avg$survival)

print(base_extinctions)

# quick test of proper restoration check
max_biobanked <- 100
priorities <- priority_builder("ordered_prior_score_10mya.csv")
restoration <- matrix(nrow = max_biobanked, ncol = sims)
bb <- seq_len(max_biobanked)
restoration[, ] <- sapply(bb, optimised_restoration_prioritised,
    sim_res = base_res, priorities = priorities, taxa = "mammal", sims = sims,
    thresh = thresh)

# for (i in seq_len(max_biobanked)) {
#     restoration[i, ] <- optimised_restoration_prioritised(base_res, priorities,
#         taxa = "mammal", n = i, sims = sims, thresh = thresh)
#     print(i)
# }

write.csv(restoration, file = "mammal_restoration_scores.csv")
