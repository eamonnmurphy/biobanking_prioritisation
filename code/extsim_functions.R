# Functions for performing extinction simulations

priority_builder <- function(file) {
    rawtable <- read.csv(file, header = TRUE)
    newtable <- data.frame(species = rawtable[, 1], score = rawtable[, 102])
    newtable <- newtable[order(newtable$score, decreasing = TRUE), ]

    return(newtable)
}

category_priority_builder <- function(file) {
    raw <- read.csv(file)
    new <- raw[order(raw$survival, decreasing = FALSE), ]
    return(new)
}

prep_output <- function(species, reps) {
    mat <- matrix(nrow = length(species), ncol = reps)

    return(mat)
}

prep_rand <- function(species, reps) {
    rand <- matrix(runif(length(species) * reps), nrow = length(species),
        ncol = reps)
    return(rand)
}

run_sim <- function(likelihoods, reps) {
    out <- prep_output(likelihoods[, 1], reps)
    rand <- prep_rand(likelihoods[, 1], reps)

    for (i in seq_len(reps)) {
        for (s in seq_along(likelihoods[, 1])) {
            if (rand[s, i] < likelihoods[s, 3]) {
                out[s, i] <- 0
            }
            else {
                out[s, i] <- 1
            }
        }
    }

    return(data.frame(species = likelihoods[, 1], out))
}

average_calc <- function(sim_results) {
    survival <- rep(NA, nrow(sim_results))

    survival <- apply(sim_results[, 2:ncol(sim_results)], 1, mean)

    return(data.frame(species = sim_results[, 1], survival))
}


# Calculate the average number of extinctions in each simulation
avg_extinctions <- function(sim_results) {
    surviving <- rep(NA, ncol(sim_results) - 1)

    surviving <- apply(sim_results[, 2:ncol(sim_results)], 2, sum)

    extinctions <- nrow(sim_results) - surviving
    
    return(extinctions)
}

rand_biobank <- function(likelihoods, n) {
    biobanked <- sample.int(nrow(likelihoods), size = n)

    for (i in seq_along(likelihoods$species)) {
        if (i %in% biobanked) {
            likelihoods[i, 2] <- 1
            likelihoods[i, 3] <- 0
        }
    }

    return(likelihoods)
}

rand_downlist <- function(likelihoods, n) {
    biobanked <- sample.int(nrow(likelihoods), size = n)

    for (i in seq_along(likelihoods$species)) {
        if (i %in% biobanked) {
            if (likelihoods[i, 3] == 0.97) {
                likelihoods[i, 2] <- 0.58
                likelihoods[i, 3] <- 0.42
            }
            else if (likelihoods[i, 3] == 0.42) {
                likelihoods[i, 2] <- 0.95
                likelihoods[i, 3] <- 0.05
            }
            else if (likelihoods[i, 3] == 0.05) {
                likelihoods[i, 2] <- 0.996
                likelihoods[i, 3] <- 0.004
            }
            else if (likelihoods[i, 3] == 0.004) {
                likelihoods[i, 2] <- 0.99995
                likelihoods[i, 3] <- 0.00005
            }
        }
    }

    return(likelihoods)
}

prioritised_biobank <- function(likelihoods, priorities, n) {
    selected <- priorities[1:n, ]
    for (i in seq_along(likelihoods$species)) {
        if (likelihoods[i, 1] %in% selected$species) {
            likelihoods[i, 2] <- 1
            likelihoods[i, 3] <- 0
        }
    }

    return(likelihoods)
}

prioritised_downlist <- function(likelihoods, priorities, n) {
    selected <- priorities[1:n, ]
    for (i in seq_along(likelihoods$species)) {
        if (likelihoods[i, 1] %in% selected$species) {
            if (likelihoods[i, 3] == 0.97) {
                likelihoods[i, 2] <- 0.58
                likelihoods[i, 3] <- 0.42
            }
            else if (likelihoods[i, 3] == 0.42) {
                likelihoods[i, 2] <- 0.95
                likelihoods[i, 3] <- 0.05
            }
            else if (likelihoods[i, 3] == 0.05) {
                likelihoods[i, 2] <- 0.996
                likelihoods[i, 3] <- 0.004
            }
            else if (likelihoods[i, 3] == 0.004) {
                likelihoods[i, 2] <- 0.99995
                likelihoods[i, 3] <- 0.00005
            }
        }
    }

    return(likelihoods)
}

