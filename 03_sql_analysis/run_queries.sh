#!/usr/bin/env bash
# Runs every query in 03_sql_analysis/queries/ and saves each result as a CSV in 03_sql_analysis/results/.
# Run from the project root:  bash 03_sql_analysis/run_queries.sh [db_user] [db_name]
DB_USER="${1:-postgres}"
DB_NAME="${2:-kenya_retail}"
OUT="03_sql_analysis/results"
mkdir -p "$OUT"

for f in 03_sql_analysis/queries/*.sql; do
  name=$(basename "$f" .sql)
  # \copy needs the query on one line without comments or a trailing semicolon
  q=$(sed '/^[[:space:]]*--/d' "$f" | tr '\n' ' ' | sed 's/;[[:space:]]*$//')
  psql -U "$DB_USER" -d "$DB_NAME" -v ON_ERROR_STOP=1 -q -c "\\copy ($q) TO '$OUT/$name.csv' CSV HEADER" || exit 1
  echo "wrote $OUT/$name.csv ($(($(wc -l < "$OUT/$name.csv") - 1)) rows)"
done
