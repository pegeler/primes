#include <Rcpp.h>
#include <climits>    // INT_MAX
#include <cmath>

// [[Rcpp::interfaces(r, cpp)]]

static const double prime_count_c = 30 * log((double)113) / 113;

// NOTE: Converting a double that is out of range (or NaN) to int is undefined
// behavior, so return NA instead. INT_MAX + 1 is exactly representable, and
// anything below it truncates into range.
static inline int int_or_na(double x) {
  return x >= static_cast<double>(INT_MAX) + 1 ? NA_INTEGER : static_cast<int>(x);
}

// [[Rcpp::export]]
int prime_count_impl(int n, bool upper_bound) {
  // There are no primes at or below 1. This also keeps n / log(n) from being
  // Inf at n = 1 and NaN for n < 0.
  if (n < 2)
    return 0;

  return (upper_bound ? prime_count_c : 1) * n / log((double)n);
}

// [[Rcpp::export]]
int nth_prime_estimate_impl(int n, bool upper_bound) {
  // The bounds only hold for n >= 6, and log(n * log(n)) is -Inf at n = 1, so
  // the first five primes are returned exactly. That is both a valid lower and
  // a valid upper bound.
  static const int first_primes[] = {2, 3, 5, 7, 11};
  if (n < 1)
    return NA_INTEGER;
  if (n < 6)
    return first_primes[n - 1];

  double c = upper_bound ? 0 : 1;
  // For n above about 100.6 million the upper-bound estimate is larger than
  // INT_MAX and cannot be returned as an int, so this is NA. The true p_n is
  // smaller than the estimate and still fits up to n = P_N_MAX.
  return int_or_na(n * (log(n * log((double)n)) - c));
}
