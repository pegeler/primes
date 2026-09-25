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

The functions in `primes` work on 32-bit integers. R's default numeric type is
`double`, so a call like `is_prime(7)` is fine; the value is checked and
converted to an integer before it is used. A `double` input is handled as
follows:

- **Values outside the 32-bit integer range** (beyond &plusmn;2,147,483,647)
  raise an error, rather than silently becoming `NA`.
- **Infinite values** (`Inf`, `-Inf`) raise an error.
- **Values that are not whole numbers** (e.g., `5.3`) are truncated toward zero
  (to `5`) with a warning.

Inputs that are already integers (e.g., `5L` or `1:10`) skip these checks.
Only numbers are accepted: `logical` input, including a bare `NA`, is an error.
Use `NA_integer_` to pass a missing value.

### `NA` Handling

Missing values in a vector are propagated element-wise. For example,
`is_prime(c(7L, NA, 9L))` returns `TRUE NA FALSE`, and `gcd(c(12L, NA), 8L)`
returns `4 NA`.

A missing value is an error where the function needs an actual value to work
with: scalar arguments such as `n` in `generate_n_primes()` or `min` and `max`
in `generate_primes()`, the `tuple` argument of `k_tuple()`, and the
`upper_bound` argument of `prime_count()` (which must be `TRUE` or `FALSE`).

### Negative Numbers

Some functions have a sensible answer for zero and negative numbers:

- `is_prime`: returns `NA`, because primality is only defined for natural
  numbers. Note that this is not the same as `FALSE`.
- `next_prime` / `prev_prime`: negative values are valid starting points for
  the search.
- `prime_factors`: returns `integer(0)` for values less than 2.
- `gcd`, `scm`, `coprime`: the sign of the inputs is ignored, so
  `gcd(-12L, 18L)` is `6`.

Other functions are not defined for zero or negative numbers and raise an
error:

- `phi`: Euler's totient is defined for positive integers.
- `prime_count` / `nth_prime_estimate`: the estimates are built on the natural
  logarithm, log(n), which needs a positive n.

### Disabling Validation

The checks on `double` input can be turned off for the whole R session with:

```r
options(primes.validate_inputs = FALSE)
```

The values are then converted with `as.integer()` and nothing else is checked,
so out-of-range values become `NA` and non-whole numbers are truncated without
a warning. This is not recommended for interactive work, but it can save time
in a long-running analysis whose inputs are already known to be valid. Checks
for `NA` and for positivity are always applied, regardless of this setting.
