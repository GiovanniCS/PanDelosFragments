#!/bin/bash

output_folder=$1
mkdir ${output_folder}/spades_output
python3 SPAdes-3.14.0-Linux/bin/spades.py -o ${output_folder}/spades_output \
  -s ${output_folder}/symulated_fragments/simulated_data_read1.fq
cp ${output_folder}/spades_output/contigs.fasta ${output_folder}/symulated_fragments/temp_simulated_fragmented_genome.fna
rm -rf ${output_folder}/spades_output