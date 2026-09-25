#' Fast Functions for Prime Numbers
#'
#' Utility functions for dealing with prime numbers, including primality
#' testing, prime generation, prime factorization, k-tuples, GCD/LCM, and
#' Euler's totient function. Most functions are vectorized and all core
#' computations are implemented in C++ via \pkg{Rcpp}.
#'
#' @section Performance:
#' Primes are generated with an optimized Sieve of Eratosthenes, and greatest
#' common divisors are found with Euclid's algorithm. Inputs that are already
#' integers (e.g., `5L` or `1:10`) skip the checks described under _Input
#' handling_, so they are the fastest to process.
#'
#' @section Input handling:
#' The functions in this package work on 32-bit integers. R's default numeric
#' type is `double`, so a call like `is_prime(7)` is fine; the value is checked
#' and converted to an integer before it is used. A `double` input is handled
#' as follows:
#' \itemize{
#'   \item Values outside the 32-bit integer range
#'     (\eqn{\pm 2{,}147{,}483{,}647}) raise an error, rather than silently
#'     becoming `NA`.
#'   \item Infinite values (`Inf`, `-Inf`) raise an error.
#'   \item Values that are not whole numbers (e.g., `5.3`) are truncated
#'     toward zero (to `5`) with a warning.
#' }
#'
#' Only numbers are accepted. `logical` input, including a bare `NA`, is an
#' error; use `NA_integer_` to pass a missing value.
#'
#' @section NA handling:
#' Missing values in a vector are propagated element-wise. For example,
#' `is_prime(c(7L, NA, 9L))` returns `TRUE NA FALSE`, and `gcd(c(12L, NA), 8L)`
#' returns `4 NA`. This applies to \code{\link{is_prime}},
#' \code{\link{next_prime}}, \code{\link{prev_prime}}, \code{\link{gcd}},
#' \code{\link{scm}}, \code{\link{coprime}}, and similar vectorized functions.
#'
#' A missing value is an error where the function needs an actual value to
#' work with: scalar arguments such as `n` in \code{\link{generate_n_primes}}
#' or `min` and `max` in \code{\link{generate_primes}}, the `tuple` argument of
#' \code{\link{k_tuple}}, and the `upper_bound` argument of
#' \code{\link{prime_count}} (which must be `TRUE` or `FALSE`).
#'
#' @section Negative numbers:
#' Some functions have a sensible answer for zero and negative numbers:
#' \itemize{
#'   \item \code{\link{is_prime}}: returns `NA`, because primality is only
#'     defined for natural numbers. Note that this is not the same as `FALSE`.
#'   \item \code{\link{next_prime}} / \code{\link{prev_prime}}: negative values
#'     are valid starting points for the search.
#'   \item \code{\link{prime_factors}}: returns `integer(0)` for values less
#'     than 2.
#'   \item \code{\link{gcd}}, \code{\link{scm}}, \code{\link{coprime}}: the sign
#'     of the inputs is ignored, so `gcd(-12L, 18L)` is `6`.
#' }
#'
#' Other functions are not defined for zero or negative numbers and raise an
#' error:
#' \itemize{
#'   \item \code{\link{phi}}: Euler's totient is defined for positive integers.
#'   \item \code{\link{prime_count}} / \code{\link{nth_prime_estimate}}: the
#'     estimates are built on the natural logarithm, \eqn{\log(n)}, which needs
#'     a positive \eqn{n}.
#' }
#'
#' @section Disabling validation:
#' The checks on `double` input can be turned off for the whole R session with
#' `options(primes.validate_inputs = FALSE)`. The values are then converted
#' with `as.integer()` and nothing else is checked, so out-of-range values
#' become `NA` and non-whole numbers are truncated without a warning. This is
#' not recommended for interactive work, but it can save time in a
#' long-running analysis whose inputs are already known to be valid. Checks for
#' `NA` and for positivity are always applied, regardless of this setting.
#'
#' @author Os Keyes and Paul Egeler
#' @useDynLib primes
#' @importFrom Rcpp sourceCpp
#' @aliases primes-package
#' @keywords package
"_PACKAGE"
