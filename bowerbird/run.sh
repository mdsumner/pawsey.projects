#!/bin/bash

module load singularity/3.11.4-slurm

singularity exec $MYSOFTWARE/sif_lib/hypertidy_main.sif Rscript run.R




