# Script to extract some initial insights from the cryoarks database
library(dplyr)

table <- read.csv("../data/cryoarks_database.csv", header = TRUE)

rel_species <- unique(table$FullName[
    which(table$Class == "Mammalia" | table$Class == "Aves")])

count <- rep(NA, length(rel_species))

for (i in seq_along(count)) {
    count[i] <- sum(table$FullName == rel_species[i])
}

rel_species <- gsub(" ", replacement = "_", rel_species)

output <- data.frame(rel_species, count)

output <- arrange(output, desc(count))

write.csv(output, file = "../data/cryoarks_spec_counts.csv", row.names = F)
