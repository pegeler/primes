Fast Functions for Prime Numbers in R
=====================================

[![CRAN version](https://www.r-pkg.org/badges/version/primes)](https://cran.r-project.org/package=primes)
[![Number of Downloads](https://cranlogs.r-pkg.org/badges/grand-total/primes)](https://cran.r-project.org/package=primes)

**Authors**: Os Keyes and Paul Egeler  
**License**: [MIT](https://opensource.org/license/mit)

## Description

This R package has several utility functions for dealing with prime numbers,
such as checking for primality and generating prime numbers. Additional
functions include:

- finding prime factors and Ruth-Aaron pairs
- finding next and previous prime numbers in the series
- finding or estimating the n<sup>th</sup> prime
- estimating the number of primes less than or equal to an arbitrary number
- computing primorials
- finding prime k-tuples (e.g., twin primes)
- finding the greatest common divisor and smallest (least) common multiple
- testing whether two numbers are coprime
- computing Euler's totient (phi)

The package also provides an R dataset containing the first one thousand primes.
Most functions are vectorized and implemented in C++ for speed.

## Installation

You can install the released version of primes from [CRAN](https://CRAN.R-project.org) with:

```r
install.packages("primes")
```

And the development version from [GitHub](https://github.com/) with:

```r
# install.packages("devtools")
devtools::install_github("ironholds/primes")
```

## Example

This checks which of the first twenty natural numbers are prime:

```r
library(primes)

is_prime(1:20)
## [1] FALSE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE
## [15] FALSE FALSE  TRUE FALSE  TRUE FALSE
```

You can also generate all the prime numbers between 101 and 199 with the following:

```r
generate_primes(101, 199)
## [1] 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173 179 181 191 193 197 199
```

## Input Handling

All functions in `primes` expect integer input. Because R's default numeric
type is `double`, the package validates inputs and converts them to integers
automatically. The following checks are performed on `double` inputs:

- **Values exceeding 32-bit integer range** (larger than
  &plusmn;2,147,483,647) raise an error.
- **Infinite values** (`Inf`, `-Inf`) raise an error.
- **Non-whole numbers** (e.g., `5.3`) are truncated to integers with a
  warning.

Integer inputs bypass the above checks and are passed directly to the C++
backend.

### `NA` Handling

`NA` values are passed through and handled element-wise. Functions like
`is_prime`, `next_prime`, `gcd`, etc. will return `NA` in the corresponding
position. Functions that take scalar arguments (e.g., `generate_n_primes`,
`prime_count`) will error on `NA`.

### Negative Numbers

Most functions in the package accept negative integers without error, though
the results follow mathematical convention:

- `is_prime`: returns `NA` for non-natural numbers (primality is defined
  only for natural numbers).
- `next_prime` / `prev_prime`: negative values are valid starting points
  for the search.
- `prime_factors`: returns `integer(0)` for values less than 2.
- `gcd`, `scm`, `coprime`: use absolute values internally, so negative
  inputs are handled correctly.

Some functions require strictly positive input and will error on zero or
negative values:

- `phi`: Euler's totient is defined only for positive integers.
- `prime_count` / `nth_prime_estimate`: require positive `n` because the
  underlying formulas involve `log(n)`.

### Disabling Validation

Input validation for `double` inputs can be turned off globally by setting:

```r
options(primes.validate_inputs = FALSE)
```

When disabled, `double` inputs are coerced via `as.integer()` without any range
or finiteness checks. This is not recommended for interactive use but may be
useful for performance-sensitive code where inputs are known to be safe. Note
that scalar, `NA`, and positivity checks still apply regardless of this setting.
