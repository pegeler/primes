#include <Rcpp.h>
#include <algorithm>  // max_element

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
Rcpp::IntegerVector nth_prime(const Rcpp::IntegerVector &x) {
  if (!x.size())
    return {};

  auto primes = generate_n_primes(*std::max_element(x.begin(), x.end()));
  auto out = Rcpp::IntegerVector(x.size());
  auto it = out.begin();

  for (auto n : x)
    *(it++) = n > 0 ? primes[n - 1] : NA_INTEGER;

  return out;
}
