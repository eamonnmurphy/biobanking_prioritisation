# Script to simulate extinctions and expenditure per species saved
source("extsim_functions.R")
source("fin_functions.R")
set.seed(123)
sims <- 2

like <- read.csv("../data/birds_50_likelihoods.csv")

base_res <- run_sim(like, sims)

base_avg <- average_calc(base_res)

base_extinctions <- nrow(like) - sum(base_avg$survival)

magnitude <- 10 ^ seq(from = 6, to = 11, length.out = 6)
no <- seq(from = 1, to = 9, length.out = 9)
spend <- c(0)

for (i in seq_along(magnitude)) {
    spend <- append(spend, magnitude[i] * no)
}

# Randomly sample the costs 
cost <- cost_assignment(like)

random_all_ext <- c(base_extinctions)

for (i in 2:length(spend)) {
    new_like <- random_dl_conservation(like, spend[i], cost)

    new_res <- run_sim(new_like, sims)

    new_avg <- average_calc(new_res)

    dl_extinctions <- nrow(new_like) - sum(new_avg$survival)

    random_all_ext <- append(random_all_ext, dl_extinctions)
}

optim_all_ext <- c(base_extinctions)

score <- dl_priorities(like, cost)

for (i in 2:length(spend)) {
    new_like <- optim_dl_conservation(like, spend[i], cost, score)

    new_res <- run_sim(new_like, sims)

    new_avg <- average_calc(new_res)

    dl_extinctions <- nrow(new_like) - sum(new_avg$survival)

    optim_all_ext <- append(optim_all_ext, dl_extinctions)
}

result <- data.frame(spend, random_downlist = random_all_ext,
    optim_downlist = optim_all_ext)
write.csv(result, "../results/conservation_spend_sim.csv", row.names = FALSE)

png("../results/log_expense_sims.png")
plot(log10(result$spend), result$optim_downlist,
    xlab = "Log10 of dedicated conservation spending (US $)",
    ylab = "No. of extinctions in a 50 year period")
points(log10(result$spend), result$random_downlist, col = "red")
graphics.off()

png("../results/expense_sims.png")
plot(result$spend, result$optim_downlist,
    xlab = "Dedicated conservation spending (US $)",
    ylab = "No. of extinctions in a 50 year period")
points(result$spend, result$random_downlist, col = "red")
graphics.off()