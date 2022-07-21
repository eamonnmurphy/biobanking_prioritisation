# Script containing the financial functions for simulation

prioritised_downlisting_conservation <- function(like, total) {
    expen_per <- read.csv("../data/required_expen_per_status.csv")

    cum_spend <- 0

    if (total < expen_per[3, 3]) {
        return(like)
    }

    while (cum_spend < total) {
        if (any(like$extinction == 0.97)) {
            selected <- sample(like$species[which(like$extinction == 0.97)], 1)
            like$survival[which(like$species == selected)] <- 0.58
            like$extinction[which(like$species == selected)] <- 0.42
            cum_spend <- cum_spend + expen_per[3, 3]
        }
        else if (any(like$extinction == 0.42)) {
            selected <- sample(like$species[which(like$extinction == 0.42)], 1)
            like$survival[which(like$species == selected)] <- 0.95
            like$extinction[which(like$species == selected)] <- 0.05
            cum_spend <- cum_spend + expen_per[2, 3]
        }
        else if (any(like$extinction == 0.05)) {
            selected <- sample(like$species[which(like$extinction == 0.05)], 1)
            like$survival[which(like$species == selected)] <- 0.996
            like$extinction[which(like$species == selected)] <- 0.004
            cum_spend <- cum_spend + expen_per[1, 3]
        }
        else {
            break
        }
    }

    return(like)
}