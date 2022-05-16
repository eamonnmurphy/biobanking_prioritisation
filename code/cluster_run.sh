#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=1:mem=16gb
module load anaconda3/personal
source activate Renv_prior
cp $HOME/11may_thresholds/data/species_likelihoods.csv .
cp $HOME/11may_thresholds/data/cleaned_mammal_trees_2020.RData .
echo "R is about to run"
R --vanilla < $HOME/11may_thresholds/code/cluster_prior_score.R
mv ordered_prior_score* $HOME/11may_thresholds/results/
echo "R has finished running"
echo $SECONDS
