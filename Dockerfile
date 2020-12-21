FROM debian:stable
RUN apt update && apt install git nano wget python3 python --yes
RUN apt install python3-pip python-pip --yes
RUN apt install gcc make libbz2-dev zlib1g-dev libncurses5-dev libncursesw5-dev --yes
RUN apt install libcurl4 libcurl4-openssl-dev liblzma-dev --yes
RUN apt install samtools bwa bedtools --yes
RUN pip install numpy chromosomer
RUN pip3 install numpy Cython
RUN pip3 install pysam matplotlib biopython networkx
RUN cd /home && git clone https://github.com/GiovanniCS/PanDelosFragments.git
RUN chmod +x /home/PanDelosFragments/download_blast_db.sh && ./home/PanDelosFragments/download_blast_db.sh
