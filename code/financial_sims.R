# Script to perform financial simulations

# Load required libraries and external scripts
source("extsim_functions.R")

# Read in the data
expen <- read.csv("../data/cleaned_bird_downlist_expen.csv")

priorities <- 
    priority_builder("../results/25_may_bird_thresholds/50_score_10mya.csv")

like <- read.csv("../data/birds_50_likelihoods.csv")

matched_priorities <- priorities[priorities$species %in% expen$Species, ]

# Calculate the cost for downlist all species, split by priority
sims <- 10
n_extinctions <- rep(NA, nrow(matched_priorities))

for (i in seq_along(matched_priorities$species))  {
    prior_bb_like <- 
        prioritised_biobank(like, matched_priorities, i)

    prior_bb_res <- run_sim(prior_bb_like, sims)

    prior_bb_avg <- average_calc(prior_bb_res)

    n_extinctions[i] <- nrow(like) - sum(prior_bb_avg$survival)
}

# Same but with downlisting species rather than eliminating risk
sims <- 10
new_n_extinctions <- rep(NA, nrow(matched_priorities))

for (i in seq_along(matched_priorities$species))  {
    prior_bb_like <- 
        prioritised_downlist(like, matched_priorities, i)

    prior_bb_res <- run_sim(prior_bb_like, sims)

    prior_bb_avg <- average_calc(prior_bb_res)

    new_n_extinctions[i] <- nrow(like) - sum(prior_bb_avg$survival)
}

barplot(new_n_extinctions)

# Calculate and plot the expenditure
needed_expen <- rep(NA, nrow(matched_priorities))
curr_sum <- 0

for (i in seq_len(nrow(matched_priorities))) {
    curr_sum <- curr_sum +
        expen$Required.Expenditure..US..[
            which(expen$Species == matched_priorities$species[i])]
    
    needed_expen[i] <- curr_sum
}

plot(new_n_extinctions, needed_expen, xlab = "Number of extinctions",
    ylab = "Total cost to downlist from expert survey")