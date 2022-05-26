#!/bin/bash
# Desc: Shell for running R script on HPC cluster

#PBS -l walltime=2:00:00
#PBS -l select=1:ncpus=1:mem=20gb
#PBS -J 1-60
module load anaconda3/personal
source activate Renv_prior
cp $HOME/25may_bird_thresholds/data/* .
echo "R is about to run"
R --vanilla < $HOME/25may_bird_thresholds/code/bird_cluster_score.R
mv *mya.csv $HOME/25may_bird_thresholds/results/
echo "R has finished running"
echo $SECONDS
