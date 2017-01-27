FROM ubuntu:14.04

MAINTAINER mauro-dellachiesa
# Set this to inform dpkg the corrrect frontend to use when installing
ENV DEBIAN_FRONTEND noninteractive

#RUN sed -ie 's/archive.ubuntu.com/ubnt-archive.xfree.com.ar/g' /etc/apt/sources.list
RUN sed -i '1s/^/deb mirror:\/\/mirrors.ubuntu.com\/mirrors.txt trusty main restricted universe multiverse \n deb mirror:\/\/mirrors.ubuntu.com\/mirrors.txt trusty-updates main restricted universe multiverse \n deb mirror:\/\/mirrors.ubuntu.com\/mirrors.txt trusty-security main restricted universe multiverse \n /' /etc/apt/sources.list
#RUN echo "precedence ::ffff:0:0/96 100" > /etc/gai.conf
#RUN echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4

RUN apt-get update && apt-get install -y \
        gcc-arm-linux-gnueabi \
        unzip \
        wget \
        make \
        build-essential \
        libmpc-dev \
        flex \
        texlive \
        gettext \
        gawk \
        build-essential \
        automake \
        autoconf \
        libtool \
        pkg-config \
        intltool \
        libcurl4-openssl-dev \
        libglib2.0-dev \
        libevent-dev \
        libminiupnpc-dev \
        libappindicator-dev

RUN mkdir -p /usr/tool-chain/src

# Add the particular texinfo that works
ADD http://launchpadlibrarian.net/125194117/texinfo_4.13a.dfsg.1-10ubuntu4_amd64.deb /usr/tool-chain/

# Install it
RUN sudo dpkg -i /usr/tool-chain/texinfo_4.13a.dfsg.1-10ubuntu4_amd64.deb
# Add the source code zip (http://www.seagate.com/files/www-content/support-content/external-products/seagate-central/_shared/downloads/seagate-central-firmware-gpl-source-code.zip)
#ADD ./resources/seagate-central-firmware-gpl-source-code.zip /usr/tool-chain/

# Add src folder
#ADD ./resources /usr/tool-chain
ADD http://www.seagate.com/files/www-content/support-content/external-products/seagate-central/_shared/downloads/seagate-central-firmware-gpl-source-code.zip /usr/tool-chain/src

# Alternatively, download the source
#ADD http://www.seagate.com/files/www-content/support-content/external-products/seagate-central/_shared/downloads/seagate-central-firmware-gpl-source-code.zip /usr/tool-chain

# Add the maketoolchain script (https://sites.google.com/site/modcentralnas/script-make-tool-chain/maketoolchain?attredirects=0&d=1)
ADD ./resources/maketoolchain /usr/tool-chain

WORKDIR /usr/tool-chain/src

RUN unzip -p seagate-central-firmware-gpl-source-code.zip sources/GPL/gcc/gcc.tar.bz2 > gcc.tar.bz2
RUN bzip2 -d gcc.tar.bz2
RUN tar -xvf gcc.tar

RUN unzip -p seagate-central-firmware-gpl-source-code.zip sources/GPL/linux/git_.home.cirrus.cirrus_repos.linux_6065f48ac9974b200566c51d58bced9c639a2aad.tar.gz > git_.home.cirrus.cirrus_repos.linux_6065f48ac9974b200566c51d58bced9c639a2aad.tar.gz
RUN tar -zxvf git_.home.cirrus.cirrus_repos.linux_6065f48ac9974b200566c51d58bced9c639a2aad.tar.gz
#RUN tar -xvf git_.home.cirrus.cirrus_repos.linux_6065f48ac9974b200566c51d58bced9c639a2aad.tar

RUN unzip -p seagate-central-firmware-gpl-source-code.zip sources/LGPL/glibc/glibc.tar.bz2 > glibc.tar.bz2
RUN bzip2 -d glibc.tar.bz2
RUN tar -xvf glibc.tar

RUN unzip -p seagate-central-firmware-gpl-source-code.zip sources/LGPL/glibc/glibc_ports.tar.bz2 > glibc_ports.tar.bz2
RUN bzip2 -d glibc_ports.tar.bz2
RUN tar -xvf glibc_ports.tar

#RUN mkdir ./linux
RUN mv git linux

RUN ln -s ../glibc-ports-2.11-2010q1-mvl6/ /usr/tool-chain/src/glibc-2.11-2010q1-mvl6/ports

RUN rm /usr/tool-chain/src/seagate-central-firmware-gpl-source-code.zip

RUN rm /usr/tool-chain/src/gcc.tar

RUN rm /usr/tool-chain/src/glibc.tar

RUN rm /usr/tool-chain/src/glibc_ports.tar


WORKDIR /usr/tool-chain

# /usr/tool-chain/cross/config_binutils.log RUN ./maketoolchain
RUN chmod +x ./maketoolchain
RUN ./maketoolchain
ENTRYPOINT /bin/bash
#ENTRYPOINT ["/bin/bash", "./maketoolchain"]
