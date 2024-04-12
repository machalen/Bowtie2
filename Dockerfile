####################################################
#RNA-seq Tools
#Dockerfile to build a container with bowtie2-2.3.2
#Ubuntu Focal
####################################################
#Build the image based on Ubuntu
FROM ubuntu:focal

#Maintainer and author is:
MAINTAINER Magdalena Arnal <marnal@peptomyc.com>

#Install required libraries in ubuntu
RUN apt-get update && apt-get install --yes build-essential gcc-multilib apt-utils zlib1g-dev \
libbz2-dev git perl gzip ncurses-dev libncurses5-dev libbz2-dev \
liblzma-dev libssl-dev libcurl4-openssl-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev wget

#Install python3
RUN apt-get update && apt-get install --yes python3
        
# Install BOWTIE2
WORKDIR /tmp
RUN git clone https://github.com/BenLangmead/bowtie2.git
WORKDIR /tmp/bowtie2
RUN git checkout v2.4.4

# Patch Makefile
RUN sed -i 's/ifneq (,$(findstring 13,$(shell uname -r)))/ifneq (,$(findstring Darwin 13,$(shell uname -sr)))/' Makefile
RUN sed -i 's/RELEASE_FLAGS = -O3 -m64 $(SSE_FLAG) -funroll-loops -g3/RELEASE_FLAGS = -O3 -m64 $(SSE_FLAG) -funroll-loops -g3 -static/' Makefile

# Compile
RUN make
RUN cp -p bowtie2 bowtie2-* /usr/local/bin

#Install required libraries in ubuntu for samtools
RUN apt-get update -y && apt-get install -y unzip bzip2 g++
#Set wokingDir in /bin
WORKDIR /bin

#Install and Configure samtools
RUN wget http://github.com/samtools/samtools/releases/download/1.5/samtools-1.5.tar.bz2
RUN tar --bzip2 -xf samtools-1.5.tar.bz2
WORKDIR /bin/samtools-1.5
RUN ./configure
RUN make
RUN rm /bin/samtools-1.5.tar.bz2
ENV PATH $PATH:/bin/samtools-1.5

# Cleanup
RUN rm -rf /tmp/bowtie2
RUN apt-get clean
RUN apt-get remove --yes --purge build-essential gcc-multilib apt-utils zlib1g-dev vim git

WORKDIR /
