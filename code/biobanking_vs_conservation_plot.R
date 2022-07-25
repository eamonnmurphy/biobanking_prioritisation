# Script to plot the results of biobanking simulations vs conservations sims

restoration <- read.csv("../results/mammal_restoration_scores.csv", row.name = 1)
con_spend <- read.csv("../results/conservation_spend_sim.csv")

million_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
    which(con_spend$spend == 1000000)])

ten_million_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
    which(con_spend$spend == 10000000)])

hun_mill_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
    which(con_spend$spend == 100000000)])

billion_saving <- max(con_spend$extinctions) - max(con_spend$extinctions[
    which(con_spend$spend == 1000000000)])

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