#' Prime-counting Functions and Estimating the Value of the n-th Prime
#'
#' Functions for estimating \eqn{\pi(n)}{pi(n)}---the number of primes less than
#' or equal to \eqn{n}{n}---and for estimating the value of \eqn{p_n}, the n-th
#' prime number.
#'
#' The `prime_count` function estimates the number of primes \eqn{\le n}{<= n}.
#' Both bounds hold for all positive \eqn{n}: with `upper_bound = FALSE` the
#' estimate is never more than \eqn{\pi(n)}{pi(n)}, and with
#' `upper_bound = TRUE` it is never less.
#'
#' The `nth_prime_estimate` function brackets upper and lower bound values of
#' the nth prime. It is valid for \eqn{n \ge 6}{n >= 6}; for smaller \eqn{n}
#' the exact prime is returned.
#'
#' The methods of estimation used here are a few of many alternatives. For
#' further information, the reader is directed to the _References_ section.
#'
#' @section Range:
#' The result of `nth_prime_estimate` is `NA` when the estimate is larger than
#' the largest 32-bit integer, 2,147,483,647. For the upper bound, that is
#' \eqn{n} above about 100.6 million.
#'
#' @param n an integer. See _Details_ for more information.
#' @param upper_bound a logical indicating whether to estimate the lower- or
#'   upper bound.
#' @author Paul Egeler, MS
#' @references
#' "Prime-counting function" (2020) _Wikipedia_. \url{https://en.wikipedia.org/wiki/Prime-counting_function#Inequalities} (Accessed 26 Jul 2020).
#' @name prime_count
NULL

#' @rdname prime_count
#' @export
prime_count <- function(n, upper_bound) {
  n <- validate_inputs(n, scalar = TRUE, positive = TRUE)
  upper_bound <- validate_flag(upper_bound, "upper_bound")
  .Call('_primes_prime_count_impl', PACKAGE = 'primes', n, upper_bound)
}

#' @rdname prime_count
#' @export
nth_prime_estimate <- function(n, upper_bound) {
  n <- validate_inputs(n, scalar = TRUE, positive = TRUE)
  upper_bound <- validate_flag(upper_bound, "upper_bound")
  .Call('_primes_nth_prime_estimate_impl', PACKAGE = 'primes', n, upper_bound)
}
