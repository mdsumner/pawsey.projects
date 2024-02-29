#!/bin/bash --login
#
#SBATCH --array=0
#SBATCH --cpus-per-task=128
#SBATCH --job-name=info_ghrsst
#SBATCH --output=slurm_%a.out
#SBATCH --time=00:30:00
#SBATCH --partition=work

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif R CMD BATCH --vanilla run.R



