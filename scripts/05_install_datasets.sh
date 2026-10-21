#!/bin/bash
set -euo pipefail

source "$HOME/miniforge3_week9/etc/profile.d/conda.sh"

conda install \
  -n populus_contamination \
  -c conda-forge \
  --strict-channel-priority \
  ncbi-datasets-cli -y

conda activate populus_contamination

echo "===== NCBI DATASETS VERSION ====="
datasets version

echo "===== INSTALLATION COMPLETE ====="
