####################################################
#RNA-seq Tools
#Dockerfile to build a container with bowtie2-2.3.2
#Ubuntu 14.04
####################################################
#Build the image based on Ubuntu
FROM ubuntu:latest

#Maintainer and author
MAINTAINER Magdalena Arnal <marnal@imim.es>

#Install required libraries in ubuntu
RUN apt-get update && apt-get install --yes build-essential gcc-multilib apt-utils zlib1g-dev git
        
# Install BOWTIE2
WORKDIR /tmp
RUN git clone https://github.com/BenLangmead/bowtie2.git
WORKDIR /tmp/bowtie2
RUN git checkout v2.2.4

# Patch Makefile
RUN sed -i 's/ifneq (,$(findstring 13,$(shell uname -r)))/ifneq (,$(findstring Darwin 13,$(shell uname -sr)))/' Makefile
RUN sed -i 's/RELEASE_FLAGS = -O3 -m64 $(SSE_FLAG) -funroll-loops -g3/RELEASE_FLAGS = -O3 -m64 $(SSE_FLAG) -funroll-loops -g3 -static/' Makefile

# Compile
RUN make
RUN cp -p bowtie2 bowtie2-* /usr/local/bin

# Cleanup
RUN rm -rf /tmp/bowtie2
RUN apt-get clean
RUN apt-get remove --yes --purge build-essential gcc-multilib apt-utils zlib1g-dev vim git

WORKDIR /
