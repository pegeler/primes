#include <Rcpp.h>
#include <climits>    // INT_MAX
#include <vector>

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
std::vector<int> generate_n_primes_impl(int n) {
  if (n < 1)
    return {};

  // Otherwise the result would silently be padded out with zeros
  if (n > P_N_MAX)
    Rcpp::stop("n must be at most %d, the number of primes below 2^31", P_N_MAX);

  // The upper-bound estimate overshoots p_n by a few percent, so above about
  // 100.6 million it passes INT_MAX and is NA. p_n itself still fits for any
  // n <= P_N_MAX, so INT_MAX is a valid limit for the sieve.
  int max = n < 6 ? 11 : nth_prime_estimate_impl(n, true);
  if (max == NA_INTEGER)
    max = INT_MAX;

  auto out = generate_primes_(2, max);
  out.resize(n);
  return out;
}
