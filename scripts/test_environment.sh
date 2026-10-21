#!/bin/bash
set -e

cd "$HOME/Week9_Populus"

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

echo "===== COMPUTE NODE ====="
hostname

echo "===== ENVIRONMENT ====="
echo "$CONDA_DEFAULT_ENV"

echo "===== SOFTWARE ====="
fasterq-dump --version
fastqc --version
fastp --version
seqkit version
kraken2 --version
bowtie2 --version
samtools --version | head -2

echo "===== TEST SUCCESSFUL ====="
