#!/bin/bash
#
#SBATCH --array=0-1
#SBATCH --cpus-per-task=2
#SBATCH --job-name=test_apply
#SBATCH --output=slurm_%a.out
/software/setonix/2023.08/software/linux-sles15-zen3/gcc-12.2.0/r-4.2.2-mkn3nmvzxfv3y2qlhx7qrg7ppys5vdes/rlib/R/bin/Rscript --vanilla slurm_run.R
