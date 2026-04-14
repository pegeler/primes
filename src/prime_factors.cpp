#include <Rcpp.h>
#include <cmath>      // sqrt
#include <vector>

#include "primes.h"

using std::sqrt;

// [[Rcpp::interfaces(r, cpp)]]

static Rcpp::IntegerVector prime_factors_(int n, const std::vector<int> &primes) {
  if (n < 2)
    return {};

  Rcpp::IntegerVector factors;

  // TODO: static_cast<double>() no longer necessary. Overload from integer
  //       supported since C++11.
  int stop = sqrt(static_cast<double>(n));
  for (auto p = primes.begin(); p != primes.end() && *p <= stop && n > 1; ++p) {
    while (n % *p == 0) {
      factors.push_back(*p);
      n /= *p;
    }
  }
  if (n > 1) {
    factors.push_back(n);
  }

  return factors;
}

// [[Rcpp::export]]
Rcpp::List prime_factors_impl(const Rcpp::IntegerVector &x) {
  if (!x.size())
    return {};

  Rcpp::List out(x.size());
  auto it = out.begin();
  int max = Rcpp::algorithm::max_nona(x.begin(), x.end());
  auto primes = generate_primes_(2, max > 8 ? sqrt(static_cast<double>(max)) : 2);

  for (auto n : x) {
    *(it++) = Rcpp::IntegerVector::is_na(n)
                  ? Rcpp::IntegerVector::create(NA_INTEGER)
                  : prime_factors_(n, primes);
  }

  return out;
}
