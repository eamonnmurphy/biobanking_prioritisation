# Script to simulate extinctions and expenditure per species saved
source("extsim_functions.R")
source("fin_functions.R")
library(tidyr)
set.seed(123)
sims <- 20

like <- read.csv("../data/birds_50_likelihoods.csv")

magnitude <- 10 ^ seq(from = 0, to = 11, length.out = 12)
no <- seq(from = 1, to = 9, length.out = 9)
spend <- c(0)

for (i in seq_along(magnitude)) {
    spend <- append(spend, magnitude[i] * no)
}

# Randomly sample the costs 
cost <- cost_assignment(like)

spend_col <- rep(spend, each = sims)

score <- dl_priorities(like, cost)

# Do in vectorised manner
random_new_ext <- rep(NA, 2 * length(spend))
random_new_ext <- sapply(spend, random_sim, like = like, cost = cost,
    sims = sims)

optim_new_ext <- rep(NA, 2 * length(spend))
optim_new_ext <- sapply(spend, optim_sim, like = like, cost = cost,
    score = score, sims = sims)

result <- data.frame(spend = spend_col, optim_downlist =
    pivot_longer(data.frame(t(optim_new_ext)), cols = seq(1, sims))$value,
    random_downlist =
    pivot_longer(data.frame(t(random_new_ext)), cols = seq(1, sims))$value)

write.csv(result, "../results/conservation_spend_sim.csv", row.names = FALSE)