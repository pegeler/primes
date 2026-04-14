#' Find the Next and Previous Prime Numbers
#'
#' Find the next prime numbers or previous prime numbers over a vector.
#'
#' For `prev_prime`, if a value is less than or equal to 2, the function will
#' return `NA`.
#'
#' @param x a vector of integers from which to start the search.
#'
#' @examples
#' next_prime(5)
#' ## [1] 7
#'
#' prev_prime(5:7)
#' ## [1] 3 5 5
#' @aliases prev_prime
#' @return An integer vector of prime numbers.
#' @author Paul Egeler, MS
#' @export
next_prime <- function(x) {
  x <- validate_inputs(x)
  .Call('_primes_next_prime_impl', PACKAGE = 'primes', x)
}

#' @rdname next_prime
#' @export
prev_prime <- function(x) {
  x <- validate_inputs(x)
  .Call('_primes_prev_prime_impl', PACKAGE = 'primes', x)
}
