#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=70:00:00
#PBS -l select=1:ncpus=1:mem=32gb
module load anaconda3/personal
source activate Renv_prior
cp $HOME/biobanking_prioritisation/data/mammal_distances/mammal_dist_* .
cp $HOME/biobanking_prioritisation/data/bird_distances/bird_dist_* .
cp $HOME/biobanking_prioritisation/code/extsim_functions.R .
echo "R is about to run"
R --vanilla < $HOME/biobanking_prioritisation/code/matches_threshold.R
echo "R has finished running"
mv aggregated* $HOME/biobanking_prioritisation/data/
echo $SECONDS
