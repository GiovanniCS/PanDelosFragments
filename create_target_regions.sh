#!/bin/bash

min_region_width=5000
max_region_width=15000

genome=$1
percentage=$2
output_folder=$3

declare -A unsequenced_region_intervals
unsequenced_region_intervals["10"]="60000-65000"
unsequenced_region_intervals["20"]="32000-35000"
unsequenced_region_intervals["30"]="20000-23000"
unsequenced_region_intervals["40"]="14000-16000"
unsequenced_region_intervals["50"]="9000-10000"
unsequenced_region_intervals["60"]="6000-7000"
unsequenced_region_intervals["70"]="4000-5000"
unsequenced_region_intervals["80"]="1500-2500"
unsequenced_region_intervals["90"]="1000-1200"
unsequenced_region_intervals["100"]="1-1"

#Create target sequences file

chars=`tail -n +2 ${genome} | wc | awk '{print $3-$1}'`
chrom=`grep ">" ${genome} | cut -c 2-`
iterator=1
regions_sum_bases=0
#Loop over the genome length
while [ $iterator -lt $chars ]
do
    #skip defines the next "genomic island" length that must not be sequenced
    interval=`echo ${unsequenced_region_intervals[${percentage}]}`
    skip=`shuf -i ${interval} -n 1`
    #end is the position in the genome where the i-th sequenced genomic region ends
    #The width of the i-th region is in [5000 through 15000]
    add_interval=`echo ${min_region_width}-${max_region_width}`
    add=`shuf -i ${add_interval} -n 1`
    end=$(($iterator+$add))
    #If i'm not beyond the genome length..
    if [ $chars -ge $end ]
        then
            regions_sum_bases=$(($regions_sum_bases+$add))
            #append to .bed file a new target region
            echo -e "${chrom}\t${iterator}\t${end}" >> ${output_folder}/targets.bed
    fi
    #Go to the new region that must be sequenced
    iterator=$(($end+$skip))
done