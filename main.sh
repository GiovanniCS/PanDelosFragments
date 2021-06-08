#!/bin/bash
cd `dirname $0`

chmod +x align_to_candidate_genome.sh
chmod +x align_to_reconstructed_genome.sh
chmod +x gene_prediction.sh
chmod +x chromosomer_genome_recontruction.sh

genome=$1
if [[ -f $genome ]]
then
  reference_genome=$3
  if [[ -z "$reference_genome" ||  ! -f $reference_genome ]]
  then
    echo "ERROR: you must specify the full path to a reference genome file or the keyword 'prokaryotic' for searching in the local db"
  else
    if [[ $reference_genome == p* ]]
    then
      reference_genome="prokaryotic"
    fi
    output_folder=$2
    if [[ ! -d $output_folder ]]
    then
      mkdir -p $output_folder
    fi
    echo "Using reference genome from: ${reference_genome}"

    rm -rf ${output_folder}/results && mkdir ${output_folder}/results
    rm -rf ${output_folder}/original_genome && mkdir ${output_folder}/original_genome
    rm -rf ${output_folder}/artifacts && mkdir ${output_folder}/artifacts
    genome_taxon=`head -n1 ${genome} | cut -d" " -f2 | cut -d">" -f2`

    genome_file="${output_folder}/original_genome/${genome_taxon}_reference_genome.fna"
    cp $genome $genome_file
    genome=$genome_taxon

    if [[ $reference_genome == "prokaryotic" ]]
    then
      #Using BLAST, find the most similar genome in the ref_prok_rep_genomes db to the contigs assembled
      python3 find_candidate_genome.py $output_folder $reference_genome $genome_file
    else
      cp $reference_genome ${output_folder}/artifacts/candidate_genome.fna
    fi


    #Using bwa and samtools align the contigs to the reference genome
    ./align_to_candidate_genome.sh $genome $output_folder $genome_file

    #Pull down missing bases in the aligned contigs set from the reference genome
    python3 genome_recontruction.py $genome $output_folder

    #Chromosomer variant of the pipeline
    #./chromosomer_genome_recontruction.sh $genome $output_folder $genome_file
    #python3 chromosomer_filter_unused_sequences.py $genome_file $output_folder

    #Using bwa and samtools align the contigs to the reconstructed genome
    ./align_to_reconstructed_genome.sh $genome $output_folder $genome_file

    #Predict genes on the reconstructed genome
    ./gene_prediction.sh $genome $output_folder

    #Filter genes that overlaps at least one contig, describe how many bases
    #are in the contigs and how many outside
    python3 gene_filtering.py $genome $output_folder

    python3 extract_gene_sequences.py $genome $output_folder
  fi
else
  echo "ERROR: genome file non found, provide an absolute path to it"
fi
