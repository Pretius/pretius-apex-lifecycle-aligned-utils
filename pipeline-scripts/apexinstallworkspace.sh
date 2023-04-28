#!/bin/bash

# Check if $1 is a directory
if [[ ! -d "$1" ]]; then
  echo "$1 is not a directory"
  exit 1
fi

# Loop over files in $1
for file in "$1"/*; do
  # Check if $file is a regular file
  if [[ -f "$file" ]]; then
sql /nolog <<EOF
connect $2 AS SYSDBA
@"$file"
EOF
  fi
done