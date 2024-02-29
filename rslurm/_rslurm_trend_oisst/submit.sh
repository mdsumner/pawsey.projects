#!/bin/bash
#
#SBATCH --array=0-7
#SBATCH --cpus-per-task=128
#SBATCH --job-name=trend_oisst
#SBATCH --output=slurm_%a.out

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif Rscript slurm_run.R

