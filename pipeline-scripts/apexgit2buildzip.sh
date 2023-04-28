#!/bin/bash
# APEX Create Build Zip from Git Workarea
#----------------------------------------
# $1 = Git workarea for APEX App
# $2 - Build number
#-----------------------------
curDir=${PWD}
pushd $1 > /dev/null
dirToZip="${PWD##*/}"
cd ..
zip -r $curDir/${dirToZip}_$2.zip \
    $dirToZip/install.sql \
    $dirToZip/application \
    $dirToZip/database \
    $dirToZip/workspace \
    $dirToZip/changelogs \
    $dirToZip/deploy \
    $dirToZip/other_schemas \
    $dirToZip/data
popd > /dev/null
