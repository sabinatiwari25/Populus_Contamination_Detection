#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"
conda activate populus_contamination

PROJECT="$HOME/Week9_Populus"
BASE="/scratch/$USER/Week9_Populus"

REF="$BASE/references/microbes"
HOST="$BASE/references/populus/populus.fa"

OUT="$PROJECT/results/validation/microbes/competitive"
INDEXDIR="$BASE/index/microbial_competitive"

mkdir -p "$OUT" "$INDEXDIR"

COMBINED="$INDEXDIR/combined_microbes_populus.fa"
INDEX="$INDEXDIR/microbes_populus"

echo "===== START ====="
date

echo "===== VERIFY REFERENCES ====="

test -s "$HOST"

WOL=$(find "$REF/Wolbachia" -name '*genomic.fna' -type f | head -1)
IAM=$(find "$REF/Iamia" -name '*genomic.fna' -type f | head -1)
KOS=$(find "$REF/Kosakonia" -name '*genomic.fna' -type f | head -1)

test -n "$WOL"
test -n "$IAM"
test -n "$KOS"

echo "===== BUILD COMBINED FASTA ====="

awk '/^>/ {sub(/^>/,">populus|"); print; next} {print}' "$HOST" > "$COMBINED"

awk '/^>/ {sub(/^>/,">wolbachia|"); print; next} {print}' "$WOL" >> "$COMBINED"

awk '/^>/ {sub(/^>/,">iamia|"); print; next} {print}' "$IAM" >> "$COMBINED"

awk '/^>/ {sub(/^>/,">kosakonia|"); print; next} {print}' "$KOS" >> "$COMBINED"

echo "===== BUILD BOWTIE2 INDEX ====="

bowtie2-build --threads 4 "$COMBINED" "$INDEX" \
  > "$OUT/index_build.log" 2>&1

echo "===== ALIGN DNA WOLBACHIA CANDIDATES ====="

bowtie2 --very-sensitive-local \
  -x "$INDEX" \
  -1 "$PROJECT/results/validation/microbes/DNA_Wolbachia_R1.fastq.gz" \
  -2 "$PROJECT/results/validation/microbes/DNA_Wolbachia_R2.fastq.gz" \
  -X 1000 -p 4 \
  2> "$OUT/DNA_Wolbachia.log" \
  | samtools view -b -o "$OUT/DNA_Wolbachia.bam" -

echo "===== ALIGN RNA IAMIA CANDIDATES ====="

bowtie2 --very-sensitive-local \
  -x "$INDEX" \
  -U "$PROJECT/results/validation/microbes/RNA_Iamia.fastq.gz" \
  -p 4 \
  2> "$OUT/RNA_Iamia.log" \
  | samtools view -b -o "$OUT/RNA_Iamia.bam" -

echo "===== ALIGN RNA KOSAKONIA CANDIDATE ====="

bowtie2 --very-sensitive-local \
  -x "$INDEX" \
  -U "$PROJECT/results/validation/microbes/RNA_Kosakonia.fastq.gz" \
  -p 4 \
  2> "$OUT/RNA_Kosakonia.log" \
  | samtools view -b -o "$OUT/RNA_Kosakonia.bam" -

echo "===== CREATE SPECIES COMPARISON TABLE ====="

printf 'sample\tread_id\treference\tposition\tMAPQ\tCIGAR\tAS\tNM\n' \
  > "$OUT/species_comparison.tsv"

for SAMPLE in DNA_Wolbachia RNA_Iamia RNA_Kosakonia
do
    samtools view -F 2308 "$OUT/${SAMPLE}.bam" |
    awk -v sample="$SAMPLE" -F '\t' '
    {
        as="NA"
        nm="NA"

        for(i=12;i<=NF;i++){
            if($i ~ /^AS:i:/){
                split($i,a,":")
                as=a[3]
            }
            if($i ~ /^NM:i:/){
                split($i,a,":")
                nm=a[3]
            }
        }

        print sample "\t" $1 "\t" $3 "\t" $4 "\t" $5 "\t" $6 "\t" as "\t" nm
    }' >> "$OUT/species_comparison.tsv"
done

echo "===== VALIDATION COMPLETE ====="
date
