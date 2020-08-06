FROM ubuntu:18.04

RUN apt update
RUN apt install -y git curl wget vim libicu-dev libtinfo-dev unzip screen
RUN curl -sSL https://get.haskellstack.org/ | sh

# Install Z3.
WORKDIR /
RUN wget https://github.com/Z3Prover/z3/releases/download/z3-4.8.8/z3-4.8.8-x64-ubuntu-16.04.zip
RUN unzip z3-4.8.8-x64-ubuntu-16.04.zip


ADD liquid-benchmark /liquid-benchmark

# Install Liquid.
WORKDIR /liquid-benchmark/liquidhaskell
RUN stack install

# Build VRDT example applications.
WORKDIR /liquid-benchmark/vrdt
RUN stack build

WORKDIR /liquid-benchmark
RUN stack build

# Set Path.
RUN echo 'export PATH="/z3-4.8.8-x64-ubuntu-16.04/bin:/root/.local/bin:$PATH"' >> /root/.bashrc
