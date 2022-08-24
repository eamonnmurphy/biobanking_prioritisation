# One script to generate figures for final report
# Figure for priority score histograms
library(ggplot2)
library(ggpubr)

like_mammal_50 <- read.csv("../data/mammals_50_likelihoods.csv", header = TRUE)
like_mammal_500 <- read.csv("../data/mammals_500_likelihoods.csv",
    header = TRUE)
like_mammal_pessimistic <-
    read.csv("../data/mammals_pessimistic_likelihoods.csv", header = TRUE)

like_bird_50 <- read.csv("../data/birds_50_likelihoods.csv", header = TRUE)
like_bird_500 <- read.csv("../data/birds_50_likelihoods.csv", header = TRUE)
like_bird_pessimistic <- read.csv("../data/birds_pessimistic_likelihoods.csv",
    header = TRUE)

rs_bird_50 <- read.csv("../results/related_survival/bird_50_rs_10mya.csv",
    row.names = 1)
rs_bird_500 <- read.csv("../results/related_survival/bird_500_rs_10mya.csv",
    row.names = 1)
rs_bird_pessimistic <- read.csv(
    "../results/related_survival/bird_pessimistic_rs_10mya.csv",
    row.names = 1)
rs_mammal_50 <- read.csv("../results/related_survival/mammal_50_rs_10mya.csv",
    row.names = 1)
rs_mammal_500 <- read.csv("../results/related_survival/mammal_500_rs_10mya.csv",
    row.names = 1)
rs_mammal_pessimistic <- read.csv(
    "../results/related_survival/mammal_pessimistic_rs_10mya.csv",
    row.names = 1)

plot_ext_like <- function(taxa, model) {
    values <- get(paste("like_", taxa, "_", model, sep = ""))
    if (model == "pessimistic") {
        name <- paste("Extinction likelihoods, ", model, " model", sep = "")
    } else {
        name <- paste("Extinction likelihoods, ", model, " year model",
            sep = "")
    }

    hist(values$extinction, xlab = "Likelihood of extinction",
        ylab = "Number of species", main = "", xlim = c(0, 1))
}

plot_ps <- function(taxa, model, threshold = 10) {
    values <- read.csv(paste("../results/", taxa, "_ps/", model,
        "_score_", threshold, "mya.csv", sep = ""))
    if (model == "pessimistic") {
        name <- "Pessimistic model"
    } else {
        name <- paste("IUCN", model, "year model", sep = " ")
    }
    if (taxa == "mammal") {
        ys <- c(0, 6000)
    } else {
        ys <- c(0, 10000)
    }

    hist(values[, 101], xlab = "Priority Score", breaks = 20,
        ylab = "Number of species", main = "",  xlim = c(0, 1), ylim = ys)
}

plot_rs <- function(taxa, model) {
    values <- get(paste("rs", taxa, model, sep = "_"))
    if (taxa == "mammal") {
        ys <- c(0, 6000)
    } else {
        ys <- c(0, 7000)
    }

    hist(values$average, xlab = "Probability of compatible relative surviving",
        breaks = 20, ylab = "Number of species", main = NULL,
        ylim = ys)
}

taxa <- c("mammal", "bird")
model <- c("50", "500", "pessimistic")

for (i in seq_along(taxa)) {
    pdf(file = paste("../results/", taxa[i], "_combined_hist.pdf", sep = ""),
        pointsize = 11)
    par(mfcol = c(2, 3), mar = c(5.1, 4.1, 6.1, 1.1))
    for (j in seq_along(model)) {
        plot_ps(taxa[i], model[j])
        if (model[j] == "pessimistic") {
            mtext("Pessimistic model")
        } else {
            mtext(paste("IUCN", model[j], "year model", sep = " "))
        }
        # if (i == 1 & j == 2) {
        #     mtext("Mammals", line = 2, cex = 1.5)
        # }
        # if (i == 2 & j == 2) {
        #     mtext("Birds", line = 2, cex = 1.5)
        # }
        pplt <- par("plt")
        adjx <- (0 - pplt[1]) / (pplt[2] - pplt[1])
        liney <- 1
        # if (i == 1) {
            mtext(LETTERS[j], adj = adjx, line = liney)
        # } else if (i == 2) {
        #     mtext(LETTERS[j + 3], adj = adjx, line = liney)
        # }
        plot_rs(taxa[i], model[j])
        if (model[j] == "pessimistic") {
            mtext("Pessimistic model")
        } else {
            mtext(paste("IUCN", model[j], "year model", sep = " "))
        }

        pplt <- par("plt")
        adjx <- (0 - pplt[1]) / (pplt[2] - pplt[1])
        liney <- 1

        mtext(LETTERS[j + 3], adj = adjx, line = liney)

    }
    graphics.off()
}

##### Figure for related survival histograms ####


par(mfcol = c(2, 3), mar = c(5.1, 4.1, 6.1, 1.1))
hist(rs_mammal_50$average, ylim = c(0, 6000), breaks = 20)
hist(rs_mammal_500$average, ylim = c(0, 6000), breaks = 20)
hist(rs_mammal_pessimistic$average, ylim = c(0, 6000), breaks = 20)

hist(rs_bird_50$average, ylim = c(0, 7000), breaks = 20)
hist(rs_bird_500$average, ylim = c(0, 7000), breaks = 20)
hist(rs_bird_pessimistic$average, ylim = c(0, 7000), breaks = 20)

