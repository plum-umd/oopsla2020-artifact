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

It is worth noting that running the vrdt proofs will cost more than 16GiB of memory. We have not measured the exact memory consumption, but we know that 16GiB of physical memory + 24GiB of swap space is sufficient, while 16GiB + 4GiB is not. Therefore, if you are unable to get enough memory space, you can use the `--fast` flag when running vrdt. The driver will then skip the proofs for `CausalTree` and `TwoPMap`.


### Typecheck each file separately

The `DockerFile` adds the LiquidHaskell executable `liquid` to `PATH`. This allows you to verify the files individually, including the new files that you might want to add.

For example, to check the functor, applicative and monad instances of `Maybe`, you can do the following:
```
/liquid-benchmark> liquid --typeclass -i liquid-base/liquid-base/src/ liquid-base/liquid-base/src/Data/Maybe/Functor.hs 
```
The `-i` option is not necessary if the working directory is already `/liquid-benchmark/liquid-base/liquid-base-src/`:
```
/liquid-benchmark/liquid-base/liquid-base-src/> liquid --typeclass Data/Maybe/Functor.hs 
```

Before verifying a file, LH will automatically verify the file's dependencies if they have not been verified already. This is why the benchmark driver typechecks the common dependencies before checking the proofs so the time it takes to verify a dependency will not be counted toward the time of the first proof that depends on it.

`liquid` does not know which GHC extensions to enable just by reading the source. You need to tell `liquid` which GHC extensions are enabled at the command line. For your convenience, here is a list of flags you should pass to LH to verify the majority of the files from the repo:
```
liquid --typeclass --ghc-option=-XBangPatterns --ghc-option=-XTypeFamilies --ghc-option=-XFlexibleContexts --ghc-option=-cpp -i DIR DIR/A/B/C/some-file.hs
```

## Where to find the proofs
### liquid-base
#### Classes
[/liquid-benchmark/liquid-base/liquid-base/src/Data/Functor/Classes.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/Functor/Classes.hs) contains the `Functor`, `Applicative` and `Monad` class definitions and their verified versions.

[/liquid-benchmark/liquid-base/liquid-base/src/Data/Semigroup/Classes.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/Semigroup/Classes.hs) contains `Semigroup` and `Monoid`.

Note that lambdas are uninterpreted in refinements. In order to avoid the usage of lambda, we need to define certain functions as top-level or add additional parameters to the laws (such as `lawMonad3`).

##### Instances
The instance for a data type lives in the subdirectory where the data type is defined. For example, the `Semigroup` and `Monoid` instances of `PNat` are defined in [/liquid-benchmark/liquid-base/liquid-base/src/Data/PNat/Semigroup.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/PNat/Semigroup.hs).


### vrdt
#### The VRDT typeclass
The VRDT typeclass defines the properties that an instance needs to satisfy in order to prove its strong convergence. You can find this file at [/liquid-benchmark/vrdt/vrdt/src/VRDT/Class.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/Class.hs).

#### The VRDT instances
##### LWW
[/liquid-benchmark/vrdt/vrdt/src/VRDT/LWW.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/LWW.hs)
##### TwoPMap
[/liquid-benchmark/vrdt/vrdt/src/VRDT/TwoPMap.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/TwoPMap.hs)

The actual definitions and proofs live in the [TwoPMap](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/TwoPMap) directory. 

##### Event
[/liquid-benchmark/vrdt/vrdt/src/Event/Types.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/Event/Types.hs)

This is a showcase of how we automatically derive compound VRDTs from existing ones, as mentioned at the end of Section 4.2. The template haskell code is located in [/liquid-benchmark/vrdt/vrdt/src/VRDT/Class/TH.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/Class/TH.hs).

##### CausalTree
[/liquid-benchmark/vrdt/vrdt/src/VRDT/CausalTree.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/CausalTree.hs)

##### MultiSet
[/liquid-benchmark/vrdt/vrdt/src/VRDT/TwoPMap.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/TwoPMap.hs)

#### Strong Convergence Proof
[/liquid-benchmark/vrdt/vrdt/src/VRDT/Class/Proof.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/Class/Proof.hs)

This file contains the strong convergence proof mentioned in Section 4.3. It is done purely in terms of the typeclass specification so it can be instantiated to any of the `VRDT` instances.

We reuse the strong convergence theorem in the proof of `TwoPMap`, a `VRDT` that is parameterized over another `VRDT`.

## Known issues
### Modularity
You might have noticed that we never import instances in `liquid-base`. For example, in the instance definitions of `Foldable`, we duplicate the definition of `Endo`, which is required as part of the law. This is because instance import was not supported when we started working on `liquid-base`. Also, it is not as important for `liquid-base` because we duplicate only definitions. The verification time will still be accurate as long as we don't duplicate proofs.

When developing `vrdt`, however, we ran into a use case where the duplication would have happen on proofs as well (for `Event` and `TwoPMap`). We have already fixed the issue, but we only take advantage of modularity in `vrdt` where the performance matters.

### SMT crash and adt


### Newtype
In the paper, we present `Dual` as a `newtype`. In the benchmark programs, we instead define them as `data` with a single field. Internally, `newtype`s are converted into coercions (TODO: cite the System FC paper?). LiquidHaskell does not handle coercions very well and therefore the proofs involving `newtype`s would simply fail. Semantically, however, they should be treated as the same by LH since LH no longer reasons about the strictness of terms.

### Explicit inlining
In Section 3.2, we describe a way to break the "fake" mutual recursion by replacing all the selector + dictionary expressions with the name of the instance methods themselves. This feature is indeed implemented and is used in [PNat.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/PNat/Semigroup.hs). However, we only perform inlining when the flag `--aux-inline` is turned on. The reason is that the program analysis function called after inlining changes the source in such a way that the termination checker of LiquidHaskell no longer works with user-specified termination metrics. We make extensive use of termination metrics in the vrdt proofs, so we decide to switch off the explicit inlining by default and only turn it on when it's really needed.

To be more precise, you only need `--aux-inline` if you refer to any of the instance methods within the body of the instance definition where the methods are defined:
``` haskell
instance Foo T where
  foo = ....
  bar = ... foo ...
  buz = ... buz ...
```

