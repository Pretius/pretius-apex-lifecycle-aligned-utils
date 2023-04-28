#!/bin/bash
full_dir_name="$2"

for folder in "$full_dir_name"/*; do
  if [[ -d "$folder" ]]; then
    pushd "$folder" > /dev/null || exit
    dir_name=$(basename "$folder")
cd $folder
sql /nolog <<EOF
connect $dir_name/$3@//$1
set ddl storage off
set ddl partitioning off
set ddl segment_attributes off
set ddl tablespace off
set ddl emit_schema off
lb update -changelog-file controller.xml
EOF
    popd > /dev/null || exit
  fi
done

