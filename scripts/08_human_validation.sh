#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

PROJECT="$HOME/Week9_Populus"
BASE="/scratch/$USER/Week9_Populus"

INDEX="$BASE/index/human_populus"
READS="$PROJECT/results/validation/human"
OUT="$PROJECT/results/validation/human_mapping"

mkdir -p "$OUT"

echo "===== START COMPETITIVE MAPPING ====="
date
hostname

echo "===== VERIFY INPUT FILES ====="

test -s "$READS/DNA_human_R1.fastq.gz"
test -s "$READS/DNA_human_R2.fastq.gz"
test -s "${INDEX}.1.bt2"
test -s "${INDEX}.rev.2.bt2"

echo "===== ALIGN DNA READS ====="

bowtie2 \
  --very-sensitive \
  -x "$INDEX" \
  -1 "$READS/DNA_human_R1.fastq.gz" \
  -2 "$READS/DNA_human_R2.fastq.gz" \
  -X 1000 \
  -p 4 \
  2> "$OUT/DNA_bowtie2.log" \
  | samtools sort \
      -@ 2 \
      -m 2G \
      -o "$OUT/DNA_competitive.sorted.bam" -

echo "===== INDEX BAM ====="

samtools index "$OUT/DNA_competitive.sorted.bam"

echo "===== FLAGSTAT ====="

samtools flagstat \
  "$OUT/DNA_competitive.sorted.bam" \
  > "$OUT/DNA_flagstat.txt"

echo "===== COVERAGE ====="

samtools coverage -q 20 -Q 20 \
  "$OUT/DNA_competitive.sorted.bam" \
  > "$OUT/DNA_coverage.tsv"

echo "===== INDEX STATISTICS ====="

samtools idxstats \
  "$OUT/DNA_competitive.sorted.bam" \
  > "$OUT/DNA_idxstats.tsv"

echo "===== MAPPING COMPLETE ====="
date
