#!/bin/bash --login

#SBATCH --account=pawsey0973
#SBATCH --partition=work
#SBATCH --time=00:10:00
#SBATCH --export=NONE
#SBATCH --cpus-per-task=8

srun ./run.sh
