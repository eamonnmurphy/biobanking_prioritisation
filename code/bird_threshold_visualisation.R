# Script to visualise priority scores for various thresholds and models,
# for birds

# Load in the data
scores_50 <- vector(mode = "list", length = 20)
scores_500 <- vector(mode = "list", length = 20)
scores_pessimistic <- vector(mode = "list", length = 20)

for (i in seq_len(20)) {
    name_50 <- paste("../results/25_may_bird_thresholds/50_score_", i,
        "mya.csv", sep = "")
    name_500 <- paste("../results/25_may_bird_thresholds/500_score_", i,
        "mya.csv", sep = "")
    name_pessimistic <-
        paste("../results/25_may_bird_thresholds/pessimistic_score_", i,
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

write.csv(table, file = "../results/bird_threshold_table.csv")

png(filename = "../results/bird_threshold_viz.png")
plot(table$fifty_year, type = "l", xlab = "Threshold for MRCA (mya)",
    ylim = c(0, 1000), ylab = "No. of species", col = "blue")

lines(table$fivehundred_year, col = "#6c3092")
lines(table$pessimistic, col = "red")

abline(h = 230, col = "black", lty = 2)
text(x = 10, y = 250, "Critically endangered bird species")
abline(h = 691, col = "black", lty = 2)
text(x = 10, y = 711, "Endangered and critically endangered bird species")

legend(x = "bottomright", legend = c("IUCN 50 year model",
    "IUCN 500 year model", "Pessimistic scenario"), col = c("blue", "purple",
        "red"), lty = 1)

dev.off()