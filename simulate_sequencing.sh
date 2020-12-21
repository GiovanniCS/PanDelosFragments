#!/bin/bash

genome=$1
output_folder=$2
#With neat-genreads simulate the seguencing procedure with 150b long reads, aploid genome and targeted region
python ./neat-genreads-master/genReads.py -r ${genome} -R 150 -p 1 \
  -t ${output_folder}/targets.bed -o ${output_folder}/simulated_data