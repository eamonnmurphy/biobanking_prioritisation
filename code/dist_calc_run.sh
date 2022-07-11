#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=32gb
module load anaconda3/personal
source activate Renv_prior
cp $HOME/biobanking_prioritisation/data/cleaned* .
echo "R is about to run"
R --vanilla < $HOME/biobanking_prioritisation/code/distance_calculations.R
echo "R has finished running"
mv bird* $HOME/biobanking_prioritisation/data/bird_distances/
mv mammal* $HOME/biobanking_prioritisation/data/mammal_distances/
echo $SECONDS
