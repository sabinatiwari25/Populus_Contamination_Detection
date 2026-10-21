#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

BASE="/scratch/$USER/Week9_Populus/references"

mkdir -p "$BASE/human" "$BASE/populus"

echo "===== DOWNLOAD START ====="
date
hostname

echo "===== HUMAN GRCh38 ====="

cd "$BASE/human"

datasets download genome accession GCF_000001405.40 \
  --include genome \
  --filename human_GRCh38.zip

unzip -oq human_GRCh38.zip -d extracted

HUMAN_FA=$(find extracted/ncbi_dataset/data \
  -name "*.fna" -type f | head -1)

test -n "$HUMAN_FA"
ln -sfn "$(realpath "$HUMAN_FA")" human.fa

echo "===== POPULUS TRICHOCARPA ====="

cd "$BASE/populus"

datasets download genome accession GCF_000002775.5 \
  --include genome \
  --filename populus_v4.1.zip

unzip -oq populus_v4.1.zip -d extracted

POPULUS_FA=$(find extracted/ncbi_dataset/data \
  -name "*.fna" -type f | head -1)

test -n "$POPULUS_FA"
ln -sfn "$(realpath "$POPULUS_FA")" populus.fa

echo "===== VERIFY FILES ====="

test -s "$BASE/human/human.fa"
test -s "$BASE/populus/populus.fa"

ls -lhL "$BASE/human/human.fa"
ls -lhL "$BASE/populus/populus.fa"

echo "===== DOWNLOAD COMPLETE ====="
date
