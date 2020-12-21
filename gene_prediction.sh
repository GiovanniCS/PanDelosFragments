#!/bin/bash

genome=$1
output_folder=$2
Prodigal/prodigal -i ${output_folder}/results/${genome}_reconstructed_genome.fna \
  -o ${output_folder}/results/${genome}_predictedCDSs
