#!/usr/bin/env bash
# Rebuilds data, cleaned tables, analysis notebooks and dashboard tables, in order.
# Run from the project root:   bash run_all.sh
# Use another interpreter:     PYTHON=~/anaconda3/python.exe bash run_all.sh
set -euo pipefail
PY="${PYTHON:-python}"

run_nb() {
  echo ">> $1"
  "$PY" -m jupyter nbconvert --to notebook --execute --inplace "$1"
}

echo ">> 1. Generate synthetic data"
"$PY" src/data_generation/generate_data.py
run_nb 01_cleaning/01_cleaning.ipynb
run_nb 02_eda/02_eda.ipynb
run_nb statistical_analysis/statistical_analysis.ipynb
run_nb 04_forecasting/forecasting.ipynb
echo ">> 6. Dashboard tables"
"$PY" 05_dashboard/prepare_dashboard_data.py

echo "Done. The SQL step (needs PostgreSQL) and the Power BI file are separate: see README.md."
