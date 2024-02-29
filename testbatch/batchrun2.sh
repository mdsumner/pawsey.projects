#!/bin/bash 

#module load --ignore_cache  r/4.2.2

module --ignore_cache load "r/4.2.2"

R CMD BATCH --no-save --no-restore batch.R

