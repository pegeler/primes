#include <Rcpp.h>

#include "primes.h"

// [[Rcpp::interfaces(r, cpp)]]

// NOTE: Indices outside 1..P_N_MAX have no 32-bit answer and give NA. Only the
// largest valid index sets how many primes are generated.
static inline bool has_nth_prime(int n) { return n > 0 && n <= P_N_MAX; }

// [[Rcpp::export]]
Rcpp::IntegerVector nth_prime_impl(const Rcpp::IntegerVector &x) {
  if (!x.size())
    return {};

  int max = 0;
  for (auto n : x)
    if (has_nth_prime(n) && n > max)
      max = n;

  auto primes = generate_n_primes_impl(max);
  auto out = Rcpp::IntegerVector(x.size());
  auto it = out.begin();

  for (auto n : x)
    *(it++) = has_nth_prime(n) ? primes[n - 1] : NA_INTEGER;

  return out;
}
