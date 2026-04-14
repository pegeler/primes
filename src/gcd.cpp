#include <Rcpp.h>
#include <algorithm>  // max, swap
#include <numeric>    // accumulate
#include <cstdlib>    // abs

// [[Rcpp::interfaces(r, cpp)]]

// [[Rcpp::export]]
int gcd_(int m, int n) {

  m = abs(m), n = abs(n);
  if (n > m)
    std::swap(m, n);

  // Euclid's Algorithm
  while (n > 0) {
    int r = m % n;
    m = n;
    n = r;
  }

  return m;
}

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

// [[Rcpp::export]]
int scm_(int m, int n) {
  return m == 0 || n == 0 ? 0 : abs(m / gcd_(m, n) * n);
}

// [[Rcpp::export]]
int Rscm_(const Rcpp::IntegerVector &x) {
  if (Rcpp::any(Rcpp::is_na(x)))
    return NA_INTEGER;
  return std::accumulate(
    x.begin() + 1,
    x.end(),
    *x.begin(),
    scm_
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
Rcpp::IntegerVector gcd(const Rcpp::IntegerVector &m,
                        const Rcpp::IntegerVector &n) {
  return recycle_binary_op<gcd_>(m, n);
}

// [[Rcpp::export]]
Rcpp::IntegerVector scm(const Rcpp::IntegerVector &m,
                        const Rcpp::IntegerVector &n) {
  return recycle_binary_op<scm_>(m, n);
}

// [[Rcpp::export]]
Rcpp::LogicalVector coprime(const Rcpp::IntegerVector &m,
                            const Rcpp::IntegerVector &n) {
  return gcd(m, n) == 1;
}
