# Script containing the financial functions for simulation

# Randomly assign a cost to each bird species
cost_assignment <- function(like) {
    expen <- read.csv("../data/cleaned_bird_downlist_expen.csv")

    cost <- rep(NA, nrow(like))

    for (i in seq_len(nrow(like))) {
        if (like$extinction[i] == 0.97) {
            cost[i] <- sample(expen$Required_expen[which(expen$GE == 4)], 1)
        }
        else if (like$extinction[i] == 0.42) {
            cost[i] <- sample(expen$Required_expen[which(expen$GE == 3)], 1)
        }
        else if (like$extinction[i] == 0.05) {
            cost[i] <- sample(expen$Required_expen[which(expen$GE == 2)], 1)
        }
    }

    return(cost)
}

# To downlist a single species depending on original status
downlister <- function(species_info) {
    if (species_info$extinction == 0.97) {
        species_info$extinction <- 0.42
        species_info$survival <- 0.58
    } else if (species_info$extinction == 0.42) {
        species_info$extinction <- 0.05
        species_info$survival <- 0.95
    } else if (species_info$extinction == 0.05) {
        species_info$extinction <- 0.004
        species_info$survival <- 0.996
    }
    return(species_info)
}

# In a random way, downlist species and spend conservation budget
random_dl_conservation <- function(like, total, cost) {
    cum_spend <- 0

    if (total < min(cost, na.rm = TRUE)) {
        return(like)
    }

    used <- c()

    while (cum_spend < total) {
        if (length(used)) {
            usable <- like[-used, ]
            if (!any(usable$extinction >= 0.05)) {
                break
            }
            selected <- sample(usable$species, 1)
        } else {
            selected <- sample(like$species, 1)
        }
        like[which(like$species == selected), ] <-
            downlister(like[which(like$species == selected), ])
        cum_spend <- sum(cost[which(like$species == selected)], cum_spend,
            na.rm = TRUE)
        used <- append(used, which(like$species == selected))
    }

    return(like)
}

# Priorities finder
dl_priorities <- function(like, cost) {
    # Calculate the difference in survival likelihood
    diff <- rep(NA, nrow(like))
    for (i in seq_len(nrow(like))) {
        if (like$extinction[i] == 0.97) {
            diff[i] <- 0.55
        } else if (like$extinction[i] == 0.42) {
            diff[i] <- 0.37
        } else if (like$extinction[i] == 0.05) {
            diff[i] <- 0.0496
        }
    }

    score <- cost / diff
    return(score)
}

# In an optimised way, downlist species and spend conservation budget
optim_dl_conservation <- function(like, total, cost, score) {
    cum_spend <- 0

    if (total < min(cost, na.rm = TRUE)) {
        return(like)
    }

    used <- c()
    priors <- dl_priorities(like, cost)

    while (cum_spend < total) {
        if (length(used)) {
            usable <- like[-used, ]
            if (!any(usable$extinction >= 0.05)) {
                break
            }
            selected <- sample(usable$species[
                which(score[-used] == min(score[-used], na.rm = TRUE))], 1)
        } else {
            selected <- sample(like$species[
                which(score == min(score, na.rm = TRUE))], 1)
        }
        like[which(like$species == selected), ] <-
            downlister(like[which(like$species == selected), ])
        cum_spend <- sum(cost[which(like$species == selected)], cum_spend,
            na.rm = TRUE)
        used <- append(used, which(like$species == selected))
    }

    return(like)
}