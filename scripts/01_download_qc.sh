#!/bin/bash
set -euo pipefail

PROJECT="$HOME/Week9_Populus"
SCRATCH="/scratch/$USER/Week9_Populus"

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

mkdir -p "$SCRATCH/data/subsample"
mkdir -p "$PROJECT/results/fastqc"
mkdir -p "$PROJECT/results/stats"

cd "$PROJECT"

echo "===== START ====="
date
hostname

echo "===== DNA DOWNLOAD ====="

fastq-dump SRR36001243 \
  -N 1 -X 100000 \
  --split-files \
  --skip-technical \
  --gzip \
  -O "$SCRATCH/data/subsample"

echo "===== RNA DOWNLOAD ====="

fastq-dump SRR3241527 \
  -N 1 -X 100000 \
  --split-files \
  --skip-technical \
  --gzip \
  -O "$SCRATCH/data/subsample"

echo "===== FASTQ FILES ====="
ls -lh "$SCRATCH/data/subsample"

echo "===== READ STATISTICS ====="

seqkit stats -a \
  "$SCRATCH"/data/subsample/*.fastq.gz \
  > "$PROJECT/results/stats/read_statistics.txt"

echo "===== FASTQC ====="

fastqc -t 2 \
  "$SCRATCH"/data/subsample/*.fastq.gz \
  -o "$PROJECT/results/fastqc"

echo "===== COMPLETE ====="
date
