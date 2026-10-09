#include <Rcpp.h>
#include <climits>    // INT_MAX

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
Rcpp::IntegerVector next_prime_impl(const Rcpp::IntegerVector &x) {

  Rcpp::IntegerVector out(x.size());
  auto it = out.begin();

  for (auto n : x) {
    if (Rcpp::IntegerVector::is_na(n)) {
      *(it++) = NA_INTEGER;
    } else if (n == INT_MAX) {
      // 2^31 - 1 is prime and there is no larger int, so ++n would overflow
      *(it++) = NA_INTEGER;
    } else {
      while (!is_prime_(++n))
        ;
      *(it++) = n;
    }
  }

  return out;
}

// [[Rcpp::export]]
Rcpp::IntegerVector prev_prime_impl(const Rcpp::IntegerVector &x) {

  Rcpp::IntegerVector out(x.size());
  auto it = out.begin();

  for (auto n : x) {
    if (Rcpp::IntegerVector::is_na(n)) {
      *(it++) = NA_INTEGER;
    } else {
      while (!is_prime_(--n) && n >= 2)
        ;
      *(it++) = n >= 2 ? n : NA_INTEGER;
    }
  }

  return out;
}
