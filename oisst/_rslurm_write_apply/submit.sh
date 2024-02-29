#!/bin/bash
#
#SBATCH --array=0-11
#SBATCH --cpus-per-task=128
#SBATCH --job-name=write_apply
#SBATCH --output=slurm_%a.out
#/usr/local/lib/R/bin/Rscript --vanilla slurm_run.R




module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif R CMD BATCH --vanilla slurm_run.R

