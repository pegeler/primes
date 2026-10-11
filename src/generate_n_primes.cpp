#include <Rcpp.h>
#include <climits>    // INT_MAX
#include <vector>

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
std::vector<int> generate_n_primes_impl(int n) {
  if (n < 1)
    return {};

  if (n > P_N_MAX)
    Rcpp::stop("n must be at most %d, the number of primes below 2^31", P_N_MAX);

  // The estimate can pass INT_MAX even when p_n fits
  int max = nth_prime_estimate_impl(n, true);
  if (max == NA_INTEGER)
    max = INT_MAX;

  auto out = generate_primes_(2, max);
  out.resize(n);
  return out;
}
