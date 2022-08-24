# # Script to calculate remaining species under extinction scenarios
source("extsim_functions.R")
set.seed(123)
sims <- 2
max_biobanked <- 1000
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))

# Check which scenario to calculate
if (iter %% 2 == 1) {
    taxa <- "bird"
} else if (iter %% 2 == 0) {
    taxa <- "mammal"
}

if (iter <= 20) {
    thresh <- 10
    count <- floor((iter + 1) / 2)
} else {
    thresh <- 2
    count <- floor((iter - 19) / 2)
}

# Load in the likelihood table
like <- read.csv(paste(taxa, "s_50_likelihoods.csv", sep = ""))

base_res <- run_sim(like, sims)

base_avg <- average_calc(base_res)

base_extinctions <- nrow(like) - sum(base_avg$survival)

print(paste(taxa, ":", base_extinctions))

# quick test of proper restoration check
priorities <- category_priority_builder(
    paste(taxa, "s_50_likelihoods.csv", sep = "")
)

bb <- seq(from = 0, to = max_biobanked, length.out = 101)
restoration <- matrix(nrow = sims, ncol = length(bb))
restoration <- sapply(bb, optimised_restoration_prioritised,
    sim_res = base_res, priorities = priorities, taxa = taxa, sims = sims,
    thresh = thresh)

write.csv(restoration, file = paste(count, iter, taxa, "cat", thresh, "mya.csv",
    sep = "_"), row.names = FALSE)
