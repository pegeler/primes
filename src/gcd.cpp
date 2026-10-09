#include <Rcpp.h>
#include <algorithm>  // max
#include <climits>    // INT_MAX
#include <cstdint>    // int64_t
#include <numeric>    // accumulate, gcd, lcm

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
int gcd_(int m, int n) { return std::gcd(m, n); }

// [[Rcpp::export]]
int Rgcd_(const Rcpp::IntegerVector &x) {
  int out = x[0];

  if (Rcpp::IntegerVector::is_na(out))
    return NA_INTEGER;

  for (auto it = x.begin() + 1; it != x.end() && out != 1; ++it) {
    if (Rcpp::IntegerVector::is_na(*it))
      return NA_INTEGER;
    out = gcd_(out, *it);
  }
  return out;
}

// NOTE: NA when the result does not fit in an int. Inputs must not be NA.
// [[Rcpp::export]]
int scm_(int m, int n) {
  // Computed in 64 bits, where the lcm of two ints always fits
  std::int64_t out = std::lcm<std::int64_t, std::int64_t>(m, n);
  return out > INT_MAX ? NA_INTEGER : static_cast<int>(out);
}

// NOTE: NA can come from the input or from an overflow along the way
// [[Rcpp::export]]
int Rscm_(const Rcpp::IntegerVector &x) {
  return std::accumulate(
    x.begin() + 1,
    x.end(),
    *x.begin(),
    [](int acc, int y) {
      return acc == NA_INTEGER || y == NA_INTEGER ? NA_INTEGER : scm_(acc, y);
    }
  );
}

template <int (*Op)(int, int)>
Rcpp::IntegerVector recycle_binary_op(const Rcpp::IntegerVector &m,
                                      const Rcpp::IntegerVector &n) {
  if (!m.size() || !n.size())
    return {};

  R_xlen_t len = std::max(m.size(), n.size());
  R_xlen_t m_len = m.size(), n_len = n.size();
  Rcpp::IntegerVector out(len);

  for (R_xlen_t i = 0; i < len; i++) {
    int a = m[i % m_len], b = n[i % n_len];
    out[i] = Rcpp::IntegerVector::is_na(a) || Rcpp::IntegerVector::is_na(b)
                 ? NA_INTEGER
                 : Op(a, b);
  }

  return out;
}

// [[Rcpp::export]]
Rcpp::IntegerVector gcd_impl(
    const Rcpp::IntegerVector &m,
    const Rcpp::IntegerVector &n
) {
  return recycle_binary_op<gcd_>(m, n);
}

// [[Rcpp::export]]
Rcpp::IntegerVector scm_impl(
    const Rcpp::IntegerVector &m,
    const Rcpp::IntegerVector &n
) {
  return recycle_binary_op<scm_>(m, n);
}

// [[Rcpp::export]]
Rcpp::LogicalVector coprime_impl(
    const Rcpp::IntegerVector &m,
    const Rcpp::IntegerVector &n
) {
  return gcd_impl(m, n) == 1;
}
