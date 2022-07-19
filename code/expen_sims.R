# Script to simulate extinctions and expenditure per species saved
source("extsim_functions.R")
source("fin_functions.R")
set.seed(123)
sims <- 10

like <- read.csv("../data/birds_50_likelihoods.csv")

base_res <- run_sim(like, sims)

base_avg <- average_calc(base_res)

base_extinctions <- nrow(like) - sum(base_avg$survival)

spend <- c()

dl_all_ext <- c()

for (i in 1:11) {
    spend <- append(spend, 1 * (10 ^ i))

    new_like <- prioritised_downlisting_conservation(like, spend[i])

    new_res <- run_sim(like, sims)

    new_avg <- average_calc(new_res)

    dl_extinctions <- nrow(like) - sum(new_avg$survival)

    dl_all_ext <- append(dl_all_ext, dl_extinctions)
}