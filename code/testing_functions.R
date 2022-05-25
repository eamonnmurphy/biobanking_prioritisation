species_prior_calc <- function(dist, spec, ext_like, thresh) {
    # Set close extinction to 1 for species without close relative
    if (sum(dist[spec, ] / 2 < thresh & dist[spec, ] != 0, na.rm = T) == 0) {
        close_extinction <- 1
    } else {  # Record extinction likelihood values for closely related
        close_extinction <-
            ext_like[which(dist[spec, ] / 2 < thresh & dist[spec, ] != 0), 3]
    }

    total_close_extinction <- prod(close_extinction, na.rm = TRUE)
    related_survival <- 1 - total_close_extinction
    prior_score <- ext_like[which(ext_like[, 1] == spec), 3] * related_survival

    return(prior_score)
}

tree_prior_calc <- function(phylo, species, ext_like, thresh) {
    # Calculate distances between species
    dist <- ape::cophenetic.phylo(phylo)

    prior_df <- data.frame(score = rep(NA, length(species)),
        row.names = species)

    for (i in seq_along(species)) {
        prior_df$score[i] <- species_prior_calc(dist, species[i],
            ext_like, thresh)
    }

    # prior_df$score <- species_prior_calc(dist, species, ext_like, thresh)
    
    return(prior_df)
}

multi_tree_calc <- function(phylo, species, ext_like, thresh) {
    # Calculate distances between species
    dist <- ape::cophenetic.phylo(phylo)

    prior_vec <- rep(NA, length(species))

    for (i in seq_along(prior_vec)) {
        prior_vec[i] <- species_prior_calc(dist, species[i], ext_like, thresh)
    }

    # prior_vec <- species_prior_calc(dist, species, ext_like, thresh)

    return(prior_vec)
}

prior_calc <- function(phylo, species, ext_like, thresh, multiphylo = TRUE) {
    if (multiphylo == FALSE) {
        prior_mat <- tree_prior_calc(phylo, species, ext_like, thresh)
        return(prior_mat)
    } else {
        prior_mat <- matrix(nrow = length(species), ncol = length(phylo))
        prior_mat <- sapply(phylo, function(x) multi_tree_calc(x,
            species = species, ext_like = ext_like, thresh = 10))
        rownames(prior_mat) <- species
        colnames(prior_mat) <- paste("tree", seq_len(100), sep = "_")
        prior_df <- data.frame(prior_mat, average = apply(prior_mat, 1, mean))
        return(prior_df)
    }
}

# load("../data/cleaned_mammal_trees_2020.RData")
# ext_like <- read.csv("../data/mammals_50_likelihoods.csv", header = TRUE)

# example <- phy.block.1000[[1]]
# res <- prior_calc(phy.block.1000, ext_like[, 1], ext_like, thresh = 10)
# res <- tree_prior_calc(example, ext_like[, 1], ext_like, 10)
# dist <- ape::cophenetic.phylo(example)
# spec <- ext_like[74, 1]
# res <- species_prior_calc(dist, spec, ext_like, thresh = 10)

# res <- prior_calc(example, ext_like[, 1], ext_like[, 3], multiphylo = FALSE)
