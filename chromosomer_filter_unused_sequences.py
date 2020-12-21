#!/usr/bin/python3
import os
import sys
from Bio import SeqIO

fragmented_genome = sys.argv[1]
output_folder = sys.argv[2]

unused_sequences = os.popen("cat " + output_folder + "/artifacts/chromosomer_map_unlocalized.txt | awk '{print $1}' ").read().split("\n")
reference_genome_sequences = list(SeqIO.parse(fragmented_genome, "fasta"))
filtered_reference_genome_sequences = []
for sequence in reference_genome_sequences:
    if not sequence.id in unused_sequences:
        filtered_reference_genome_sequences.append(sequence)
SeqIO.write(filtered_reference_genome_sequences, output_folder + "/artifacts/filtered_reference_genome_sequences.fna", "fasta")