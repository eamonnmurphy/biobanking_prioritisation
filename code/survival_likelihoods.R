# Create a csv with converted survival likelihoods from GE status

# Load in necessary libraries
library(stringr)

rows <- c("Least Concern", "Near Threatened", "NA", "Data Deficient",
      "Not Evaluated", "Vulnerable", "Endangered", "Critically Endangered",
      "Extinct in the Wild")

abbr <- c("LC", "NT", "NA", "DD", "NE", "VU", "EN", "CR", "EW")
ge <- c(0, 1, NA, 1, 1, 2, 3, 4, 6)
extinction <- c(0.00005, 0.004, 0.004, 0.004, 0.004, 0.05, 0.42, 0.97, 1)
survival <- 1 - c(0.00005, 0.004, 0.004, 0.004, 0.004, 0.05, 0.42, 0.97, 1)

df <- data.frame(Abbr = abbr, GE = ge, Extinction = extinction,
      Survival = survival, row.names = rows)

write.csv(df, file = "../data/survival_likelihoods.csv")

# Precalculate survival and extinction likelihoods for mammals
load("../data/cleaned_mammal_trees_2020.RData")

spec_survival <- rep(NA, 6253)
spec_extinction <- rep(NA, 6253)
for (i in 1:6253) {
  try(spec_survival[i] <-
        df$Survival[which(df$GE == Species$GE[i])], silent = T)
  try(spec_extinction[i] <-
        df$Extinction[which(df$GE == Species$GE[i])], silent = T)
}

data <- data.frame("species" = Species$Species,
    "survival" = spec_survival, "extinction" = spec_extinction)

# Create a csv file to store the likelihoods
write.csv(data, file = "../data/species_likelihoods.csv")

# Convert bird endangerment status for expenditure data
birds <- read.csv("../data/bird_downlisting_expenditure.csv", header = TRUE)

species <- str_replace_all(birds[, 2], "[^[:alnum:]]", "_")
species <- sub("_", "", species)

status <- birds[, 3]

bird_extinction <- rep(NA, length(species))
bird_survival <- rep(NA, length(species))

for (i in seq_len(length(species))) {
      bird_extinction[i] <- df$Extinction[which(df$Abbr == status[i])]
      bird_survival[i] <- df$Survival[which(df$Abbr == status[i])]
}

bird_table <- data.frame(Species = species, Status = status,
      Extinction = bird_extinction, Survival = bird_survival)

write.csv(bird_table, file = "../data/selected_birds_likelihoods.csv",
      row.names = FALSE)