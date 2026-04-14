#' Test for Prime Numbers
#'
#' Test whether a vector of numbers is prime or composite.
#'
#' @param x an integer vector containing elements to be tested for primality.
#'
#' @examples
#' is_prime(4:7)
#' ## [1] FALSE  TRUE FALSE  TRUE
#'
#' is_prime(1299827)
#' ## [1] TRUE
#'
#' @return A logical vector. Values less than 1 (including negative numbers and
#'   zero) return \code{NA} because primality is only defined for natural
#'   numbers.
#' @author Os Keyes and Paul Egeler, MS
#' @export
is_prime <- function(x) {
  x <- validate_inputs(x)
  .Call('_primes_is_prime_impl', PACKAGE = 'primes', x)
}
