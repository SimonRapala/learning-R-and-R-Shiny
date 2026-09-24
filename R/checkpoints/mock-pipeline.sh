#!/usr/bin/env bash

mode="$1"
output_file="$2"

echo "Starting mock pipeline"
echo "Processing sample reads"

if [ "$mode" = "success" ]; then
  echo "sampleName,totalReads" > "$output_file"
  echo "BR5_1,125000" >> "$output_file"

  echo "Mock pipeline completed successfully"
  exit 0
else
  echo "Mock pipeline failed during processing" >&2
  exit 1
fi