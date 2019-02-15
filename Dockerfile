FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list \
    && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key E084DAB9 \
    && gpg -a --export E084DAB9 | apt-key add - \
    && add-apt-repository ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -y git wget unzip vim sudo apt-utils net-tools python r-base r-base-dev openjdk-7-jdk maven g++ zlib1g-dev make build-essential gcc python-setuptools python-dev cmake tabix libz-dev vcftools curl libcurl4-openssl-dev libssl-dev gcc-multilib libncurses-dev \
    && easy_install pip \
    && pip install --user numpy scipy matplotlib ipython jupyter pandas sympy nose \
    && pip install pysam \	
    && pip install -U scikit-learn

#BWA
##Get source from github
RUN apt-get install --yes git
WORKDIR /tmp
RUN git clone https://github.com/lh3/bwa.git
WORKDIR /tmp/bwa
RUN git checkout v0.7.15
##Compile
RUN make
RUN cp -p bwa /usr/local/bwa
##Clean
RUN rm -rf /tmp/bwa

WORKDIR /
#BFC
RUN git clone https://github.com/lh3/bfc.git \
    && cd bfc && make && cd /

#SomaticSniper
RUN git clone https://github.com/genome/somatic-sniper.git 
RUN mkdir somatic-sniper/build
RUN cd somatic-sniper/build \
    && cmake ../ && make deps && make -j && make install


WORKDIR /
#Strelka
RUN git clone https://github.com/genome-vendor/strelka strelka_build \
    && cd /strelka_build \
    && mkdir -p /strelka \
    && ./configure --prefix=/strelka \
    && make

#Varscan
RUN mkdir -p /varscan \
    && cd /varscan \
    && wget https://github.com/dkoboldt/varscan/releases/download/2.4.2/VarScan.v2.4.2.jar

#Picard
RUN cd / && \
    wget https://github.com/broadinstitute/picard/releases/download/1.140/picard-tools-1.140.zip -O picard-tools-1.140.zip && \
    unzip picard-tools-1.140.zip

#Samtools
RUN cd / && \
    wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
    bunzip2 samtools-1.3.1.tar.bz2 && \
    tar -xvf samtools-1.3.1.tar && \
    cd samtools-1.3.1 && \
    make

#Fastqc
RUN cd / && \
    wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip && \
    unzip fastqc_v0.11.5.zip && \
    cd FastQC/ && \
    chmod 755 fastqc


#BAMTools
RUN cd / && \
    git clone https://github.com/pezmaster31/bamtools.git && \
    cd bamtools && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make 

#Bedtools
RUN git clone https://github.com/arq5x/bedtools2.git && \
	cd bedtools2 && \
	make && \
	mkdir /bedtools && \
	cp bin/* /bedtools/

WORKDIR /
#Lofreq
RUN curl -L 'http://downloads.sourceforge.net/project/lofreq/lofreq_star-2.1.2_linux-x86-64.tgz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flofreq%2Ffiles%2F&ts=1471618612&use_mirror=heanet' > lofreq_star-2.1.2_linux-x86-64.tgz

RUN tar -xvzf lofreq_star-2.1.2_linux-x86-64.tgz

RUN cp lofreq_star-2.1.2/bin/* /usr/local/bin/

#Environment variables
ENV PATH="/bedtools:/picard-tools-1.140:/mutect/target/:/strelka/libexec:/varscan:/bamtools/bin:/FastQC:/gatk-protected/target:/somatic-sniper/build/bin:${PATH}"

###TO DOs#####

### COPY <pairedendalignment.sh> to this container or ADD if serving the script at Github
### Add CMD or an ENTRYPOINT (or both) to directly run the script on user data.  
### ENTRYPOINT ["/bin/sh", "pairedendalignment.sh"]
### CMD [threads", "fastq1.fq", "fastq2.fq", "genome.fasta"] -- should be overriden
### Allow simple usage of 'docker run -v /path/to/file -t <container> <data...>' so user can run on data in specific directory'
### Or easy method to mount a directory inside the container. 
### 'mkdir ~/output-dir'
### 'docker run -d -P --name <image> -v /path/to/output-dir:/home/user <container>'