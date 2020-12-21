# PanDelosFragments
PanDelosFragments is a bioinformatic pipeline.  
It's main goal is to retrieve all the gene sequences from a fragmented prokaryotic or viral genome.  
Given a fasta file with a non-complete genome (fragmented in multiple contigs), it will return a fasta file with all the gene sequences found + a measure of "deduced bases" i.e. bases that are not present in the fragments but reconstruced from the pipeline.

#### Usage (docker based, see below for local installation)
If you have docker installed in your machine, download the Dockerfile that you can find in the root of this project.  
Then cd in the download directory and
```shell script
docker build --tag PanDelosFragments
```
This will take a bit of time as in the building process are installed some packages, cloned this repository inside 
the image and downloaded the ref_prok_rep_genomes and ref_viruses_rep_genomes DBs from ncbi (~10GB of data). Once completed,

```shell script
docker images
```
and you should see the docker image PanDelosFragments built from the Dockerfile.  
Docker run take an image and derive a container from it. With the following command you will gain
access to bash inside the container with the pipeline.
```shell script
docker run --interactive --tty PanDelosFragments /bin/bash
```
Now you can download one fragmented genome with wget from the container (through ncbi ftp server --> ftp://ftp.ncbi.nlm.nih.gov/genomes)
```shell script
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/010/603/965/GCF_010603965.1_ASM1060396v1/GCF_010603965.1_ASM1060396v1_genomic.fna.gz
gunzip GCF_010603965.1_ASM1060396v1_genomic.fna.gz
```
or copy it inside the container with docker cp
```shell script
//run docker container
docker run --interactive --tty full_pipeline /bin/bash
//check container ID
docker ps
//copy genome file in the host filesystem to the container one
docker cp path/to/file container_id:/derised/path
//for example one correct command could be
docker cp GCF_010603965.1_ASM1060396v1_genomic.fna.gz ab9f18ed8606:/home
```
The pipeline can be called in this way
```shell script
/home/PanDelosFragments/main.sh /absolute/path/to/fragmented/genome /absoulte/output/directory/path [virus | prokaryotic]
```
The first parameter is a pull path to the fragmented genome, the second is a full path to an output directory and the third (optional) specify if the genome is viral or prokaryotic (default prokaryotic).
If the directory is not present then the main script will create it.
Once finished, 
```shell script
cd /absoulte/output/directory/path/results
```
and explore the output of the execution or extract the output folder from the container
```shell script
//from an host terminal
docker cp container_id:/absoulte/output/directory/path/ .
```
In results we can see all the genes positions relative to the reconstructed genome. 
Only genes overlapping with at least one contig are present in the final file (gene_sequences.fna).

##### Fragmented genome simultation  
It is possible to take a complete genome, define a % of sequencing, simulate sequencing and assemble the obtained reads.  
This can be useful in benchmarking contexts. The following code show how to do this and connect the output with the main script.
```shell script
/home/PanDelosFragments/simulate_fragments.sh /absolute/path/to/complete/genome.fna /absoulte/output/directory/path1 perc_of_seq
/home/PanDelosFragments/main.sh /absoulte/output/directory/path1/symulated_fragments/simulated_fragmented_genome.fna /absoulte/output/directory/path2
```
Param perc_of_seq is an integer in (10,20,30,40,50,60,70,80.90,100) that describe how much the genome should be sequenced (in length)
#### Local installation
If you want you can skip the docker image and container contruction and install all the dependencies manually.  
In a Linux environment run
```shell script
sudo apt install python3 python openjdk-8-jdk --yes
sudo apt install python3-pip python-pip --yes
sudo apt install libbz2-dev zlib1g-dev libncurses5-dev libncursesw5-dev --yes
sudo apt install libcurl4 libcurl4-openssl-dev liblzma-dev --yes
sudo apt install samtools bwa bedtools --yes
sudo pip install numpy chromosomer
sudo pip3 install Cython numpy pysam matplotlib biopython networkx
// then clone the repository and download the virus and prokaryotic reference databases from ncbi (they are used in local blast queries)
git clone https://github.com/GiovanniCS/PanDelosFragments.git
cd PanDelosFragments && chmod +x ./download_blast_db.sh && ./download_blast_db.sh
//last command will take a bit as ~ 10GB of data will be downloaded
```