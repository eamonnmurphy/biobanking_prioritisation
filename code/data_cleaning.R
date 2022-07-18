# Script to clean provided data on species status
rm(list = ls())

##### Load required libraries
library(stringr)

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

# Remove the ummatched species
unmatched <- read.csv("../data/possible_dl_matches.csv")
bird_expen <- subset(bird_expen, !(Species %in% unmatched$no_match))

write.csv(bird_expen, file = "../data/cleaned_bird_downlist_expen.csv",
  row.names = FALSE)
