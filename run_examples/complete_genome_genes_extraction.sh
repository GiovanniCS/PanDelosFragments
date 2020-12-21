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
  n_of_sequences=` grep ">" $genome | wc | awk '{print $1}'`
  if [[ "$n_of_sequences" -eq "1" ]]
  then
    ../Prodigal/prodigal -i $genome -o $output_folder/ProdigalOutput.txt
    python3 coordinates_and_extaction.py $output_folder $genome
  else
    echo "ERROR: Your fasta file must contain exactly 1 sequence"
  fi
else
  echo "ERROR: You need to provide an absolute path to a complete genome sequence"
fi