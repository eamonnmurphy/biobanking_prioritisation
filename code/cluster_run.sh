#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=3:00:00
#PBS -l select=1:ncpus=1:mem=8gb
module load anaconda3/personal
cp $HOME/species_likelihoods.csv .
cp $HOME/cleaned_mammal_trees_2020.RData .
echo "R is about to run"
R --vanilla < $HOME/cluster_prior_score.R
mv ordered_prior_score* $HOME
echo "R has finished running"