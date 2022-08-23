# Generate the probabilities of there being a close relative for each species
taxa <- c("bird", "mammal")
models <- c("50", "500", "pessimistic")

prob_survival <- function(probs) {
    all_extinct <- prod(probs[which(probs > 0)])
    any_survive <- 1 - all_extinct
    return(any_survive)
}

for (taxon in taxa) {
    #browser()
    aggregated <- read.csv(
        paste("../data/aggregated", taxon, "10mya.csv", sep = "_"),
        row.names = 1)

    for (mod in models) {
        like <- read.csv(
            paste("../data/", taxon, "s_", mod, "_likelihoods.csv", sep = ""))

        ordered <- like[match(rownames(aggregated), like$species), ]

        probs <- sweep(aggregated, MARGIN = 2, ordered$extinction, "*")

        name_vect <- paste("survival", mod, sep = "_")

        any_survive <- apply(probs, MARGIN = 1, FUN = prob_survival)

        assign(name_vect, any_survive)
    }
    res <- data.frame(survival_50, survival_500, survival_pessimistic,
        row.names = rownames(aggregated))

    write.csv(res, file = paste(
        "../data/", taxon, "_close_survival_10mya.csv", sep = ""))
}


