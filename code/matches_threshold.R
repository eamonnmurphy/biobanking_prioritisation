# Script to obtain aggregated averages for whether species is within threshold
source("extsim_functions.R")
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
if (iter == 1) {
	taxa <- "mammal"
} else if (iter == 2) {
	taxa <- "bird"
}
threshold <- 2

aggregate <- aggregate_distance_thresholds(taxa, threshold)
write.csv(aggregate, file = paste("aggregated_", taxa, "_",
    threshold, "mya.csv", sep = ""))
