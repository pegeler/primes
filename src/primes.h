#ifndef R_PKG_PRIMES_H
#define R_PKG_PRIMES_H

#include <Rcpp.h>
#include <vector>

std::vector<int> generate_primes_(int min, int max);
std::vector<int> generate_n_primes_impl(int n);
Rcpp::IntegerVector nth_prime_impl(const Rcpp::IntegerVector& x);
bool is_prime_(int x);
Rcpp::LogicalVector is_prime_impl(const Rcpp::IntegerVector& x);
Rcpp::IntegerVector next_prime_impl(const Rcpp::IntegerVector& x);
Rcpp::IntegerVector prev_prime_impl(const Rcpp::IntegerVector& x);
int prime_count_impl(int n, bool upper_bound);
int nth_prime_estimate_impl(int n, bool upper_bound);
Rcpp::List k_tuple_impl(int min, int max, std::vector<int> tuple);
Rcpp::List sexy_prime_triplets_impl(int min, int max);
Rcpp::List prime_factors_impl(const Rcpp::IntegerVector& x);
int gcd_(int m, int n);
int scm_(int m, int n);
int Rgcd_(const Rcpp::IntegerVector& x);
int Rscm_(const Rcpp::IntegerVector& x);
Rcpp::IntegerVector gcd_impl(const Rcpp::IntegerVector& m, const Rcpp::IntegerVector& n);
Rcpp::IntegerVector scm_impl(const Rcpp::IntegerVector& m, const Rcpp::IntegerVector& n);
Rcpp::LogicalVector coprime_impl(const Rcpp::IntegerVector& m, const Rcpp::IntegerVector& n);

#endif // R_PKG_PRIMES_H
