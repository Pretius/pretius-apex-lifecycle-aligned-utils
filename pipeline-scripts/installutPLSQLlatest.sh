#!/bin/bash
cd $1
curl -LOk $(curl --silent https://api.github.com/repos/utPLSQL/utPLSQL/releases/latest | awk '/browser_download_url/ { print $2 }' | grep ".zip\"" | sed 's/"//g') 
unzip -q utPLSQL.zip
rm $1/utPLSQL.zip
cd $1/utPLSQL/source
sql $2 AS SYSDBA @install_headless.sql
rm -rf $1/utPLSQL
