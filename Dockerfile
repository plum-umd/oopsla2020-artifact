FROM ubuntu:18.04

RUN apt update
RUN apt install -y git z3 curl vim libicu-dev libtinfo-dev
RUN curl -sSL https://get.haskellstack.org/ | sh

# TODO
# RUN git clone --branch oopsla2020 --recursive https://github.com/yiyunliu/liquid-benchmark.git
RUN git clone --recursive https://github.com/yiyunliu/liquid-benchmark.git

# Install Liquid.
WORKDIR liquid-benchmark/liquidhaskell
RUN stack install
RUN echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc

# Build VRDT example applications.
WORKDIR liquid-benchmark/vrdt
RUN stack build
