# Week 9: Contamination Detection in Populus trichocarpa

## Project Overview

This project investigates potential non-target sequences
in DNA whole-genome sequencing (WGS) and RNA-seq datasets
from Populus trichocarpa.

Taxonomic classification was performed with Kraken2.
Candidate detections were subsequently evaluated using
competitive reference mapping and sequence analysis.

## Datasets

| Dataset | Sequencing type | Analyzed reads |
|---------|-----------------|----------------|
| SRR36001243 | DNA WGS, paired-end | First 100,000 read pairs |
| SRR3241527 | RNA-seq, single-end | First 100,000 reads |

## Computational Environment

Analyses were conducted on the Alabama Supercomputer Center
using PBS job scheduling.

Software:
- SRA Toolkit
- FastQC
- SeqKit
- Kraken2
- Bowtie2
- SAMtools
- NCBI Datasets
- Python

The software environment is documented in environment.yml.

## Reference Genomes

- Populus trichocarpa: GCF_000002775.5
- Homo sapiens GRCh38.p14: GCF_000001405.40
- Wolbachia endosymbiont: GCF_013365435.1
- Iamia sp. SCSIO 61187: GCF_019443745.1
- Kosakonia cowanii: GCF_025758125.1

Kraken2 database: PlusPFP-8, February 26, 2026.

## Analysis Workflow

1. Download and subsample DNA and RNA-seq reads.
2. Assess sequencing quality using FastQC.
3. Identify unexpected taxonomic assignments using Kraken2.
4. Extract selected candidate reads using SeqKit.
5. Perform competitive reference mapping using Bowtie2.
6. Evaluate alignments using SAMtools.
7. Validate RNA candidates against Populus transcripts.
8. Compare microbial candidates against microbial references.
9. Calculate read fractions, reference breadth, and mean depth.
10. Summarize and interpret candidate detections.

## Major Findings

DNA WGS:
- 124 read pairs were initially classified as human.
- No selected reads aligned to human in competitive mapping.
- Four Wolbachia-classified read pairs showed duplicate-like
  alignments to one Populus genomic fragment location.

RNA-seq:
- 15 reads were initially classified as human.
- Three reads aligned preferentially to the human genome.
- These three reads had zero mismatches across aligned bases.
- No annotated Populus transcript matches were identified
  for these three reads under the tested settings.
- Iamia and Kosakonia candidates preferentially aligned
  to Populus in competitive mapping.

The RNA human signal remains a possible trace detection,
not confirmed contamination.

## Project Files

- scripts/: Bash, Python, and PBS analysis scripts.
- results/summary/: Detection tables and quantitative results.
- results/stats/: Sequencing read statistics.
- docs/Workflow_Summary.md: Detailed computational workflow.
- environment.yml: Software environment specification.

## Reproducibility and Limitations

The analyses used the first 100,000 sequencing fragments
or reads rather than randomized whole-run subsamples.

Large reference genomes, sequencing reads, Bowtie2 indexes,
and Kraken2 databases are excluded from this repository.

Results should be interpreted with consideration of
low read counts, reference limitations, and the absence
of experimental negative controls.
