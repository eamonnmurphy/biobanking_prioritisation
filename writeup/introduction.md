# Introduction
Unfortunately, it seems as if we may be living through the time of the Sixth 
Great Mass Extinction. Anthropogenic changes to the natural environment, such 
as climate change and pollution, have already driven many species extinct and 
threaten to cause the extinction of many more in the coming centuries. 
Traditional conservation strategies focus on mitigating the impacts of human
activites, as well as strategies to protect some of our most vulnerable and 
threatened species. However, this may not be enough for some particularly
vulnerable species, as these approaches are often costly to implement, and 
the political will can be lacking. Another approach, previously confined to
science fiction stories but recently made possible by advances in 
biotechnology, is to restore species from extinction, using stored genetic 
data. In order to make this approach possible, we must biobank samples from 
threatened species now, before it is too late.

Under a scenario of limited resources, a key consideration for this approach is
which species to biobank first. We can build a metric that approaches this 
question by utilising phylogenetics, and data on conservation status. We know 
that it will be necessary for restoration approaches for a closely related 
species to have survived, in order to provide biological material for potential
cloning approaches, such as stem cells. Therefore, the highest priority species
for biobanking are those which have a high likelihood of extinction, as well as
a high likelihood a closely related species will survive. The current best test
relatedness is phylogenetic distance, so we can calculate these prioritisation
scores by combining IUCN Red List data with phylogenetic trees of the taxa of 
interest.

It is important to consider how likely it is that we will be able to use this 
approach to restore extinct species in reality. A closely related task which we
can carry out is to restore genetic diversity to species that are threatened
with extinction. For example, this has been carried out in the American Black 
Stoat by Revive and Restore. Biological samples which were taken in the 1980s
were used to create clones to introduce to the wild population, as the genetic
diversity had greatly declined in the intervening period. It seems likely that
we will be able to extend this approach to clone individuals from species which
have recently become extinct. In fact, there is an ongoing project to restore
the Wooly Mammoth by a similar approach, which is a much more difficult project
as it necessitates working with ancient DNA, meaning low coverage reads and 
missing chunks of the genome. By comparison, restoring species from DNA stored 
in modern cryopreservation facilities should be relatively doable.

Often, conservation resources are focused on species with high visibility or
high cultural appeal. Although this approach can help to drive resources
towards conservation, it does not optimise the use of the resources we have, 
and can result in oversights which leave behind species of high worth on other
metrics, such as ecological importance or phylogenetic diversity. This has been
the basis of approaches such as EDGE scores, which prioritise conservation 
resources based on aims such as maximising retained phylogenetic diversity. In 
this case, we aim to prioritise species for biobanking based solely on the 
likelihood of the material becoming useful. Currently, biobanks such as 
Nature's Safe simply aim to biobank whatever material is available. While this
can be a cost effective approach, and avoids potentially controversial 
decisions comparing the worth of various species, it means that the samples are
biased, particularly towards species housed in zoos. Zoos are generally more
likely to contain larger mammals and certain taxa like primates, and as such
give an unrepresentative sample of the total biological diversity of animals.

Another potential source of bias in our estimates lies within species
classification in the phylogenetic trees. There will always be debate whether
to classify closely related taxa as seperate species or only subspecies. This
can create a source of bias, particularly if there is a tendency within certain
genera or orders to classify as species vs. subspecies and vice-versa. Since it
is necessary for closely related species to survive, artificially inflating the
number of closely related taxa will bias the priority scores. However, this
effect should be evened somewhat by the fact that each of these species will 
have their own conservation status, which will be incorporated into the
calculations. A sensitivity analysis needs to be carried out to get a better
sense of the size of this effect.
