#' Compute the Primorial
#'
#' Computes the primorial for prime numbers and natural numbers.
#'
#' The `primorial_p` function computes the primorial with respect the the first
#' `n` _prime_ numbers; while the `primorial_n` function computes the primorial
#' with respect the the first `n` _natural_ numbers.
#'
#' @section Precision:
#' The result is a `double`, which can hold a primorial exactly only up to
#' 43# = 13,082,761,331,670,030. So `primorial_n(n)` for `n` above 46, and
#' `primorial_p(n)` for `n` above 14, return `NA` with a warning.
#'
#' @param n an integer indicating the numbers to be used in the computation. See
#'   _Details_ for more information.
#'
#' @return A numeric vector of length 1.
#' @name primorial
#' @author Paul Egeler, MS
NULL

PRIMORIAL_INEXACT_MSG <-
  "primorial is too large to represent exactly as a double; returning NA"

#' @rdname primorial
#' @export
primorial_n <- function(n) {
  n <- validate_inputs(n, scalar = TRUE)

  if (n < 0)
    stop("'n' must be >= zero")

  # 47# is the first primorial a double cannot hold exactly
  if (n >= 47L) {
    warning(PRIMORIAL_INEXACT_MSG)
    return(NA_real_)
  }

  prod(generate_primes(2L, n))
}

#' @rdname primorial
#' @export
primorial_p <- function(n) {
  n <- validate_inputs(n, scalar = TRUE)

  if (n < 0)
    stop("'n' must be >= zero")

  # The 15th prime is 47
  if (n >= 15L) {
    warning(PRIMORIAL_INEXACT_MSG)
    return(NA_real_)
  }

  prod(generate_n_primes(n))
}
