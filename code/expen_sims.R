# Script to simulate extinctions and expenditure per species saved
source("extsim_functions.R")
source("fin_functions.R")
set.seed(123)
sims <- 10

like <- read.csv("../data/birds_50_likelihoods.csv")

base_res <- run_sim(like, sims)

base_avg <- average_calc(base_res)

base_extinctions <- nrow(like) - sum(base_avg$survival)

magnitude <- 10 ^ seq(from = 0, to = 10, length.out = 11)
no <- seq(from = 1, to = 9, length.out = 9)
spend <- c(0)

for (i in seq_along(magnitude)) {
    spend <- append(spend, magnitude[i] * no)
}


dl_all_ext <- c(base_extinctions)

for (i in 2:length(spend)) {
    new_like <- prioritised_downlisting_conservation(like, spend[i])

    new_res <- run_sim(new_like, sims)

    new_avg <- average_calc(new_res)

    dl_extinctions <- nrow(new_like) - sum(new_avg$survival)

    dl_all_ext <- append(dl_all_ext, dl_extinctions)
}

result <- data.frame(spend, extinctions = dl_all_ext)
write.csv(result, "../results/conservation_spend_sim.csv", row.names = FALSE)

png("../results/expense_sims.png")
plot(log10(result$spend), result$extinctions)
graphics.off()