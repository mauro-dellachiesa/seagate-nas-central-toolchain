FROM ubuntu:14.04

RUN apt-get update && apt-get install -y \
        gcc-arm-linux-gnueabi \
        texinfo=4.13a.dfsg.1-10ubuntu4\        

RUN mkdir /usr/tool-chain

ADD http://www.seagate.com/files/www-content/support-content/external-products/seagate-central/_shared/downloads/seagate-central-firmware-gpl-source-code.zip /usr/tool-chain
ADD https://sites.google.com/site/modcentralnas/script-make-tool-chain/maketoolchain?attredirects=0&d=1 /usr/tool-chain

ENTRYPOINT ["sh", "/usr/tool-chain/maketoolchain"]