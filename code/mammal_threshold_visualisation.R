# This is a script to visualise results for different thresholds
# Initially 1-20mya for mammals

# Load in the data
scores <- vector(mode = "list", length = 20)

for (i in 1:20) {
    file_name <- paste("../results/mammal_thresholds/ordered_prior_score_",
        i, "mya.csv", sep = "")
    scores[[i]] <- read.csv(file_name, header = TRUE)
}

# Create histogram for standard ext likelihood distributions
ext_like <- read.csv("../data/mammals_50_likelihoods.csv", header = TRUE)
png(filename = "../results/hist_ext_like.png")
hist(ext_like$extinction, xlab = "Likelihood of extinction",
    ylab = "Number of species",
    main = "Distribution of extinction likelihoods in 50 years under IUCN data")
graphics.off()


# Create histogram for threshold of 10 million years
png(filename = "../results/hist_prior_10mya.png")
hist(scores[[10]][, 101], xlab = "Prioritisation score",
    ylab = "Number of species",
    main = "Distribution of prioritisation scores, threshold 10mya to MRCA")
graphics.off()

# par(mfrow = c(5, 4))

# for (i in 1:20) {
#     logged <- 1 + log(scores[[i]][, 101])
#     hist(scores[[i]][, 101], xlim = c(0.1, 1), ylim = c(0, 500))
# }

# Load in the data
scores_50 <- vector(mode = "list", length = 20)
scores_500 <- vector(mode = "list", length = 20)
scores_pessimistic <- vector(mode = "list", length = 20)

for (i in seq_len(20)) {
    name_50 <- paste("../results/mammal_ps/50_score_", i,
        "mya.csv", sep = "")
    name_500 <- paste("../results/mammal_ps/500_score_", i,
        "mya.csv", sep = "")
    name_pessimistic <-
        paste("../results/mammal_ps/pessimistic_score_", i,
            "mya.csv", sep = "")
    scores_50[[i]] <- read.csv(name_50, header = TRUE)
    scores_500[[i]] <- read.csv(name_500, header = TRUE)
    scores_pessimistic[[i]] <- read.csv(name_pessimistic, header = TRUE)
}

table <- data.frame(matrix(nrow = 20, ncol = 3))
colnames(table) <- c("fifty_year", "fivehundred_year", "pessimistic")

for (i in seq_len(20)) {
    score_50 <- scores_50[[i]][, 101]
    score_500 <- scores_500[[i]][, 101]
    score_pessimistic <- scores_pessimistic[[i]][, 101]

    table[i, ] <- c(sum(score_50 > .95, na.rm = T),
        sum(score_500 > .95, na.rm = T),
        sum(score_pessimistic > .95, na.rm = T))
}

rownames(table) <- paste(seq_len(20), "mya", sep = "")

write.csv(table, file = "../results/mammal_threshold_table.csv")
