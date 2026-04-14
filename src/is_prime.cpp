#include <Rcpp.h>
#include <cmath>

// [[Rcpp::interfaces(r, cpp)]]

bool is_prime_(int x) {

  if (x < 4)
    return x > 1;

  if (x % 2 == 0 || x % 3 == 0)
    return false;

  for (int i = 5, stop = sqrt((double)x); i <= stop; i += 6)
    if (x % i == 0 || x % (i + 2) == 0)
      return false;

  return true;
}

// [[Rcpp::export]]
Rcpp::LogicalVector is_prime(const Rcpp::IntegerVector &x) {

  R_xlen_t len = x.size();
  Rcpp::LogicalVector out(len);

  // NOTE: `x[i] < 1` is doing double duty as NA check and domain check.
  for (R_xlen_t i = 0; i < len; i++)
    out[i] = x[i] < 1 ? NA_INTEGER : is_prime_(x[i]);

  return out;
}
