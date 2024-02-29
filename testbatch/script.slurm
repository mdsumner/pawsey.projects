#!/bin/bash --login

#SBATCH --account=pawsey0973
#SBATCH --partition=debug
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:05:00
#SBATCH --export=NONE


module --ignore_cache load "r/4.2.2"

srun ./batchrun2.sh


