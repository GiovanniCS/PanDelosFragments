#!/bin/bash
cd `dirname $0`
output_dir=$1

moraxella_complete=`cat moraxella_complete.txt`
moraxella_fragmented=`cat moraxella_fragmented.txt`
rm "$output_dir/ALL_fragmented_genomes_genes.fna"
rm "$output_dir/ALL_complete_genomes_genes.fna"

rm -rf "$output_dir/moraxella_complete"
mkdir -p "$output_dir/moraxella_complete"
for comp_genome in $moraxella_complete
do
  wget -P "$output_dir/moraxella_complete" $comp_genome
done
cd $output_dir/moraxella_complete
downloaded_genomes=`ls`
for comp_genome in $downloaded_genomes
do
  gunzip "$output_dir/moraxella_complete/${comp_genome}"
done
downloaded_genomes=`ls *.fna`
cd -
for comp_genome in $downloaded_genomes
do
  echo "genoma completo $comp_genome"
  ./complete_genome_genes_extraction.sh "$output_dir/moraxella_complete/$comp_genome" "$output_dir/moraxella_complete/here_${comp_genome}"
  cat "$output_dir/moraxella_complete/here_${comp_genome}/gene_sequences.fna" >> $output_dir/ALL_complete_genomes_genes.fna
done
rm $output_dir/moraxella_complete/*.fai

rm -rf "$output_dir/moraxella_fragmented"
mkdir -p "$output_dir/moraxella_fragmented"
for frag_genome in $moraxella_fragmented
do
  wget -P "$output_dir/moraxella_fragmented" $frag_genome
done
cd $output_dir/moraxella_fragmented
downloaded_genomes=`ls`
for frag_genome in $downloaded_genomes
do
  gunzip $frag_genome
done
downloaded_genomes=`ls *.fna`
cd -
for frag_genome in $downloaded_genomes
do
  ./../main.sh "$output_dir/moraxella_fragmented/${frag_genome}" "$output_dir/moraxella_fragmented/here_${frag_genome}"
  cat "$output_dir/moraxella_fragmented/here_${frag_genome}/results/gene_sequences.fna" >> $output_dir/ALL_fragmented_genomes_genes.fna
done

for frag_genome in $downloaded_genomes
do
  ./fragmented_genome_genes_extraction.sh "$output_dir/moraxella_fragmented/${frag_genome}" "$output_dir/moraxella_fragmented/only_prodigal/here_${frag_genome}"
  cat "$output_dir/moraxella_fragmented/only_prodigal/here_${frag_genome}/filtered_prodigal_sequences.fna" >> $output_dir/ALL_fragmented_genomes_genes_only_prodigal.fna
done
cat $output_dir/ALL_complete_genomes_genes.fna > $output_dir/ALL_genes.fna
cat $output_dir/ALL_fragmented_genomes_genes.fna >> $output_dir/ALL_genes.fna

cat $output_dir/ALL_complete_genomes_genes.fna > $output_dir/ALL_genes_only_prodigal.fna
cat $output_dir/ALL_fragmented_genomes_genes_only_prodigal.fna >> $output_dir/ALL_genes_only_prodigal.fna

cd ..
proj_dir=`pwd`
cd $output_dir
bash $proj_dir/PanDelosFork/pandelos.sh ALL_complete_genomes_genes.fna only_complete_genomes_pangenome
bash $proj_dir/PanDelosFork/pandelos.sh ALL_genes.fna complete_and_fragmented_genomes_pangenome_second_measure
bash $proj_dir/PanDelosFork/pandelos.sh ALL_genes_only_prodigal.fna complete_and_fragmented_genomes_pangenome_only_prodigal_second_measure
