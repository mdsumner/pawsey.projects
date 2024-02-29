#!/bin/bash
#
#SBATCH --array=0
#SBATCH --cpus-per-task=4
#SBATCH --job-name=trickle_ghrsst
#SBATCH --output=slurm_%a.out
#SBATCH --time=4:00:00

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif R CMD BATCH --vanilla ghrsst_trickle.R

