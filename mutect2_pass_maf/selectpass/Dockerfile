################################################################# 
# Dockerfile # # Software: vcf2maf # Software Version: 1.6.13 
# Description: Convert a VCF into a MAF, where each variant is annotated  
# to only one of all possible gene isoforms # Website: https://github.com/OpenGenomics/vcft2maf-tools 
# Base Image: opengenomics/variant-effect-predictor-tool # Run Cmd: docker run opengenomics/vcf2maf perl vcf2maf.pl --man ################################################################# 

FROM ubuntu:16.04
MAINTAINER chunlei <chunlei.yu1990@gmail.com>


RUN apt-get -qq update && apt-get install -qqy \
    build-essential \
    lbzip2 \
#    openjdk-8-jdk \
    r-base-core \
    unzip \
    vim-common \
    wget \
    zlib1g-dev \
    libcurl4-openssl-dev \
    sudo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/


COPY ./hard_filerd.sh /opt/
