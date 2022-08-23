#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=1:mem=20gb
module load anaconda3/personal
source activate Renv_prior
cp $HOME/biobanking_prioritisation/code/related_survival_functions.R
cp $HOME/biobanking_prioritisation/data/mammals_500_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/mammals_pessimistic_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/mammals_50_likelihoods.csv .  
cp $HOME/biobanking_prioritisation/data/cleaned_mammal_trees_2020.RData .
cp $HOME/biobanking_prioritisation/data/birds_500_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/birds_pessimistic_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/birds_50_likelihoods.csv .  
cp $HOME/biobanking_prioritisation/data/cleaned_bird_trees_2020.RData .
echo "R is about to run"
R --vanilla < $HOME/biobanking_prioritisation/code/cluster_related_survival.R
mv *mya.csv $HOME/biobanking_prioritisation/results/related_survival
echo "R has finished running"
echo $SECONDS
