# Create a csv with converted survival likelihoods from GE status

columns <- c("GE", "Extinction", "Survival")
rows <- c("Least Concern", "Near Threatened", "NA", "Data Deficient", "Not Evaluated",
          "Vulnerable", "Endangered", "Critically Endangered", "Extinct in the Wild")

GE <- c(0,1,NA,1,1,2,3,4,6)
extinction <- c(0.00005, 0.004, 0.004, 0.004, 0.004, 0.05, 0.42, 0.97, 1)
survival <- 1 - c(0.00005, 0.004, 0.004, 0.004, 0.004, 0.05, 0.42, 0.97, 1)

mat <- matrix(data = c(GE, extinction, survival), nrow = 9, ncol = 3)

df <- data.frame(mat, row.names = rows)
df <- setNames(df, columns)

write.csv(df, file = "../data/survival_likelihoods.csv")

# Precalculate survival and extinction likelihoods
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