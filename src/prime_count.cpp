#include <Rcpp.h>
#include <climits>    // INT_MAX
#include <cmath>

// [[Rcpp::interfaces(r, cpp)]]

static const double prime_count_c = 30 * log((double)113) / 113;

// [[Rcpp::export]]
int prime_count_impl(int n, bool upper_bound) {
  // No primes below 2 (and n / log(n) is Inf or NaN there)
  if (n < 2)
    return 0;

  return (upper_bound ? prime_count_c : 1) * n / log((double)n);
}

// [[Rcpp::export]]
int nth_prime_estimate_impl(int n, bool upper_bound) {
  // The bounds need n >= 6, so the first five primes are exact
  static const int first_primes[] = {2, 3, 5, 7, 11};
  if (n < 1)
    return NA_INTEGER;
  if (n < 6)
    return first_primes[n - 1];

  double c = upper_bound ? 0 : 1;
  double est = n * (log(n * log((double)n)) - c);
  // NA when the estimate does not fit in an int (n above about 100.6 million)
  return est < INT_MAX + 1.0 ? static_cast<int>(est) : NA_INTEGER;
}
