# primes 2.0.0

## **Breaking changes**

* `is_prime()` now returns `NA` (instead of `FALSE`) for non-natural numbers
  (negative integers and zero). Primality is defined only for natural numbers, so
  inputs outside this domain are now treated as undefined rather than "not prime."
  _e.g._, Code that previously relied on `is_prime(-5L)` returning `FALSE` will
  need to be updated to `is_prime(-5L) %in% TRUE` to convert the `NA`s back to
  `FALSE`. Caller may also filter inputs beforehand with `x[x >= 1L]`.

## New features

* **Input validation with S3 dispatch.** All exported functions now validate
  `double` (numeric) inputs before passing them to the C++ backend:
    - Values exceeding the 32-bit integer range (+/- 2,147,483,647) raise an
      error instead of being silently converted to `NA`.
    - Infinite values (`Inf`, `-Inf`) raise an error.
    - Non-whole numbers (e.g., `5.3`) are truncated with a warning.

  Integer inputs bypass all type-coercion checks via S3 method dispatch and are
  passed directly to C++ with zero R-level overhead.

* **`primes.validate_inputs` option.** Type-coercion validation for `double`
  inputs can be disabled globally with `options(primes.validate_inputs = FALSE)`
  for performance-sensitive code where inputs are known to be safe. Scalar, `NA`,
  and positivity checks still apply regardless of this setting.

* **Improved NA propagation.** `next_prime()`, `prev_prime()`, `gcd()`,
  `scm()`, and `coprime()` now correctly propagate `NA` values element-wise
  instead of producing undefined results.

* **Negative number handling.** Functions that require strictly positive input
  (`phi()`, `prime_count()`, `nth_prime_estimate()`) now raise informative
  errors for zero and negative values. Functions where negative input is
  mathematically valid (`gcd()`, `scm()`, `coprime()`, `next_prime()`,
  `prev_prime()`) continue to accept them.

* Added package-level documentation (`?primes`) covering input handling,
  NA behavior, negative numbers, performance, and the validation option.

## Internal

* Vectorized binary operations in `gcd()` and `scm()` now share a common C++
  template (`recycle_binary_op`) with modulo-based vector recycling, replacing
  duplicated loop code and the previous `Rcpp::rep_len` approach.

* Roxygen documentation moved from C++ source files to R wrapper files.
