#' Get the n-th Prime from the Sequence of Primes.
#'
#' Get the n-th prime, \eqn{p_n}, in the sequence of primes.
#'
#' @param x an integer vector.
#'
#' @examples
#' nth_prime(5)
#' ## [1] 11
#'
#' nth_prime(c(1:3, 7))
#' ## [1]  2  3  5 17
#' @return An integer vector.
#' @author Paul Egeler, MS
#' @export
nth_prime <- function(x) {
  x <- validate_inputs(x)
  .Call('_primes_nth_prime_impl', PACKAGE = 'primes', x)
}
