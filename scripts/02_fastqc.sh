#!/bin/bash
set -euo pipefail

PROJECT="$HOME/Week9_Populus"
SCRATCH="/scratch/$USER/Week9_Populus"

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

mkdir -p "$PROJECT/results/fastqc"

echo "===== FASTQC START ====="
date
hostname

fastqc --threads 2 \
  --outdir "$PROJECT/results/fastqc" \
  "$SCRATCH"/data/subsample/*.fastq.gz

echo "===== FASTQC COMPLETE ====="
date
