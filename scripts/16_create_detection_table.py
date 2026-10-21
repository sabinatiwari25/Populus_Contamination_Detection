import csv
from pathlib import Path

out = Path.home() / "Week9_Populus/results/summary"
out.mkdir(parents=True, exist_ok=True)

rows = [
    {
        "dataset": "SRR36001243",
        "library": "DNA_WGS",
        "candidate": "Homo sapiens",
        "kraken_count": 124,
        "denominator": 100000,
        "count_unit": "read_pairs",
        "kraken_fraction_percent": 0.124,
        "candidate_mapped_to_target": 0,
        "candidate_mapped_to_populus": 200,
        "alignment_unit": "individual_reads",
        "target_breadth_percent": 0,
        "target_mean_depth_x": 0,
        "classification": "noise_provisional"
    },
    {
        "dataset": "SRR36001243",
        "library": "DNA_WGS",
        "candidate": "Wolbachia endosymbiont",
        "kraken_count": 4,
        "denominator": 100000,
        "count_unit": "read_pairs",
        "kraken_fraction_percent": 0.004,
        "candidate_mapped_to_target": 0,
        "candidate_mapped_to_populus": 8,
        "alignment_unit": "individual_reads",
        "target_breadth_percent": 0,
        "target_mean_depth_x": 0,
        "classification": "noise_provisional"
    },
    {
        "dataset": "SRR3241527",
        "library": "RNA_seq",
        "candidate": "Homo sapiens",
        "kraken_count": 15,
        "denominator": 100000,
        "count_unit": "reads",
        "kraken_fraction_percent": 0.015,
        "candidate_mapped_to_target": 3,
        "candidate_mapped_to_populus": 12,
        "alignment_unit": "individual_reads",
        "target_breadth_percent": 0.0000088224,
        "target_mean_depth_x": 0.000000088224,
        "classification": "possible_trace"
    },
    {
        "dataset": "SRR3241527",
        "library": "RNA_seq",
        "candidate": "Iamia sp.",
        "kraken_count": 2,
        "denominator": 100000,
        "count_unit": "reads",
        "kraken_fraction_percent": 0.002,
        "candidate_mapped_to_target": 0,
        "candidate_mapped_to_populus": 2,
        "alignment_unit": "individual_reads",
        "target_breadth_percent": 0,
        "target_mean_depth_x": 0,
        "classification": "likely_noise"
    },
    {
        "dataset": "SRR3241527",
        "library": "RNA_seq",
        "candidate": "Kosakonia cowanii",
        "kraken_count": 1,
        "denominator": 100000,
        "count_unit": "reads",
        "kraken_fraction_percent": 0.001,
        "candidate_mapped_to_target": 0,
        "candidate_mapped_to_populus": 1,
        "alignment_unit": "individual_reads",
        "target_breadth_percent": 0,
        "target_mean_depth_x": 0,
        "classification": "likely_noise"
    }
]

path = out / "final_detection_table.tsv"

with path.open("w", newline="") as handle:
    writer = csv.DictWriter(
        handle,
        fieldnames=list(rows[0]),
        delimiter="\t"
    )
    writer.writeheader()
    writer.writerows(rows)

print("Created:", path)
print("Number of detections:", len(rows))
