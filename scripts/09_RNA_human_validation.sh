#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

PROJECT="$HOME/Week9_Populus"
INDEX="/scratch/$USER/Week9_Populus/index/human_populus"
READS="$PROJECT/results/validation/human/RNA_human.fastq.gz"
OUT="$PROJECT/results/validation/RNA_human_mapping"

mkdir -p "$OUT"

echo "===== RNA MAPPING START ====="
date
hostname

echo "===== VERIFY INPUTS ====="
test -s "$READS"
test -s "${INDEX}.1.bt2"
test -s "${INDEX}.rev.2.bt2"

echo "===== BOWTIE2 ALIGNMENT ====="

bowtie2 \
  --very-sensitive-local \
  -x "$INDEX" \
  -U "$READS" \
  -p 4 \
  2> "$OUT/RNA_bowtie2.log" \
  | samtools sort \
      -@ 2 \
      -m 2G \
      -o "$OUT/RNA_competitive.sorted.bam" -

echo "===== INDEX BAM ====="

samtools index "$OUT/RNA_competitive.sorted.bam"

echo "===== FLAGSTAT ====="

samtools flagstat \
  "$OUT/RNA_competitive.sorted.bam" \
  > "$OUT/RNA_flagstat.txt"

echo "===== REFERENCE COVERAGE ====="

samtools coverage -q 20 -Q 20 \
  "$OUT/RNA_competitive.sorted.bam" \
  > "$OUT/RNA_coverage.tsv"

echo "===== REFERENCE ALIGNMENT COUNTS ====="

samtools view -F 2308 \
  "$OUT/RNA_competitive.sorted.bam" | \
  awk '
  $3 ~ /^human\|/ {human++}
  $3 ~ /^populus\|/ {populus++}
  END {
    print "Human mapped:", human+0
    print "Populus mapped:", populus+0
  }' > "$OUT/RNA_species_counts.txt"

echo "===== HIGH-CONFIDENCE ALIGNMENTS ====="

samtools view -F 2308 -q 20 \
  "$OUT/RNA_competitive.sorted.bam" | \
  awk '
  $3 ~ /^human\|/ {human++}
  $3 ~ /^populus\|/ {populus++}
  END {
    print "Human MAPQ >=20:", human+0
    print "Populus MAPQ >=20:", populus+0
  }' > "$OUT/RNA_MAPQ20_counts.txt"

echo "===== RNA MAPPING COMPLETE ====="
date
