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
        name <- paste("Prioritisation scores, ", model, " model", sep = "")
    } else {
        name <- paste("Prioritisation scores, ", model, " year model",
            sep = "")
    }

    hist(values[, 101], xlab = "Prioritisation score",
        ylab = "Number of species", main = "",  xlim = c(0, 1))
}

taxa <- c("mammal", "bird")
model <- c("50", "500", "pessimistic")

png(filename = "../results/combined_hist.png")
par(mfrow = c(3, 4))
for (i in seq_along(model)) {
    for (j in seq_along(taxa)) {
        plot_ext_like(taxa[j], model[i])
        if (model[i] == "50") {
            mtext("Extinction likelihoods")
        }
        if (taxa[j] == "mammal") {
            if (model[i] == "pessimistic") {
                mtext(paste(model, " model", sep = ""), side = 2, outer = TRUE)
            } else {
                mtext(paste(model, " year model", sep = ""), side = 2, outer = TRUE)
            }
        }
        plot_ps(taxa[j], model[i])
        if (model[i] == "50") {
            mtext("Priority scores")
        }
    }
}
graphics.off()

p <- ggplot(like_mammal_50, aes(x = extinction)) + geom_histogram() +
    scale_y_sqrt()

q <- ggplot(mammal_10mya, aes(x = average)) + geom_histogram() +
    scale_y_sqrt()

fig <- ggarrange(yo[[1]], yo[[2]])

plot_ext_like <- function(taxa, model) {
    values <- get(paste("like_", taxa, "_", model, sep = ""))
    if (model == "pessimistic") {
        name <- paste("Extinction likelihoods, ", model, " model", sep = "")
    } else {
        name <- paste("Extinction likelihoods, ", model, " year model",
            sep = "")
    }

    p <- ggplot(values, aes(x = extinction)) + geom_histogram() +
        scale_y_sqrt()
    
    return(p)
}

plot_ps <- function(taxa, model, threshold = 10) {
    values <- read.csv(paste("../results/", taxa, "_ps/", model,
        "_score_", threshold, "mya.csv", sep = ""))
    if (model == "pessimistic") {
        name <- paste("Prioritisation scores, ", model, " model", sep = "")
    } else {
        name <- paste("Prioritisation scores, ", model, " year model",
            sep = "")
    }

    p <- ggplot(values, aes(x = average)) + geom_histogram() +
        scale_y_sqrt()
    
    return(p)
}

taxa <- c("mammal", "bird")
model <- c("50", "500", "pessimistic")

png(filename = "../results/combined_hist.png")
par(mfrow = c(3, 4))
ext <- list()
ps <- list()
num <- 1
for (i in seq_along(model)) {
    for (j in seq_along(taxa)) {
        ext[[num]] <- plot_ext_like(taxa[j], model[i])
        ps[[num]] <- plot_ps(taxa[j], model[i])
        num <- num + 1
    }
}

fig <- ggarrange(ext[[1]], ps[[1]], ext[[2]], ps[[2]], ext[[3]], ps[[3]],
    ext[[4]], ps[[4]], ext[[5]], ps[[5]], ext[[6]], ps[[6]])
graphics.off()


#### Varying thresholds visualisation ####
bird_table <- read.csv("../results/bird_threshold_table.csv", row.names = 1)
mammal_table <- read.csv("../results/mammal_threshold_table.csv", row.names = 1)
png(filename = "../results/threshold_viz.png", height = 720)
par(mfcol = c(2, 1))

# Plot the mammal table
plot(mammal_table$fifty_year, type = "l", xlab = "Threshold for MRCA (mya)",
    ylim = c(0, 1000), ylab = "No. of species", col = "blue")

lines(mammal_table$fivehundred_year, col = "#6c3092")
lines(mammal_table$pessimistic, col = "red")

abline(h = 199, col = "black", lty = 2)
text(x = 10, y = 250, "Critically endangered mammal species")
abline(h = 701, col = "black", lty = 2)
text(x = 10, y = 711, "Endangered and critically endangered mammal species")

legend(x = "topright", legend = c("IUCN 50 year model",
    "IUCN 500 year model", "Pessimistic scenario"), col = c("blue", "purple",
        "red"), lty = 1)

mtext("A", line = 1)

# Plot the bird results
plot(bird_table$fifty_year, type = "l", xlab = "Threshold for MRCA (mya)",
    ylim = c(0, 1000), ylab = "No. of species", col = "blue")

lines(bird_table$fivehundred_year, col = "#6c3092")
lines(bird_table$pessimistic, col = "red")

abline(h = 230, col = "black", lty = 2)
text(x = 10, y = 250, "Critically endangered bird species")
abline(h = 691, col = "black", lty = 2)
text(x = 10, y = 711, "Endangered and critically endangered bird species")

legend(x = "topright", legend = c("IUCN 50 year model",
    "IUCN 500 year model", "Pessimistic scenario"), col = c("blue", "purple",
        "red"), lty = 1)

mtext("B", line = 1)

graphics.off()


###### Restoration simulations ######
# Mammals
mammal_random_rest <-
    read.csv("../results/mammal_random_restoration_scores.csv")
mammal_optim_rest <-
    read.csv("../results/mammal_optimised_restoration_scores.csv")

bird_random_rest <-
    read.csv("../results/bird_random_restoration_scores.csv")
bird_optim_rest <-
    read.csv("../results/bird_optimised_restoration_scores.csv")

png("../results/restoration.png", width = 960)

par(mfcol = c(1, 2))

plot(seq(0, 1000, by = 10), mammal_random_rest[1, ], xlim = c(0, 1000),
    ylim = c(0, 1000), xlab = "Number of species biobanked",
    ylab = "Number of species restored",
    main = "Mammal restoration")
points(seq(0, 1000, by = 10), mammal_random_rest[2, ])

points(seq(0, 1000, by = 10), mammal_optim_rest[1, ], col = "red")
points(seq(0, 1000, by = 10), mammal_optim_rest[2, ], col = "red")

legend(x = "topright", legend = c("Random biobanking", "Optimised biobanking"),
    col = c("black", "red"), pch = 1)

plot(seq(0, 1000, by = 10), bird_random_rest[1, ], xlim = c(0, 1000),
    ylim = c(0, 1000), xlab = "Number of species biobanked",
    ylab = "Number of species restored",
    main = "Bird restoration")
points(seq(0, 1000, by = 10), bird_random_rest[2, ])

points(seq(0, 1000, by = 10), bird_optim_rest[1, ], col = "red")
points(seq(0, 1000, by = 10), bird_optim_rest[2, ], col = "red")

legend(x = "topright", legend = c("Random biobanking", "Optimised biobanking"),
    col = c("black", "red"), pch = 1)

graphics.off()