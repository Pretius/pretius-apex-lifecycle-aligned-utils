#!/bin/bash
# APEX Export to Git
#-----------------------------
# $1 = APEX App Id
# $2 = Git workarea directory
# $3 = DB connection string
# $4 = Temp Folder
#-----------------------------
cd $4
# Export APEX application and schema to stage directory
{
echo connect $3
echo apex export -applicationid $1 -split -skipExportDate -expOriginalIds -expSupportingObjects Y -expType APPLICATION_SOURCE,READABLE_YAML
echo lb generate-schema -split
} | sql /nolog
# Copy APEX application export files in the ./fNNN subdirectory to Git Working Area directory
rsync --delete --recursive $4/f$1/* $2
# Remove APEX export files, leaving only Liquibase DB export artifacts
rm -rf $4/f$1
# Copy the Liquibase DB export artifacts to ./database subdir of Git Working Area
rsync --delete --recursive $4/* $2/database
# Change directory to the Git Workarea 
cd $2
# Add all changed files to the Git worklist from any subdirectory
git add .
