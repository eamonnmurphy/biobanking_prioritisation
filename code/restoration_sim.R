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
for (i in seq_len(max_biobanked)) {
    restoration[i, ] <- optimised_restoration_prioritised(base_res, priorities,
        taxa = "mammal", n = i, sims = sims, thresh = thresh)
    print(i)
}

write.csv(restoration, file = "mammal_restoration_scores.csv")

# # Random biobanking scenario with 100 saved
# rand_like <- rand_biobank(like, 100)

# rand_res <- run_sim(rand_like, sims)

# rand_avg <- average_calc(rand_res)

# rand_extinctions <- nrow(like) - sum(rand_avg$survival)

# print(rand_extinctions)

# # Random downlisting scenario with 100 saved
# rand_bb_like <- rand_downlist(like, 100)

# rand_bb_res <- run_sim(rand_bb_like, sims)

# rand_bb_avg <- average_calc(rand_bb_res)

# rand_bb_extinctions <- nrow(like) - sum(rand_bb_avg$survival)

# print(rand_bb_extinctions)

# # Prioritised biobanking scenario with 100 saved
# priorities <- priority_builder(
#     "../results/mammal_thresholds/ordered_prior_score_10mya.csv")

# prior_like <- prioritised_biobank(like, priorities, 100)

# prior_res <- run_sim(prior_like, sims)

# prior_avg <- average_calc(prior_res)

# prior_extinctions <- nrow(like) - sum(prior_avg$survival)

# print(prior_extinctions)

# # Prioritised downlisting scenario with 100 saved
# prior_bb_like <- prioritised_downlist(like, priorities, 100)

# prior_bb_res <- run_sim(prior_bb_like, sims)

# prior_bb_avg <- average_calc(prior_bb_res)

# prior_bb_extinctions <- nrow(like) - sum(prior_bb_avg$survival)

# print(prior_bb_extinctions)
