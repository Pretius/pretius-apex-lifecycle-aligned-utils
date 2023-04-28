#!/bin/bash

db="$1"            #sys/E@//localhost:8521/FREEPDB1
repo_dir="$2"      #/home/opc/z
scripts_location="$3"
full_dir_name="$2"/other_schemas
p_default_owner=$(grep 'p_default_owner' "$2"/application/set_environment.sql | cut -d"'" -f2)

sql $1  AS SYSDBA @$scripts_location/create_db_user.sql $p_default_owner E

for folder in "$full_dir_name"/*; do
  if [[ -d "$folder" ]]; then
    pushd "$folder" > /dev/null || exit
    dir_name=$(basename "$folder")
    echo $dir_name
    sql $1 AS SYSDBA @$scripts_location/create_db_user.sql $dir_name E
    popd > /dev/null || exit
  fi
done
cd $scripts_location