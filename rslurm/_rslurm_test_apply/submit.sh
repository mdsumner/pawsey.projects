#!/bin/bash
#
#SBATCH --array=0-0
#SBATCH --cpus-per-task=4
#SBATCH --job-name=test_apply
#SBATCH --output=slurm_%a.out

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif Rscript slurm_run.R


