#' Fast Functions for Prime Numbers
#'
#' Utility functions for dealing with prime numbers, including primality
#' testing, prime generation, prime factorization, k-tuples, GCD/LCM, and
#' Euler's totient function. Most functions are vectorized and all core
#' computations are implemented in C++ via \pkg{Rcpp}.
#'
#' @section Performance:
#' Prime generation uses an optimized Sieve of Eratosthenes. GCD computation
#' uses Euclid's algorithm. Input validation uses S3 method dispatch so that
#' \code{integer} inputs incur minimal R-level overhead---they are passed
#' directly to the C++ backend, with only scalar and positivity checks when
#' necessary.
#'
#' @section Input handling:
#' All functions expect integer input. When \code{double} (numeric) values
#' are passed, the package validates and converts them to integers
#' automatically:
#' \itemize{
#'   \item Values exceeding the 32-bit integer range (\eqn{\pm 2{,}147{,}483{,}647})
#'     raise an error.
#'   \item Infinite values (\code{Inf}, \code{-Inf}) raise an error.
#'   \item Non-whole numbers (e.g., \code{5.3}) are truncated with a warning.
#' }
#'
#' @section NA handling:
#' \code{NA} values in vector inputs are propagated element-wise---functions
#' such as \code{\link{is_prime}}, \code{\link{next_prime}}, \code{\link{gcd}},
#' etc. return \code{NA} in the corresponding position. Functions that take
#' scalar arguments (e.g., \code{\link{generate_n_primes}},
#' \code{\link{prime_count}}) will error on \code{NA}.
#'
#' @section Negative numbers:
#' Most functions accept negative integers without error:
#' \itemize{
#'   \item \code{\link{is_prime}}: returns \code{NA} for non-natural numbers
#'     (primality is defined only for natural numbers).
#'   \item \code{\link{next_prime}} / \code{\link{prev_prime}}: negative values
#'     are valid starting points.
#'   \item \code{\link{prime_factors}}: returns \code{integer(0)} for values
#'     less than 2.
#'   \item \code{\link{gcd}}, \code{\link{scm}}, \code{\link{coprime}}: use
#'     absolute values internally.
#' }
#'
#' Functions that require strictly positive input will error on zero or
#' negative values:
#' \itemize{
#'   \item \code{\link{phi}}: Euler's totient is defined for positive integers.
#'   \item \code{\link{prime_count}} / \code{\link{nth_prime_estimate}}: the
#'     underlying formulas involve \code{log(n)}.
#' }
#'
#' @section Disabling validation:
#' Type-coercion validation for \code{double} inputs can be turned off by
#' setting \code{options(primes.validate_inputs = FALSE)}. When disabled,
#' \code{double} inputs are coerced via \code{as.integer()} without
#' range or finiteness checks. Scalar, \code{NA}, and positivity checks still
#' apply regardless of this setting.
#'
#' @author Os Keyes and Paul Egeler
#' @useDynLib primes
#' @importFrom Rcpp sourceCpp
#' @aliases primes-package
#' @keywords package
"_PACKAGE"
