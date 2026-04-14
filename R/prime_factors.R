#' Perform Prime Factorization on a Vector
#'
#' Compute the prime factors of elements of an integer vector.
#'
#' @param x an integer vector.
#'
#' @examples
#' prime_factors(c(1, 5:7, 99))
#' ## [[1]]
#' ## integer(0)
#' ##
#' ## [[2]]
#' ## [1] 5
#' ##
#' ## [[3]]
#' ## [1] 2 3
#' ##
#' ## [[4]]
#' ## [1] 7
#' ##
#' ## [[5]]
#' ## [1]  3  3 11
#'
#' @return A list of integer vectors reflecting the prime factorizations of
#'   each element of the input vector.
#' @author Paul Egeler, MS
#' @export
prime_factors <- function(x) {
  x <- validate_inputs(x)
  .Call('_primes_prime_factors', PACKAGE = 'primes', x)
}
