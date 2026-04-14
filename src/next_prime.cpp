#include <Rcpp.h>

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
Rcpp::IntegerVector next_prime_impl(const Rcpp::IntegerVector &x) {

  Rcpp::IntegerVector out(x.size());
  auto it = out.begin();

  for (auto n : x) {
    if (Rcpp::IntegerVector::is_na(n)) {
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
