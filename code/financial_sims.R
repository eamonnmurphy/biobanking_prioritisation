# Script to perform financial simulations

# Load required libraries and external scripts
source("extsim_functions.R")

# Read in the data
expen <- read.csv("../data/cleaned_bird_downlist_expen.csv")

priorities <- read.csv("../results/25_may_bird_thresholds/50_score_10mya.csv")

like <- read.csv("../data/birds_50_likelihoods.csv")

matched_priorities <- priorities[priorities$X %in% expen$Species, ]

# Calculate the cost for downlist all species, split by priority
sims <- 2
n_extinctions <- rep(NA, nrow(matched_priorities))

for (i in seq_along(matched_priorities$X))  {
    prior_bb_like <- 
        prioritised_downlist(like, matched_priorities, i)

    prior_bb_res <- run_sim(prior_bb_like, sims)

    prior_bb_avg <- average_calc(prior_bb_res)

    n_extinctions[i] <- nrow(matched_priorities) - sum(prior_bb_avg$survival)
}
