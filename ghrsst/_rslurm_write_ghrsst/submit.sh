#!/bin/bash
#
#SBATCH --array=0-3
#SBATCH --cpus-per-task=52
#SBATCH --job-name=write_ghrsst
#SBATCH --output=slurm_%a.out
#SBATCH --time=12:00:00
#SBATCH --partition=highmem

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif R CMD BATCH --vanilla slurm_run.R


