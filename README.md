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

### Run all the benchmarks at once

The working directory `liquid-benchmark` includes all the programs we verify in our paper. `liquid-base` contains the verified instances of `Monad`, `Applicative`, `Monoid`, etc. `vrdt` contains the verified CRDTs. The following command uses LiquidHaskell to typecheck `vrdt` 5 times using 12 cores and outputs the sample variance and mean for the execution time:
```
stack exec liquid-benchmark -- --vrdt --times 5 --cores 12
```
Similarly, we can typecheck `liquid-base` using the following command:
```
stack exec liquid-benchmark -- --liquid-base
```
By default, the benchmark driver typechecks the programs 3 times using 4 cores.

It is worth noting that the running the test will cost more than 16GiB of memory. Make sure you have a sufficient amount of swap space allocated to prevent your memory space from being depleted.


### Typecheck each file separately

The `DockerFile` adds the LiquidHaskell executable `liquid` to `PATH`. This allows you to verify the files individually, including the new files that you might want to add.

For example, to check the monad instance of `Maybe`, you can do the following:
```
/liquid-benchmark> liquid --typeclass -i liquid-base/liquid-base/src/ liquid-base/liquid-base/src/Data/Maybe/Functor.hs 
```
The `-i` option is not necessary if the working directory is already `/liquid-benchmark/liquid-base/liquid-base-src/`:
```
/liquid-benchmark/liquid-base/liquid-base-src/> liquid --typeclass Data/Maybe/Functor.hs 
```

The paper includes a table of the amount of time each file takes. For your convenience, we include the table in this documentaiton as well: TODO


Before verifying a file, LH will automatically verify the file's dependencies if they have not been verified already. TODO: show how to verify a file without checking its imports? (tricky since the bspecs for the imported files need to be generated. need to verify then cancel to generate the file).

