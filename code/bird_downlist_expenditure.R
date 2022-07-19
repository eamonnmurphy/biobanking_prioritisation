# Script to calculate species saved by thresholds of conservation spending
expen <- read.csv("../data/cleaned_bird_downlist_expen.csv")
ext_like <- read.csv("../data/ext_likelihood_by_status.csv")
load("../data/cleaned_bird_trees_2020.RData")

expen_ge <- rep(NA, nrow(expen))

for (i in seq_along(expen_ge)) {
    expen_ge[i] <- ext_like$ge[
        which(expen$IUCN..Bird..Red..List.2013[i] == ext_like$abbr)]
}

expen <- data.frame(expen, ge = expen_ge)

to_remove <- c()

for (i in seq_len(nrow(expen))) {
    if (expen$ge[i] != bird.species$GE[
        which(bird.species$Species == expen$Species[i])]) {
            to_remove <- append(to_remove, i)
        }
}

expen <- expen[-to_remove, ]

for (i in 2:4) {
    name <- paste("expen_ge_", i, sep = "")
    arith_mean <- round(exp(mean(log(expen$Required.Expenditure..US..[
        which(expen$ge == i)]))))
    assign(name, arith_mean)
}

final <- data.frame(ge = c(2, 3, 4), status = c("VU", "EN", "CR"),
    required_expen = c(expen_ge_2, expen_ge_3, expen_ge_4))

write.csv(final, "../data/required_expen_per_status.csv", row.names = FALSE)