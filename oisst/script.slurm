#!/bin/bash --login

#SBATCH --account=pawsey0973
#SBATCH --partition=work
#SBATCH --time=01:00:00
#SBATCH --export=NONE
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48


srun ./run.sh


