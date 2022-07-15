# Script to obtain aggregated averages for whether species is within threshold
source("extsim_functions.R")
threshold <- 10

mammal_aggregate <- aggregate_distance_thresholds("mammal", threshold)
write.csv(mammal_aggregate, file = "aggregated_mammal_10mya.csv")

bird_aggregate <- aggregate_distance_thresholds("bird", threshold)
write.csv(bird_aggregate, file = "aggregated_bird_10mya.csv")