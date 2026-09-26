#' Get the n-th Prime from the Sequence of Primes.
#'
#' Get the n-th prime, \eqn{p_n}, in the sequence of primes.
#'
#' The result is a 32-bit integer, so the largest \eqn{n} with an answer is
#' 105,097,565, for which \eqn{p_n} is 2,147,483,647.
#'
#' @param x an integer vector.
#'
#' @examples
#' nth_prime(5)
#' ## [1] 11
#'
#' nth_prime(c(1:3, 7))
#' ## [1]  2  3  5 17
#' @return An integer vector. Elements are `NA` where `x` is less than 1 or
#'   greater than 105,097,565.
#' @author Paul Egeler, MS
#' @export
nth_prime <- function(x) {
  x <- validate_inputs(x)
  .Call('_primes_nth_prime_impl', PACKAGE = 'primes', x)
}
