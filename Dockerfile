FROM rocker/tidyverse:latest

MAINTAINER Chunlei <chunleiyu@1990.gmail>

# System dependencies for required R packages
RUN  rm -f /var/lib/dpkg/available \
  && rm -rf  /var/cache/apt/* \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    git

RUN Rscript -e "install.packages(c('devtools','knitr','rmarkdown','shiny','RCurl'), repos = 'https://cran.rstudio.com')"

RUN Rscript -e "source('https://cdn.rawgit.com/road2stat/liftrlib/aa132a2d/install_cran.R');install_cran(c('rmdformats'))"

RUN Rscript -e "source('http://bioconductor.org/biocLite.R');biocLite(c('VariantAnnotation','AnnotationHub','org.Hs.eg.db','org.Mm.eg.db','BSgenome.Hsapiens.UCSC.hg19','TxDb.Hsapiens.UCSC.hg19.knownGene','TxDb.Mmusculus.UCSC.mm10.ensGene','optparse'))"

WORKDIR /usr/bin/
ADD ./vcf2maflite.r /usr/bin/

#ENTRYPOINT ["vcf2maflite.r"]
CMD ["Rscript", "/usr/bin/vcf2maflite.r"]

# CMD : docker run -v /Users/chunleiyu/Work/data/vcf/CGU_01/:/data/ -t ycl/vcf2maflite:v2 Rscript /usr/bin/vcf2maflite.r -i /data/01_pass_twicefilterd.vcf -o /data/GU_OSCC_01.1.maf
