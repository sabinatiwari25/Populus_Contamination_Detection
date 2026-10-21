#!/bin/bash
set -euo pipefail

DB="/scratch/$USER/Week9_Populus/kraken_db/pluspfp8_20260226"

mkdir -p "$DB"
cd "$DB"

echo "===== DATABASE DOWNLOAD START ====="
date
hostname

URL="https://genome-idx.s3.amazonaws.com/kraken/k2_pluspfp_08_GB_20260226.tar.gz"

curl -fL --retry 3 -C - \
  -o kraken_database.tar.gz "$URL"

echo "===== EXTRACTING DATABASE ====="

tar -xzf kraken_database.tar.gz

echo "===== VERIFYING DATABASE ====="

for f in hash.k2d opts.k2d taxo.k2d; do
    test -s "$f" || {
        echo "ERROR: Missing database file: $f"
        exit 1
    }
done

echo "===== DATABASE READY ====="
ls -lh *.k2d
date
