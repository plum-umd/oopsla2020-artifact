# Verifying Replicated Data Types with Typeclass Refinements in Liquid Haskell

Yiyun Liu, James Parker, Patrick Redmond, Lindsey Kuper, Michael Hicks, Niki Vazou

## Overview

This is the artifact for [Verifying Replicated Data Types with Typeclass Refinements in Liquid Haskell](#TODO). 
We provide a `Dockerfile` that can be used to run and benchmark the proofs, as well as the example VRDT applications. 

## Build
First, clone the repo:
```
git clone --recursive git@github.com:plum-umd/oopsla2020-artifact.git
```
Then build the docker image with:
```
docker build -t liquid-typeclasses .
```
This will take a while to finish.


## Run
Enter the shell with:
```
docker run -it liquid-typeclasses /bin/bash
```

### Run all benchmarks at once
The working directory `liquid-benchmark` includes all the programs we verify in our paper. `liquid-base` contains the verified instances of `Monad`, `Applicative`, `Monoid`, etc. `vrdt` contains the verified CRDTs. The following command uses `LiquidHaskell` to typecheck all those programs 3 times and outputs the sample variance and mean for the 3 executions:
```
stack exec liquid-benchmark -- 3
```
It is worth noting that the running the test will use around more than 16GiB of memory. Make sure you have a sufficient amount of swap space allocated to prevent your memory space from being depleted.


### Typecheck each file separately
