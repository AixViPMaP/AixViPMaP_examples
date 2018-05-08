#!/bin/bash

# $1 = Number of dummy files to be transferred from
#      execute node to scheduler node.  Default: 10
fileCount=${1:-10}

for ((id=1; id<=$fileCount; id++)); do
  # Define source file (on execute node)
  srcFile=src_$id.txt
  # Define destination file (on scheduler node)
  destFile=dest_$id.txt

  # Create source file
  date > $srcFile

  # Use Chirp to transfer source file to destination file
  echo "Transfer $srcFile"
  $(condor_config_val LIBEXEC)/condor_chirp put $srcFile $destFile

  sleep 30
done
