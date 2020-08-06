# Verifying Replicated Data Types with Typeclass Refinements in Liquid Haskell

Yiyun Liu, James Parker, Patrick Redmond, Lindsey Kuper, Michael Hicks, Niki Vazou

## Overview

This is the artifact for [Verifying Replicated Data Types with Typeclass Refinements in Liquid Haskell](http://www.cs.umd.edu/~mwh/papers/liu20typeclasses.html). 
We provide a `Dockerfile` that can be used to run and benchmark the proofs, as well as the example VRDT applications. 

## Build
First, clone the repo:
```
git clone --recursive https://github.com/plum-umd/oopsla2020-artifact
```
Then build the docker image with:
```
docker build --no-cache -t liquid-typeclasses .
```
This will take a while to finish.

## Where to find the proofs
### liquid-base
#### Classes
[/liquid-benchmark/liquid-base/liquid-base/src/Data/Functor/Classes.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/Functor/Classes.hs) contains the `Functor`, `Applicative` and `Monad` class definitions and their verified versions.

[/liquid-benchmark/liquid-base/liquid-base/src/Data/Semigroup/Classes.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/Semigroup/Classes.hs) contains `Semigroup` and `Monoid`.

Note that lambdas are uninterpreted in refinements. In order to avoid the usage of lambda, we need to define certain functions as top-level or add additional parameters to the laws (such as `lawMonad3`).

#### Instances
The instance for a data type lives in the subdirectory where the data type is defined. For example, the `Semigroup` and `Monoid` instances of `PNat` are defined in [/liquid-benchmark/liquid-base/liquid-base/src/Data/PNat/Semigroup.hs](https://github.com/plum-umd/liquid-base/tree/13d42192f3f1e4ec10616cb9dc978320ef02cb17/liquid-base/src/Data/PNat/Semigroup.hs).


### vrdt
#### The VRDT typeclass
The VRDT typeclass defines the properties that an instance needs to satisfy in order to prove its strong convergence. You can find this file at [/liquid-benchmark/vrdt/vrdt/src/VRDT/Class.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/Class.hs#L29).

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
[/liquid-benchmark/vrdt/vrdt/src/VRDT/Class/Proof.hs](https://github.com/jprider63/vrdt/tree/aa5ff450e5f05ec3316c86dd92ea3fae822dcf07/vrdt/src/VRDT/Class/Proof.hs#L15)

This file contains the strong convergence proof mentioned in Section 4.3. It is done purely in terms of the typeclass specification so it can be instantiated to any of the `VRDT` instances.

We reuse the strong convergence theorem in the proof of `TwoPMap`, a `VRDT` that is parameterized over another `VRDT`.

## Verify
Once the docker image finishes building, enter the shell with:
```
docker run --rm -it liquid-typeclasses /bin/bash
```

### Verify proofs

The working directory `liquid-benchmark` includes our extenstion to LiquidHaskell with typeclasses and all the programs we verify in our paper as git submodules. 
`vrdt` contains the verified CRDTs and the proof of strong convergence. The following command uses LiquidHaskell to typecheck the `VRDT` proofs that verify quickly. It verifies `vrdt` 2 times using 12 cores and outputs the sample variance and mean for the execution time:
```
cd /liquid-benchmark
stack exec liquid-benchmark -- --vrdt --fast --times 2 --cores 12
```

The `--fast` command skips the proofs for `TwoPMap` and `CausalTree` since these take hours to verify. You can verify all the `VRDT` instances with the following command, but it requires more hardware resources (we know that 16GiB of physical memory + 24GiB of swap space is sufficient):
```
stack exec liquid-benchmark -- --vrdt --times 1 --cores 1
```

`liquid-base` contains the verified instances of `Monad`, `Applicative`, `Monoid`, etc. 
We can typecheck all the verified instances in `liquid-base` using the following command:
```
stack exec liquid-benchmark -- --liquid-base
```
By default, the benchmark driver typechecks the programs 3 times using 4 cores.


### Typecheck each file separately

The `Dockerfile` adds the LiquidHaskell executable `liquid` to `PATH`. This allows you to verify the files individually, including the new files that you might want to add.

For example, to check the functor, applicative and monad instances of `Maybe`, you can do the following:
```
cd /liquid-benchmark
liquid --typeclass -i liquid-base/liquid-base/src/ liquid-base/liquid-base/src/Data/Maybe/Functor.hs 
```

Before verifying a file, LH will automatically verify the file's dependencies if they have not been verified already. This is why the benchmark driver typechecks the common dependencies before checking the proofs so the time it takes to verify a dependency will not be counted toward the time of the first proof that depends on it.

`liquid` does not know which GHC extensions to enable just by reading the source. You need to tell `liquid` which GHC extensions are enabled at the command line. For your convenience, here is a list of flags you should pass to LH to verify the majority of the files from the repo:
```
liquid --typeclass --ghc-option=-XBangPatterns --ghc-option=-XTypeFamilies --ghc-option=-XFlexibleContexts --ghc-option=-cpp -i DIR DIR/A/B/C/some-file.hs
```

## Running example distibuted applications
### Event application
Switch to the vrdt directory:
```
cd /liquid-benchmark/vrdt
```

Start the server:
```
stack exec -- kyowon-server 3000 &
```

Create a new tmux session:
```
tmux
```

Then start the event client application with:
```
stack exec -- event alice 2>/dev/null
```

Create a new tmux window with `ctrl-b c`. Use the same command from the previous step to start another client.


You can repeat the previous step repeatedly to create multiple clients and switch between tmux windows with `ctrl-b n` where n is the number associated with each window.
In the event application, you can create, edit, and RSVP to events and the rest of the clients will automatically update with your changes (dates are parsed as `2020-10-10 10:00am`).
Buttons may not render properly depending on your terminal. However, you should still be able to click on the text with your mouse.
The bottom button on the create event page creates an event.

### Collaborative text editor

You can run the collaborative text editor with the same instructions as the event application, except use the following command to start clients. Be sure to restart the `kyowon-server`.
```
stack exec -- collaborate 2>/dev/null
```

Move around with the arrow keys and type letters normally. 


