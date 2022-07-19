# Script to remove the values for the same species in aggregated distances

mammal <- read.csv("../data/aggregated_mammal_10mya.csv", row.names = 1)

for (i in seq_len(nrow(mammal))) {
    mammal[i,i] <- 0
}

write.csv(mammal, "../data/aggregated_mammal_10mya.csv")

bird <- read.csv("../data/aggregated_bird_10mya.csv", row.names = 1)

for (i in seq_len(nrow(bird))) {
    bird[i,i] <- 0
}

write.csv(bird, "../data/aggregated_bird_10mya.csv")