#!/bin/bash --login

#SBATCH --account=pawsey0973
#SBATCH --partition=copy
#SBATCH --time=24:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif R CMD BATCH --no-save --no-restore work.R

