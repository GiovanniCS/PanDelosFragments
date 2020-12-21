#!/bin/bash
cd `dirname $0`
genome=$1
output_folder=$2
if [[ -f $genome ]]
then
  if [[ ! -d $output_folder ]]
    then
      mkdir -p $output_folder
  fi
  ../Prodigal/prodigal -d $output_folder/prodigal_sequences.fna -i $genome -o $output_folder/ProdigalOutput.txt
  python3 filter_prodigal_sequences.py $output_folder $genome
else
  echo "ERROR: You need to provide an absolute path to a complete genome sequence"
fi