#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=21:00:00
#PBS -l select=1:ncpus=1:mem=4gb
module load anaconda3/personal
source activate Renv_prior
cp $HOME/biobanking_prioritisation/data/aggregated_mammal_10mya.csv .
cp $HOME/biobanking_prioritisation/data/aggregated_bird_10mya.csv .
cp $HOME/biobanking_prioritisation/data/mammals_50_likelihoods.csv .
cp $HOME/biobanking_prioritisation/data/birds_50_likelihoods.csv .
cp $HOME/biobanking_prioritisation/code/extsim_functions.R .
echo "R is about to run"
R --vanilla < $HOME/biobanking_prioritisation/code/new_restoration_sim.R
echo "R has finished running"
mv *2_mya.csv $HOME/biobanking_prioritisation/results/cat_2/
mv *10_mya.csv $HOME/biobanking_prioritisation/results/cat_10/
echo $SECONDS
