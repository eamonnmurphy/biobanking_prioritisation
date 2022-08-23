# Calculate the related survival chance for one species
species_rel_calc <- function(dist, spec, ext_like, thresh) {
    # Set close extinction to 1 for species without close relative
    if (sum(dist[spec, ] / 2 < thresh & dist[spec, ] != 0, na.rm = T) == 0) {
        close_extinction <- 1
    } else {  # Record extinction likelihood values for closely related
        close_extinction <-
            ext_like[which(dist[spec, ] / 2 < thresh & dist[spec, ] != 0), 3]
    }

    total_close_extinction <- prod(close_extinction, na.rm = TRUE)
    related_survival <- 1 - total_close_extinction

    return(related_survival)
}

# Calculate the related survival for a given phylogenetic tree
tree_rel_calc <- function(phylo, species, ext_like, thresh) {
    # Calculate distances between species
    dist <- ape::cophenetic.phylo(phylo)

    rel_df <- data.frame(score = rep(NA, length(species)),
        row.names = species)

    for (i in seq_along(species)) {
        rel_df$score[i] <- species_rel_calc(dist, species[i],
            ext_like, thresh)
    }

    # rel_df$score <- species_rel_calc(dist, species, ext_like, thresh)

    return(rel_df)
}

# Calculate the related survival for a given phylogenetic tree
multi_tree_calc <- function(phylo, species, ext_like, thresh) {
    # Calculate distances between species
    dist <- ape::cophenetic.phylo(phylo)

    rel_vec <- rep(NA, length(species))

    for (i in seq_along(rel_vec)) {
        rel_vec[i] <- species_rel_calc(dist, species[i], ext_like, thresh)
    }

    # rel_vec <- species_rel_calc(dist, species, ext_like, thresh)

    return(rel_vec)
}

# Calculate the related survival for a given phylogenetic tree or trees
rel_calc <- function(phylo, species, ext_like, thresh, multiphylo = TRUE) {
    if (multiphylo == FALSE) {
        rel_mat <- tree_rel_calc(phylo, species, ext_like, thresh)
        return(rel_mat)
    } else {
        rel_mat <- matrix(nrow = length(species), ncol = length(phylo))
        rel_mat <- sapply(phylo, function(x) multi_tree_calc(x,
            species = species, ext_like = ext_like, thresh = thresh))
        rownames(rel_mat) <- species
        colnames(rel_mat) <- paste("tree", seq_along(phylo), sep = "_")
        rel_df <- data.frame(rel_mat, average = apply(rel_mat, 1, mean))
        return(rel_df)
    }
}