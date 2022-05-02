load("../data/100_mammal_trees_with_2020_RL.RData")

View(Species)

plot(phy.block.1000[[50]])

tree <- phy.block.1000[[1]]

tree$tip.label[1]
tree$edge[1,]
