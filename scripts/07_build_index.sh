#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

BASE="/scratch/$USER/Week9_Populus"
REF="$BASE/references"
INDEX="$BASE/index"

mkdir -p "$INDEX"

echo "===== BUILD COMBINED REFERENCE ====="
date
hostname

# Prefix contig names so the reference source is clear
awk '/^>/{sub(/^>/,">human|")} {print}' \
  "$REF/human/human.fa" \
  > "$INDEX/combined.fa"

awk '/^>/{sub(/^>/,">populus|")} {print}' \
  "$REF/populus/populus.fa" \
  >> "$INDEX/combined.fa"

echo "===== VERIFY COMBINED FASTA ====="

samtools faidx "$INDEX/combined.fa"

echo "===== BUILD BOWTIE2 INDEX ====="

bowtie2-build --threads 4 \
  "$INDEX/combined.fa" \
  "$INDEX/human_populus"

echo "===== INDEX COMPLETE ====="
date