restoration_prioritised <- function(sim_res, priorities, taxa, n, sims, thresh) {
    selected <- priorities[1:n, ]

    restored <- matrix(0, nrow = sims, ncol = 100)

    for (i in seq_len(sims)) {
        # browser()
        for (j in seq_along(selected$species)) {
            spec <- selected$species[j]
            if (sim_res[which(sim_res$species == spec), i + 1] == 0) {
                    for (k in 1:100) {
                        dist <- read.csv(file = paste(taxa, "_dist_",
                            k, ".csv", sep = ""), row.names = 1)
                        possible <- colnames(dist)[which(dist[spec, ] / 2 < thresh & dist[spec, ] != 0)]
                        if (any(sim_res[which(sim_res$species %in% possible), i + 1] == 1)) {
                            restored[i, k] <- restored[i, k] + 1
                        }
                    }
                }
        }
    }
    
    return(restored)
}

possible_donor_species <- function(taxa) {
    thresh <- 10

    for (i in 1:100) {
        dist <- read.csv(file = paste(taxa, "_dist_", i, ".csv", sep = ""), 
            row.names = 1)
        
        for (s in seq_len(nrow(dist))) {

        }
    }
}

optimised_restoration_prioritised <- function(sim_res, priorities, taxa, n, sims, thresh) {
    if (n == 0) {
        restored <- rep(0, sims)
        return(restored)
    }
    
    selected <- priorities[1:n, ]

    restored <- vector(length = sims)

    within_threshold <- read.csv(paste("aggregated_", taxa, "_", thresh,
        "mya.csv", sep = ""), row.names = 1)


    for (i in seq_len(sims)) {
        # browser()
        for (j in seq_along(selected$species)) {
            spec <- selected$species[j]
            if (sim_res[which(sim_res$species == spec), i + 1] == 0) {
                        possible <- within_threshold[spec, ] * sim_res[, i + 1]
                        restored[i] <- restored[i] + max(possible)
                }
        }
    }
    
    return(restored)
}

random_restoration_prioritised <- function(sim_res, taxa, n, sims, thresh) {
    if (n == 0) {
        restored <- rep(0, sims)
        return(restored)
    }

    selected <- sample(sim_res$species, n)

    restored <- vector(length = sims)

    within_threshold <- read.csv(paste("aggregated_", taxa, "_", thresh,
        "mya.csv", sep = ""), row.names = 1)


    for (i in seq_len(sims)) {
        # browser()
        for (j in seq_along(selected)) {
            spec <- selected[j]
            if (sim_res[which(sim_res$species == spec), i + 1] == 0) {
                        possible <- within_threshold[spec, ] * sim_res[, i + 1]
                        restored[i] <- restored[i] + max(possible)
                }
        }
    }
    
    return(restored)
}

aggregate_distance_thresholds <- function(taxa, threshold) {
    # Function to create  aggregated scores for threshold matching across trees
    if (taxa == "mammal") {
        len = 6253
    } else if (taxa == "bird") {
	len = 10988
    }

    aggregated <- matrix(0, nrow = len, ncol = len)
    temp <- matrix(nrow = len, ncol = len)

    checker <- function(distance, threshold) {
        if ((distance / 2) < threshold) {
            return(1)
        } else {
            return(0)
        }
    }

    for (i in 1:100) {
        dist <- as.matrix(data.table::fread(file = paste(taxa, "_dist_", i,
            ".csv", sep = "")), rownames = 1)
        temp <- apply(dist, c(1,2), checker, threshold = threshold,
		      simplify = TRUE)
        aggregated <- ((aggregated * (i - 1)) + temp) / i 
    }

    rownames(aggregated) <- rownames(dist)
    colnames(aggregated) <- colnames(dist)

    return(aggregated)
}
