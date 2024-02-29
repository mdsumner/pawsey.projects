#!/bin/bash
#
#SBATCH --array=0-0
#SBATCH --cpus-per-task=4
#SBATCH --job-name=test_apply
#SBATCH --output=slurm_%a.out

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif Rscript slurm_run.R
#/software/setonix/2023.08/software/linux-sles15-zen3/gcc-12.2.0/r-4.2.2-mkn3nmvzxfv3y2qlhx7qrg7ppys5vdes/rlib/R/bin/Rscript --vanilla slurm_run.R
