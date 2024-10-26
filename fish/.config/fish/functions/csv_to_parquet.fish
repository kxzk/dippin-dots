function csv_to_parquet
    set -l file_path $argv[1]
    set -l base_name (string replace -r '\.csv$' '' $file_path)
    duckdb -c "COPY (SELECT * FROM read_csv_auto('$file_path')) TO '$base_name.parquet' (FORMAT PARQUET);"
end
