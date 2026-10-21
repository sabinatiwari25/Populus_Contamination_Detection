import csv
from pathlib import Path

base = Path.home() / "Week9_Populus"

for dataset in ["DNA", "RNA"]:

    report = base / "results" / "kraken" / f"{dataset}_report.txt"
    output = base / "results" / "summary" / f"{dataset}_microbial_candidates.tsv"

    stack = []
    results = []

    with open(report) as f:
        for line in f:
            fields = line.rstrip("\n").split("\t")

            if len(fields) < 6:
                continue

            direct_count = int(fields[2].strip())
            rank = fields[3].strip()
            taxid = fields[4].strip()

            raw_name = fields[5]
            indent = len(raw_name) - len(raw_name.lstrip())
            name = raw_name.strip()

            while stack and stack[-1][0] >= indent:
                stack.pop()

            stack.append((indent, name))

            lineage = [item[1] for item in stack]

            group = None

            if "Bacteria" in lineage:
                group = "Bacteria"
            elif "Archaea" in lineage:
                group = "Archaea"
            elif "Fungi" in lineage:
                group = "Fungi"

            if group and rank == "S" and direct_count > 0:
                results.append(
                    (direct_count, group, taxid, name)
                )

    results.sort(reverse=True)

    with open(output, "w", newline="") as f:
        writer = csv.writer(f, delimiter="\t")
        writer.writerow(
            ["direct_assignments", "group", "taxid", "species"]
        )
        writer.writerows(results)

    print(f"\n===== {dataset} MICROBIAL SPECIES =====")
    print("Number of species:", len(results))

    for count, group, taxid, name in results[:20]:
        print(f"{count}\t{group}\t{taxid}\t{name}")

    print("Saved:", output)
