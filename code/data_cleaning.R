# Script to clean provided data on species status
rm(list = ls())

##### Load required libraries
library(stringr)
library(stringdist)
library(dplyr)

##### Load in data ######
load("../data/100_mammal_trees_with_2020_RL.RData")

for (i in 1:6253) {
  if (is.na(Species$GE[i]))
    Species$GE[i] <- 1
}

save(phy.block.1000, Species, file = "../data/cleaned_mammal_trees_2020.RData")

rm(list = ls())

load("../data/100_bird_trees_with_2020_RL.RData")

for (i in 1:length(bird.species$Species)) {
  if(is.na(bird.species$GE[i]))
    bird.species$GE[i] <- 1
}

save(bird.trees, bird.species, file = "../data/cleaned_bird_trees_2020.RData")

bird_expen <- read.csv("../data/bird_downlisting_expenditure.csv", header = TRUE)

bird_expen[, 2] <- str_replace_all(bird_expen[, 2], "[^[:alnum:]]", "_")
bird_expen[, 2] <- sub("_", "", bird_expen[, 2])

names(bird_expen)[2] <- "Species"

# Replacements for species names from global names database
bird_expen$Species[1] <- "Rhabdotorrhinus_waldeni"
bird_expen$Species[18] <- "Hedydipna_pallidigaster"
bird_expen$Species[23] <- "Aphrastura_masafucrae"
bird_expen$Species[41] <- "Geospiza_heliobates"
bird_expen$Species[49] <- "Poeoptera_femoralis"
bird_expen$Species[18] <- "Hedydipna_pallidigaster"
bird_expen$Species[23] <- "Aphrastura_masafucrae"
bird_expen$Species[41] <- "Geospiza_heliobates"
bird_expen$Species[49] <- "Poeoptera_femoralis"
bird_expen$Species[73] <- "Pternistis_ochropectus"
bird_expen$Species[74] <- "Pternistis_swierstrai"
bird_expen$Species[81] <- "Trochalopteron_yersini"
bird_expen$Species[105] <- "Laterallus_spilonota"
bird_expen$Species[132] <- "Crithagra_concolor"
bird_expen$Species[144] <- "Leucocarbo_chalconotus"
bird_expen$Species[145] <- "Leucocarbo_onslowi"
bird_expen$Species[177] <- "Schoutedenapus_myoptilus"
bird_expen$Species[182] <- "Thalasseus_bernsteini"
bird_expen$Species[186] <- "Chlorophoneus_kupeensis"
bird_expen$Species[189] <- "Thryophilus_nicefori"
bird_expen$Species[201] <- "Geokichla_guttata"
bird_expen$Species[202] <- "Zosterops_chloronothos"

# Remove the unmatched species
like <- read.csv("../results/25_may_bird_thresholds/50_score_10mya.csv")

no_match <- c()
for (i in seq_along(bird_expen$Species)) {
    if (!(bird_expen$Species[i] %in% like$X)) {
        no_match <- append(no_match, bird_expen$Species[i])
    }
}

closest_match <- like$X[amatch(no_match, like$X, maxDist = 10)]

other_match <- c()

for (i in seq_along(closest_match)) {
    if (closest_match[i] %in% bird_expen$Species) {
        other_match <- append(other_match, 1)
    }
    else {
        other_match <- append(other_match, 0)
    }
}

possible_matches <- data.frame(no_match, closest_match)

bird_expen <- subset(bird_expen, !(Species %in% possible_matches$no_match))

# Renaming columns and removing unnecessary
bird_expen <- subset(bird_expen, select = c("Species",
  "IUCN..Bird..Red..List.2013", "Required.Expenditure..US.."))

bird_expen <- bird_expen %>% rename("Status" = "IUCN..Bird..Red..List.2013",
  "Required_expen" = "Required.Expenditure..US..")

# Removing species whose IUCN status has changed
ext_like <- read.csv("../data/ext_likelihood_by_status.csv")

expen_ge <- rep(NA, nrow(bird_expen))

for (i in seq_along(expen_ge)) {
    expen_ge[i] <- ext_like$ge[which(bird_expen$Status[i] == ext_like$abbr)]
}

bird_expen <- data.frame(bird_expen, GE = expen_ge)

to_remove <- c()

for (i in seq_len(nrow(bird_expen))) {
    if (bird_expen$GE[i] != bird.species$GE[
        which(bird.species$Species == bird_expen$Species[i])]) {
            to_remove <- append(to_remove, i)
        }
}

bird_expen <- bird_expen[-to_remove, ]

# Account for inflation from 2012 to today (29%)
# Account for estimates being intended for a 10 year period
bird_expen$Required_expen <- 1.29 * 10 * bird_expen$Required_expen

write.csv(bird_expen, file = "../data/cleaned_bird_downlist_expen.csv",
  row.names = FALSE)
