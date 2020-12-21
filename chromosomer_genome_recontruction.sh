#!/bin/bash

genome=$1
output_folder=$2
fragmented_genome_file=$3

reconstructed_genome_name="${output_folder}/results/${genome}_chromosomer_reconstructed_genome.fna"
reference_genome_name="${output_folder}/artifacts/candidate_genome.fna"
random_code=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 5 | head -n 1`
reconstructed_genome_first_line=`cat ${reference_genome_name} | head -n1 | cut -d" " -f1`
reconstructed_genome_first_line="${reconstructed_genome_first_line}reconstructed_${random_code}"

chromosomer fastalength ${fragmented_genome_file} "${output_folder}/artifacts/fastalength.txt"
ncbi-blast-2.10.0+/blastn -query $fragmented_genome_file -subject ${reference_genome_name} -outfmt 6 \
  > "${output_folder}/artifacts/chromosomer_blast_output"
chromosomer fragmentmap "${output_folder}/artifacts/chromosomer_blast_output" 0 "${output_folder}/artifacts/fastalength.txt" \
  "${output_folder}/artifacts/chromosomer_map"
chromosomer assemble "${output_folder}/artifacts/chromosomer_map" ${fragmented_genome_file} ${reconstructed_genome_name}
sequence=`tail --lines=+2 ${reconstructed_genome_name}`
echo ${reconstructed_genome_first_line} > ${reconstructed_genome_name}
for s in $sequence
do
  echo ${s} >> ${reconstructed_genome_name}
done