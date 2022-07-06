# Script to match missing species from expenditure data
library(stringdist)

expen <- read.csv("../data/cleaned_bird_downlist_expen.csv")

like <- read.csv("../results/25_may_bird_thresholds/50_score_10mya.csv")

no_match <- c()
for (i in seq_along(expen$Species)) {
    if (!(expen$Species[i] %in% like$X)) {
        no_match <- append(no_match, expen$Species[i])
    }
}

closest_match <- like$X[amatch(no_match, like$X, maxDist = 10)]

other_match <- c()

for (i in seq_along(closest_match)) {
    if (closest_match[i] %in% expen$Species) {
        other_match <- append(other_match, 1)
    }
    else {
        other_match <- append(other_match, 0)
    }
}

possible_matches <- data.frame(no_match, closest_match)

write.csv(possible_matches, 
    "../data/possible_dl_matches.csv", row.names = FALSE)

expen[202, 2] <- "Zosterops_cholornothos"