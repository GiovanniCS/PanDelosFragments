#!/bin/bash
curr_dir=`pwd`
output_folder=$2
fragmented_genome_file=$3

cd $output_folder
bwa index artifacts/candidate_genome.fna
bwa mem artifacts/candidate_genome.fna $fragmented_genome_file > artifacts/contigs_alignment.sam
samtools view -b -F 256 artifacts/contigs_alignment.sam | samtools view -b -F 2048  \
  > artifacts/contigs_alignment.bam
samtools view -h -f 4 artifacts/contigs_alignment.sam > artifacts/unmapped.sam
samtools sort artifacts/contigs_alignment.bam > artifacts/sorted_contigs_alignment.bam
samtools index -b artifacts/sorted_contigs_alignment.bam
