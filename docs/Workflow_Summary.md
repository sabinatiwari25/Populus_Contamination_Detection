# Workflow Summary
## Contamination Detection in Populus trichocarpa Sequencing Data

### 1. Objective

The objective of this analysis was to detect, quantify,
and evaluate potential non-target sequences in DNA WGS
and RNA-seq datasets from Populus trichocarpa.

### 2. Datasets

DNA WGS: SRR36001243
- Paired-end sequencing
- First 100,000 read pairs analyzed

RNA-seq: SRR3241527
- Single-end sequencing
- First 100,000 reads analyzed

### 3. Computational Environment

The analysis was conducted on the Alabama Supercomputer
Center using PBS job scheduling.

Software included SRA Toolkit, FastQC, SeqKit, Kraken2,
Bowtie2, SAMtools, NCBI Datasets, Python, and Conda.

### 4. Analysis Workflow

Step 1: Sequencing data retrieval
- Downloaded sequencing reads from NCBI SRA.
- Prepared DNA and RNA-seq subsamples.

Step 2: Quality assessment
- Evaluated sequencing quality using FastQC.
- Calculated read statistics using SeqKit.

Step 3: Taxonomic classification
- Screened sequencing reads using Kraken2.
- Used the PlusPFP-8 database from February 26, 2026.
- Identified unexpected taxonomic assignments.

Step 4: Candidate read extraction
- Extracted selected non-target reads using SeqKit.
- Preserved both mates for paired-end DNA reads.

Step 5: Competitive reference mapping
- Aligned reads against combined host and non-target
  references using Bowtie2.
- Evaluated MAPQ, alignment scores, mismatches,
  and genomic positions using SAMtools.

Step 6: Transcriptome validation
- Compared three human-aligning RNA reads against
  59,542 annotated Populus RNA sequences.

Step 7: Microbial validation
- Evaluated Wolbachia, Iamia, and Kosakonia candidates.
- Compared candidate reads against host and selected
  microbial reference genomes.
- Investigated duplicate-like reads and sequence complexity.

Step 8: Detection assessment
- Summarized initial Kraken2 read fractions.
- Evaluated mapping specificity and reference coverage.
- Assigned provisional significance classifications.

### 5. Major Findings

DNA WGS:
- Kraken2 assigned 124 of 100,000 DNA read pairs to human.
- Competitive mapping found zero human-aligned reads.
- A total of 200 individual reads aligned to Populus.
- Four Wolbachia-classified DNA pairs mapped to the
  same Populus genomic fragment coordinates.

RNA-seq:
- Kraken2 assigned 15 of 100,000 RNA reads to human.
- Three reads aligned to the human reference with
  zero mismatches across their aligned regions.
- These three reads did not align to the annotated
  Populus transcriptome under the tested settings.
- Human reference breadth was 0.0000088224%.
- Human reference mean depth was 0.000000088224X.
- Selected Iamia and Kosakonia reads aligned
  preferentially to Populus.

### 6. Interpretation

Most selected microbial classifications were more
consistent with host-derived sequences than confirmed
microbial contamination.

Three human-aligning RNA reads represented a possible
trace non-target signal requiring further validation.

### 7. Limitations

- Only the first 100,000 sequencing spots or reads
  were analyzed from each dataset.
- Low read counts limit conclusions about contamination.
- Reference databases and annotations may be incomplete.
- No experimental negative controls were analyzed.
- The origin of the human-aligning RNA reads remains
  provisional.

### 8. Reproducibility

Analysis scripts are stored in scripts/.
Quantitative results are stored in results/.
Software environment information is stored in environment.yml.

The computational workflow was executed using PBS
jobs on the Alabama Supercomputer Center.
