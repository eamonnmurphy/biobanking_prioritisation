#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=24:00:00
#PBS -l select=1:ncpus=1:mem=16gb
module load anaconda3/personal
source activate Renv_prior
cp $HOME/biobanking_prioritisation/data/birds_50_likelihoods.csv .
cp $HOME/biobanking_prioritisation/code/extsim_functions.R .
cp $HOME/biobanking_prioritisation/code/fin_functions.R .
echo "R is about to run"
R --vanilla < $HOME/biobanking_prioritisation/code/expen_sims.R
echo "R has finished running"
mv conservation_spend_sim.csv $HOME/biobanking_prioritisation/results/
echo $MINUTES