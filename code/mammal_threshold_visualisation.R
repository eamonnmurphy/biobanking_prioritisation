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
par(mfrow = c(1,2))
hist(ext_like$extinction, xlab = "Likelihood of extinction",
    ylab = "Number of species",
    main = "Distribution of extinction likelihoods in 50 years under IUCN data")
graphics.off()


# Create histogram for threshold of 10 million years
png(filename = "../results/hist_prior_10mya.png")
hist(scores[[1]][, 101], xlab = "Prioritisation score",
    ylab = "Number of species", main = "Threshold of 1 million years to MRCA")
graphics.off()

# par(mfrow = c(5, 4))

# for (i in 1:20) {
#     logged <- 1 + log(scores[[i]][, 101])
#     hist(scores[[i]][, 101], xlim = c(0.1, 1), ylim = c(0, 500))
# }

table <- matrix(nrow = 20, ncol = 3)

cnames <- c("High", "Medium", "Low")

for (i in 1:20) {
    score <- scores[[i]][, 101]
    table[i, ] <- c(sum(score > .95, na.rm = T),
        sum(score > .33 & score < .95, na.rm = T),
        sum(score > 0 & score < .33, na.rm = T))
}

table <- data.frame(table, row.names = paste(seq_len(20), "mya", sep = ""))
colnames(table) <- cnames

write.csv(table, file = "../results/mammal_threshold_table.csv")

png(filename = "../results/mammal_thresholds_scores.png")

plot(table$Medium + table$High, type = "l", ylim = c(0, 1000),
    xlab = "Threshold (mya)", ylab = "No. of species")

lines(table$High, col = "red")

abline(h = 199, col = "black", lty = 2)
text(x = 10, y = 219, "Critically endangered mammal species")
abline(h = 701, col = "black", lty = 2)
text(x = 10, y = 721, "Endangered and critically endangered mammal species")

legend(x = "bottomright",
    legend = c("Medium and high priority", "High priority"),
    col = c("black", "red"), lty = 1)

dev.off()