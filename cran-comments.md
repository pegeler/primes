## Version 2.0.0

This release makes breaking changes to the API: invalid input (out-of-range or
fractional `double`, `logical`, non-natural numbers to `is_prime()`) now
errors, warns, or returns `NA` instead of silently returning a wrong result.
See _NEWS.md_.

Reverse dependencies (LISTO, SFDesign): neither is expected to be affected.
Maintainers were notified on [DATE]. [RESPONSES]

All tests, and the exported functions at edge values, were run using
`rocker/r-devel-ubsan-clang`; no undefined behavior was detected. The undefined
behavior this turned up in earlier versions is fixed.

### R CMD check results

`R CMD check --as-cran` on Debian GNU/Linux (`rocker/r-devel` image):

* R 4.6.1 (release): 0 errors | 0 warnings | 1 note
* R Under development (r90574, 2026-09-20): 0 errors | 0 warnings | 2 notes

The notes come from the local environment: package V8 is not installed, so math
rendering in the HTML manual is skipped, and (R-devel only) Debian's default
compiler flags are reported as non-portable.

## Version 1.6.1

The failure observed in _tests/failures/testthat.Rout_ was inadvertently carried
over from debugging version 1.5.1. The files have been purged and the path has
been added to _.Rbuildignore_.

We have also confirmed again that no undefined behavior is detected by running
all tests using the `rocker/r-devel-ubsan-clang` on the latest build.

## Version 1.5.1

### Purpose

This patch release addresses the [clang-UBSan finding](https://www.stats.ox.ac.uk/pub/bdr/memtests/clang-UBSAN/primes/tests/testthat.Rout)
wherein an implicit conversion from `double` to `int` could result in
undefined behavior when the floating point value cannot be represented as an integer, _ie_, the value is `-nan`. The UBSan test output is below.

### Solution

Using the [rocker/r-devel-ubsan-clang](https://hub.docker.com/r/rocker/r-devel-ubsan-clang)
Docker container, I was able to reproduce the bug.

```
# RD -q
> version
               _                                                 
platform       x86_64-pc-linux-gnu                               
arch           x86_64                                            
os             linux-gnu                                         
system         x86_64, linux-gnu                                 
status         Under development (unstable)                      
major          4                                                 
minor          3.0                                               
year           2022                                              
month          09                                                
day            19                                                
svn rev        82882                                             
language       R                                                 
version.string R Under development (unstable) (2022-09-19 r82882)
nickname       Unsuffered Consequences                           
> packageVersion("primes")
[1] ‘1.5.0’
> source("testthat.R")
prime_factors.cpp:13:14: runtime error: -nan is outside the range of representable values of type 'int'
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior prime_factors.cpp:13:14 in 
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 62 ]

```

A patch was created to prevent a domain error when calling `std::sqrt`. After
applying the patch, recompiling, and reinstalling, the runtime error is no longer
encountered.

```
# RD -q
> packageVersion("primes")
[1] ‘1.5.1’
> source("testthat.R")
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 62 ]
```

### R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

R CMD check succeeded