#### Varying thresholds visualisation ####
bird_table <- read.csv("../results/bird_threshold_table.csv", row.names = 1)
mammal_table <- read.csv("../results/mammal_threshold_table.csv", row.names = 1)
pdf("../results/threshold_viz.pdf", height = 9, width = 6, pointsize = 11)
par(mfcol = c(2, 1))

# Plot the mammal table
plot(mammal_table$fifty_year, type = "l", xlab = "Threshold for MRCA (mya)",
    ylim = c(0, 701), ylab = "No. of species", col = "blue")

lines(mammal_table$fivehundred_year, col = "#6c3092")
lines(mammal_table$pessimistic, col = "red")

abline(h = 199, col = "black", lty = 2)
text(x = 10, y = 239, "Critically endangered mammal species")

legend(x = 11, y = 600, legend = c("IUCN 50 year model",
    "IUCN 500 year model", "Pessimistic scenario"), col = c("blue", "purple",
        "red"), lty = 1, box.col = "white")

pplt <- par("plt")
adjx <- (0 - pplt[1]) / (pplt[2] - pplt[1])
liney <- 1
mtext("A", adj = adjx, line = liney, cex = 1.2)

# Plot the bird results
plot(bird_table$fifty_year, type = "l", xlab = "Threshold for MRCA (mya)",
    ylim = c(0, 691), ylab = "No. of species", col = "blue")

lines(bird_table$fivehundred_year, col = "#6c3092")
lines(bird_table$pessimistic, col = "red")

abline(h = 230, col = "black", lty = 2)
text(x = 10, y = 270, "Critically endangered bird species")

legend(x = 11, y = 600, legend = c("IUCN 50 year model",
    "IUCN 500 year model", "Pessimistic scenario"), col = c("blue", "purple",
        "red"), lty = 1, box.col = "white")

pplt <- par("plt")
adjx <- (0 - pplt[1]) / (pplt[2] - pplt[1])
liney <- 1
mtext("B", adj = adjx, line = liney, cex = 1.2)

graphics.off()


###### Restoration simulations ######
# Mammals
mammal_random_rest <-
    read.csv("../results/mammal_random_restoration_scores.csv")
mammal_optim_rest <-
    read.csv("../results/mammal_optimised_restoration_scores.csv")
mammal_cat_rest <-
    read.csv("../results/cat_10/mammal_cat_restoration_scores.csv")

bird_random_rest <-
    read.csv("../results/bird_random_restoration_scores.csv")
bird_optim_rest <-
    read.csv("../results/bird_optimised_restoration_scores.csv")
bird_cat_rest <-
    read.csv("../results/cat_10/bird_cat_restoration_scores.csv")

pdf("../results/restoration.pdf")

par(mfcol = c(1, 2))

plot(seq(0, 1000, by = 10), mammal_random_rest[1, ], xlim = c(0, 1000),
    ylim = c(0, 500), xlab = "Number of species biobanked",
    ylab = "Number of species restored",
    main = "Mammal restoration")
points(seq(0, 1000, by = 10), mammal_random_rest[2, ])

points(seq(0, 1000, by = 10), mammal_optim_rest[1, ], col = "red")
points(seq(0, 1000, by = 10), mammal_optim_rest[2, ], col = "red")

points(seq(0, 1000, by = 10), mammal_cat_rest[1, ], col = "blue")
points(seq(0, 1000, by = 10), mammal_cat_rest[2, ], col = "blue")

legend(x = "topright", legend = c("Random biobanking", "Optimised biobanking"),
    col = c("black", "red"), pch = 1)

plot(seq(0, 1000, by = 10), bird_random_rest[1, ], xlim = c(0, 1000),
    ylim = c(0, 500), xlab = "Number of species biobanked",
    ylab = "Number of species restored",
    main = "Bird restoration")
points(seq(0, 1000, by = 10), bird_random_rest[2, ])

points(seq(0, 1000, by = 10), bird_optim_rest[1, ], col = "red")
points(seq(0, 1000, by = 10), bird_optim_rest[2, ], col = "red")

points(seq(0, 1000, by = 10), bird_cat_rest[1, ], col = "blue")
points(seq(0, 1000, by = 10), bird_cat_rest[2, ], col = "blue")

legend(x = "topright", legend = c("Random biobanking", "Optimised biobanking"),
    col = c("black", "red"), pch = 1)

graphics.off()


#### Conservation cost simulations ####
con_spend <- read.csv("../results/conservation_spend_sim.csv")

pdf("../results/log_expense_sims.pdf")
par(mfcol = c(1, 2))
plot(log10(con_spend$spend), con_spend$optim_downlist,
    xlab = "Log10 of dedicated conservation spending (US $)",
    ylab = "No. of extinctions in a 50 year period")
points(log10(con_spend$spend), con_spend$random_downlist, col = "red")
legend(x = "bottomleft", legend = c("Optimised", "Random"),
    col = c("black", "red"), pch = 1)
abline(v = log10(9e+08), col = "black", lty = 2)
abline(v = log10(6e+10), col = "red", lty = 2)

plot(con_spend$spend, con_spend$optim_downlist,
    xlab = "Dedicated conservation spending (US $)",
    ylab = "No. of extinctions in a 50 year period")
points(con_spend$spend, con_spend$random_downlist, col = "red")
legend(x = "topright", legend = c("Optimised", "Random"),
    col = c("black", "red"), pch = 1)
graphics.off()