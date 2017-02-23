FROM seagate-nas-central-toolchain:latest

MAINTAINER mauro-dellachiesa

WORKDIR /usr/tool-chain/src

ENV TOBUILD transmission-1.92
#ADD https://github.com/transmission/transmission-releases/raw/master/${TOBUILD}.tar.bz2 ./${TOBUILD}.tar.bz2
ADD https://github.com/transmission/transmission-releases/raw/master/transmission-1.92.tar.bz2 ./transmission-1.92.tar.bz2

ADD resources/buildTransmission ./buildTransmission

RUN chmod +x ./buildTransmission

# In case it has Windows line endings
RUN sed -i -e 's/\r$//' ./buildTransmission

ENTRYPOINT /bin/bash