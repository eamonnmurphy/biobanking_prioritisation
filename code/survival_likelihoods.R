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

