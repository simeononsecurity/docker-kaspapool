FROM ubuntu:latest

LABEL org.opencontainers.image.source="https://github.com/simeononsecurity/docker-kaspapool"
LABEL org.opencontainers.image.description="Dockerized Kaspa Pool"
LABEL org.opencontainers.image.authors="simeononsecurity"

ENV DEBIAN_FRONTEND noninteractive
ENV container docker
ENV TERM=xterm

EXPOSE 16111
EXPOSE 16110

COPY run.sh ./

# Update Packages
RUN apt-get update && \
  apt-get -y --no-install-recommends install apt-utils && \ 
  apt-get -fuy full-upgrade && \ 
  apt-get -fuy install git automake cmake make gcc curl tar coreutils screen

# Install Kaspa Node
RUN curl -OL https://go.dev/dl/go1.21.1.darwin-amd64.tar.gz && sha256sum go1.21.1.darwin-amd64.tar.gz
RUN tar -C /usr/local -xvf go1.21.1.darwin-amd64.tar.gz
RUN printf 'export PATH=$PATH:/usr/local/go/bin:/root/go/bin' >> ~/.profile
RUN /usr/local/go/bin/go version
RUN git clone https://github.com/kaspanet/kaspad && cd kaspad && /usr/local/go/bin/go install . ./cmd/...
#RUN cd ~/go/bin/ && ./kaspad --utxoindex && ./kaspactl GetBlockDagInfo

# KASPA Stratum
# RUN curl https://sh.rustup.rs -sSf -o rustinstall.sh && chmod +x rustinstall.sh && /bin/bash rustinstall.sh -q -y
# RUN ~/.cargo/bin/rustc --version
# RUN git clone https://github.com/fungibilly/kaspad-stratum.git && cd kaspad-stratum && cargo build --release && cd ~/kaspad-stratum/target/release 

# Clean APT
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/bin/bash", "run.sh" ]
