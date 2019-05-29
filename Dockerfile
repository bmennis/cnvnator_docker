FROM ubuntu:18.04

MAINTAINER Brian Ennis
#code derived from chrishah/cnvnator-docker

RUN apt-get update && apt-get -y upgrade && apt-get install -y build-essential git wget \
	zlib1g-dev libncurses5-dev libbz2-dev liblzma-dev libcurl3-dev \
	libx11-xcb-dev libxft-dev && \
	apt-get clean && apt-get purge && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /usr/src

#ROOT
RUN wget https://root.cern/download/root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz && \
        tar xfz root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz && \
	rm root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz
ENV ROOTSYS /usr/src/root
ENV LD_LIBRARY_PATH /usr/src/root/lib

#RUN wget https://root.cern/download/root_v6.16.00.source.tar.gz && \
#	tar xfz root_v6.16.00.source.tar.gz && \
#	mkdir ROOT-builddir && \
#	cd ROOT-builddir && \
#	apt-get install -y cmake libx11-xcb-dev libxpm-dev libxft-dev libxext-dev python python-dev && \
#	cmake /usr/src/root-6.16.00/ && \
#	cmake --build .
#RUN /bin/bash -c "source /usr/src/ROOT-builddir/bin/thisroot.sh"
#ENV ROOTSYS /usr/src/ROOT-builddir
#ENV LD_LIBRARY_PATH /usr/src/ROOT-builddir/lib

#Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
	tar jxf samtools-1.9.tar.bz2 && \
	rm samtools-1.9.tar.bz2 && \
	cd samtools-1.9 && \
	./configure --prefix $(pwd) && \
	make && \
	ln -s /usr/src/samtools-1.9/samtools /usr/bin/samtools

#cnvnator
RUN git clone https://github.com/abyzovlab/CNVnator.git && \
	cd CNVnator && \
	ln -s /usr/src/samtools-1.9 samtools && \
	make
ENV PATH="${PATH}:/usr/src/CNVnator/"
