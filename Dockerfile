FROM ubuntu:18.04

RUN apt update
RUN apt install -y git z3 curl vim libicu-dev libtinfo-dev
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc


# TODO
# RUN git clone --branch oopsla2020 --recursive https://github.com/yiyunliu/liquid-benchmark.git
# RUN git clone --recursive https://github.com/yiyunliu/liquid-benchmark.git

ADD liquid-benchmark /liquid-benchmark

# Install Liquid.
WORKDIR /liquid-benchmark/liquidhaskell
RUN stack install

# Build VRDT example applications.
WORKDIR /liquid-benchmark/vrdt
RUN stack build

WORKDIR /liquid-benchmark
