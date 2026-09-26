#include <Rcpp.h>
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

  // The estimate is NA when it does not fit in an int, which the sieve reads as
  // INT_MAX. That is a valid limit here: p_n fits for any n <= P_N_MAX.
  int max = n >= 6 ? nth_prime_estimate_impl(n, true) : 11;
  auto out = generate_primes_(2, max);
  out.resize(n);
  return out;
}
