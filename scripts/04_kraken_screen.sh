#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

PROJECT="$HOME/Week9_Populus"
SCRATCH="/scratch/$USER/Week9_Populus"

DB="$SCRATCH/kraken_db/pluspfp8_20260226"
READS="$SCRATCH/data/subsample"
OUT="$PROJECT/results/kraken"

mkdir -p "$OUT"

echo "===== KRAKEN2 ANALYSIS START ====="
date
hostname

echo "===== VERIFY DATABASE ====="

for f in hash.k2d opts.k2d taxo.k2d; do
    test -s "$DB/$f" || {
        echo "ERROR: Missing $f"
        exit 1
    }
done

echo "===== DNA CLASSIFICATION ====="

kraken2 \
  --db "$DB" \
  --threads 2 \
  --paired \
  --gzip-compressed \
  --report "$OUT/DNA_report.txt" \
  --output "$OUT/DNA_classifications.txt" \
  "$READS/SRR36001243_1.fastq.gz" \
  "$READS/SRR36001243_2.fastq.gz"

echo "===== RNA CLASSIFICATION ====="

kraken2 \
  --db "$DB" \
  --threads 2 \
  --gzip-compressed \
  --report "$OUT/RNA_report.txt" \
  --output "$OUT/RNA_classifications.txt" \
  "$READS/SRR3241527_1.fastq.gz"

echo "===== ANALYSIS COMPLETE ====="
date
