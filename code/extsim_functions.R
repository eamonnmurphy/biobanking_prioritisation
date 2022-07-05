# Functions for performing extinction simulations

priority_builder <- function(file) {
    rawtable <- read.csv(file, header = TRUE)
    newtable <- data.frame(species = rawtable[, 1], score = rawtable[, 102])
    newtable <- newtable[order(newtable$score, decreasing = TRUE), ]

    return(newtable)
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
