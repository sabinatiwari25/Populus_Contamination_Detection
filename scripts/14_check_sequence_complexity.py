import gzip
import math
from collections import Counter
from pathlib import Path

base = Path.home() / "Week9_Populus/results/validation/microbes"

files = [
    "DNA_Wolbachia_R1.fastq.gz",
    "DNA_Wolbachia_R2.fastq.gz",
    "RNA_Iamia.fastq.gz",
    "RNA_Kosakonia.fastq.gz",
]

print("File\tRead_ID\tLength\tGC_percent\tEntropy_bits")

for filename in files:
    with gzip.open(base / filename, "rt") as handle:
        while True:
            header = handle.readline()
            if not header:
                break

            seq = handle.readline().strip().upper()
            handle.readline()
            handle.readline()

            counts = Counter(seq)
            n = len(seq)

            gc = 100 * (counts["G"] + counts["C"]) / n

            entropy = -sum(
                (count / n) * math.log2(count / n)
                for base, count in counts.items()
                if base in "ACGT"
            )

            print(
                f"{filename}\t{header.split()[0][1:]}\t"
                f"{n}\t{gc:.2f}\t{entropy:.3f}"
            )
