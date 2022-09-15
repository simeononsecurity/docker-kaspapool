FROM ubuntu:latest

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/docker-kaspapool"
LABEL org.opencontainers.image.description="Dockerized Kaspa Pool"
LABEL org.opencontainers.image.authors="simeononsecurity"

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV TERM=xterm

# Update Packages
RUN apt-get update && apt-get -y install apt-utils && apt-get -fuy full-upgrade -y && apt-get -fuy install git automake cmake make curl tar

# Install Kaspa Node
RUN curl -OL https://go.dev/dl/go1.19.1.linux-amd64.tar.gz && sha256sum go1.19.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xvf go1.19.1.linux-amd64.tar.gz
RUN echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile && source ~/.profile 
RUN go version
RUN git clone https://github.com/kaspanet/kaspad && cd kaspad && go install . ./cmd/...
RUN screen -S node
RUN cd ~/go/bin && ./kaspactl GetBlockDagInfo && ./kaspad --utxoindex

ENTRYPOINT [ "/bin/bash" ]
