#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=1:mem=20gb
#PBS -J 1-60
module load anaconda3/personal
source activate Renv_prior
cp $HOME/biobanking_prioritisation/data/mammals_500_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/mammals_pessimistic_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/mammals_50_likelihoods.csv .  
cp $HOME/biobanking_prioritisation/data/cleaned_mammal_trees_2020.RData .
echo "R is about to run"
R --vanilla < $HOME/biobanking_prioritisation/code/mammal_cluster_score.R
mv *mya.csv $HOME/biobanking_prioritisation/results/mammal_ps/
echo "R has finished running"
echo $SECONDS
