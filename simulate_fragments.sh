#!/bin/bash
cd `dirname $0`

chmod +x create_target_regions.sh
chmod +x simulate_sequencing.sh
chmod +x de_novo_assembly.sh

genome=$1
if [[ -f $genome ]]
then
  perc_of_sequencing=$3
  if [[ $perc_of_sequencing == "10" || $perc_of_sequencing == "20" || $perc_of_sequencing == "30"
    || $perc_of_sequencing == "40" || $perc_of_sequencing == "50" || $perc_of_sequencing == "60"
    || $perc_of_sequencing == "70" || $perc_of_sequencing == "80" || $perc_of_sequencing == "90"
    || $perc_of_sequencing == "100" ]]
  then
    output_folder=$2
    if [[ ! -d $output_folder ]]
    then
      mkdir -p $output_folder
    fi
    rm -rf ${output_folder}/symulated_fragments && rm -rf ${output_folder}/spades_output && mkdir ${output_folder}/symulated_fragments
    cp $genome ${output_folder}/symulated_fragments/orignal_genome.fna
    genome_first_line=`head -n1 ${genome}`
  
    #compute the .bed file that define the regions of the genome that should be sequenced
    ./create_target_regions.sh $genome $perc_of_sequencing "$output_folder/symulated_fragments"
  
    #simulate 150bp single end Illumina sequencing with neat-genreads
    ./simulate_sequencing.sh $genome "$output_folder/symulated_fragments"
  
    #de novo assembly of reads with SPAdes
    ./de_novo_assembly.sh $output_folder
  
    echo $genome_first_line >> ${output_folder}/symulated_fragments/simulated_fragmented_genome.fna
    tail --lines=+2 ${output_folder}/symulated_fragments/temp_simulated_fragmented_genome.fna \
      >> ${output_folder}/symulated_fragments/simulated_fragmented_genome.fna
    rm ${output_folder}/symulated_fragments/temp_simulated_fragmented_genome.fna
  else
    echo "ERROR: percentage of sequencing must be in (10,20,30,40,50,60,70,80,90,100)"
  fi
else
  echo "ERROR: genome file non found, provide an absolute path to it"
fi