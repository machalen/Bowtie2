####################################################
#RNA-seq Tools
#Dockerfile to build a container with bowtie2-2.3.2
#Ubuntu 14.04
####################################################
#Build the image based on Ubuntu
FROM ubuntu:14.04

#Maintainer and author
MAINTAINER Magdalena Arnal <marnal@imim.es>

#Install required libraries in ubuntu
RUN apt-get update && apt-get -y install libtbb-dev
        
#Install/update wget, unzip, python in ubuntu
RUN apt-get update && apt-get install --yes wget unzip python

#Download Bowtie2
WORKDIR /bin
RUN wget --default-page=bowtie2-2.3.4.3-linux-x86_64.zip http://sourceforge.net/projects/bowtie-bio/files/bowtie2/2.3.4.3/bowtie2-2.3.4.3-linux-x86_64.zip/

#Unzip Bowtie2
RUN unzip bowtie2-2.3.4.3-linux-x86_64.zip

#Remove compressed files
RUN rm bowtie2-2.3.4.3-linux-x86_64.zip

#Add bowtie2 to the path variable
ENV PATH $PATH:/bin/bowtie2-2.3.4.3-linux-x86_64

#Remove no installed packages wget and unzip
RUN apt-get purge --yes wget unzip

#Set User and default Working Directory
WORKDIR /
