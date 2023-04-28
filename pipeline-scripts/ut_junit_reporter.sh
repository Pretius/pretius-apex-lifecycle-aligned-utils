#!/bin/bash
ut_results_dir="$2/ut_junit_reporter"

echo "$ut_results_dir"


rm -rf "$ut_results_dir"
mkdir "$ut_results_dir"

sql /nolog <<EOF
connect $1
set serveroutput on
set feedback off
spool $ut_results_dir/results.xml
exec ut.run(ut_junit_reporter());
spool off
EOF
