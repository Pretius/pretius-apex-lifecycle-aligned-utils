#!/bin/bash

# Recreate the temporary stage directory and change directory to it
if [ -d $1 ]
then
   rm -rf $1
fi
mkdir -p $1
