#!/bin/bash

cd $1
sql /nolog <<EOF
connect $3
set ddl storage off
set ddl partitioning off
set ddl segment_attributes off
set ddl tablespace off
set ddl emit_schema off
lb update -changelog-file $2
EOF
