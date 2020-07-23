#!/bin/bash

rm -f sidora.cli.sif

sudo singularity build sidora.cli.sif sidora.cli.def

scp sidora.cli.sif schmid@mpi-sdag1.sdag.ppj.shh.mpg.de:/projects1/singularity_scratch/cache/sidora.cli.sif

