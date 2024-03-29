# Script to plot the results of biobanking simulations vs conservations sims

con_spend <- read.csv("../results/conservation_spend_sim.csv")

png("../results/log_expense_sims.png")
plot(log10(con_spend$spend), con_spend$optim_downlist,
    xlab = "Log10 of dedicated conservation spending (US $)",
    ylab = "No. of extinctions in a 50 year period")
points(log10(con_spend$spend), con_spend$random_downlist, col = "red")
legend(x = "bottomleft", legend = c("Optimised", "Random"),
    col = c("black", "red"), pch = 1)
abline(v = log10(9e+08), col = "black", lty = 2)
abline(v = log10(6e+10), col = "red", lty = 2)
graphics.off()

png("../results/expense_sims.png")
plot(con_spend$spend, con_spend$optim_downlist,
    xlab = "Dedicated conservation spending (US $)",
    ylab = "No. of extinctions in a 50 year period")
points(con_spend$spend, con_spend$random_downlist, col = "red")
legend(x = "topright", legend = c("Optimised", "Random"),
    col = c("black", "red"), pch = 1)
graphics.off()

# million_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
#     which(con_spend$spend == 1000000)])

# ten_million_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
#     which(con_spend$spend == 10000000)])

# hun_mill_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
#     which(con_spend$spend == 100000000)])

# billion_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
#     which(con_spend$spend == 1000000000)])

restoration <- read.csv("../results/mammal_restoration_scores.csv",
    row.name = 1)

random_rest <- read.csv("../results/mammal_random_restoration_scores.csv")
optim_rest <- read.csv("../results/mammal_optimised_restoration_scores.csv")

png("../restoration/prior_bb_results.png")

for (i in seq_len(nrow(restoration))) {
    x <- rep(i, ncol(restoration))
    if (i == 1) {
        plot(x, restoration[i, ], xlim = c(0, 100), ylim = c(0, max(restoration)),
            xlab = "No. of species biobanked",
            ylab = "No. of species restored",
            main = "Results of restoration simulation for mammals")
    } else {
    points(x, restoration[i, ])
    }
}

graphics.off()

png("../results/mammal_restoration.png")

plot(seq(0, 1000, by = 10), random_rest[1, ], xlim = c(0, 1000), ylim = c(0, 1000))
points(seq(0, 1000, by = 10), random_rest[2, ])

points(seq(0, 1000, by = 10), optim_rest[1, ], col = "red")
points(seq(0, 1000, by = 10), optim_rest[2, ], col = "red")

graphics.off()


random_rest <- read.csv("../results/bird_random_restoration_scores.csv")
optim_rest <- read.csv("../results/bird_optimised_restoration_scores.csv")

plot(seq(0, 1000, by = 10), random_rest[1, ], xlim = c(0, 1000), ylim = c(0, 1000))
points(seq(0, 1000, by = 10), random_rest[2, ])

points(seq(0, 1000, by = 10), optim_rest[1, ], col = "red")
points(seq(0, 1000, by = 10), optim_rest[2, ], col = "red")
