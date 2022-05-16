# This is a script to visualise results for different thresholds
# Initially 1-20mya for mammals

# Load in the data
scores <- vector(mode = "list", length = 20)

for (i in 1:20) {
    file_name <- paste("../results/mammal_thresholds/ordered_prior_score_",
        i, "mya.csv", sep = "")
    scores[[i]] <- read.csv(file_name, header = TRUE)
}

par(mfrow = c(5, 4))

for (i in 1:20) {
    logged <- 1 + log(scores[[i]][, 101])
    hist(scores[[i]][, 101], xlim = c(0.1, 1), ylim = c(0, 500))
}

table <- matrix(nrow = 21, ncol = 4)

cnames <- c("Threshold (mya)", "High (>.95)",
    "Medium (>.33)", "Low (>0)")

table[1, ] <- cnames
for (i in 1:20) {
    score <- scores[[i]][, 101]
    table[i + 1, ] <- c(i, sum(score > .95, na.rm = T),
        sum(score > .33 & score < .95, na.rm = T),
        sum(score > 0 & score < .33, na.rm = T))
}

write.csv(table, file = "../results/threshold_table.csv")

png(filename = "../results/thresholds_scores.png")

plot(table[2:21, 3], type = "l", ylim = c(0, 500),
    xlab = "Threshold (mya)", ylab = "No. of species")

lines(table[2:21, 2], col = "red")

legend(x = "bottomright", legend = c("Medium priority", "High priority"),
    col = c("black", "red"), lty = 1)

dev.off()