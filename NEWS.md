# primes 2.0.0

## Breaking changes

* `is_prime()` now returns `NA` (instead of `FALSE`) for non-natural numbers
  (negative integers and zero). Primality is defined only for natural numbers, so
  inputs outside this domain are now treated as undefined rather than "not prime."
  _e.g._, code that previously relied on `is_prime(-5L)` returning `FALSE` will
  need to be updated to `is_prime(-5L) %in% TRUE` to convert the `NA`s back to
  `FALSE`. Caller may also filter inputs beforehand with `x[x >= 1L]`.

* The C++ interface exported for use via `LinkingTo: primes` has been renamed.
  The exported C++ functions now carry an `_impl` suffix (_e.g._,
  `primes::gcd()` is now `primes::gcd_impl()`, `primes::is_prime()` is now
  `primes::is_prime_impl()`). Packages that call these from C++ must update
  their calls. Note that the `_impl` functions do no input validation.

## New features

* **Input validation.** All exported functions now check `double` (numeric)
  inputs before they are converted to integers. Previously, these problems
  silently produced wrong results:
    - Values outside the 32-bit integer range (+/- 2,147,483,647) raise an
      error instead of being silently converted to `NA`.
    - Infinite values (`Inf`, `-Inf`) raise an error.
    - Non-whole numbers (e.g., `5.3`) are truncated toward zero with a warning.

  Inputs that are already integers skip these checks.

* **`primes.validate_inputs` option.** The checks on `double` inputs can be
  turned off for the whole session with
  `options(primes.validate_inputs = FALSE)`, for long-running code whose inputs
  are known to be valid. Checks for `NA` and for positivity still apply.

* **`NA` propagation.** `next_prime()`, `prev_prime()`, `gcd()`, `scm()`, and
  `coprime()` now return `NA` in the matching position for each `NA` in the
  input, as `is_prime()` does. `NA` is an error where a value is required:
  scalar arguments, the `tuple` argument of `k_tuple()`, and `upper_bound` in
  `prime_count()` and `nth_prime_estimate()`, which must be `TRUE` or `FALSE`.

* **`logical` input is an error.** This includes a bare `NA`, which R types as
  `logical`. Use `NA_integer_` to pass a missing value, _e.g._,
  `is_prime(NA_integer_)`.

* **Negative number handling.** Functions that require strictly positive input
  (`phi()`, `prime_count()`, `nth_prime_estimate()`) now raise informative
  errors for zero and negative values. Functions where negative input is
  mathematically valid (`gcd()`, `scm()`, `coprime()`, `next_prime()`,
  `prev_prime()`) continue to accept them.

* Added package-level documentation (`?primes`) covering input handling, `NA`
  behavior, negative numbers, performance, and the validation option.

## Technical notes

* **Validation is an S3 generic.** Each exported R function calls
  `validate_inputs()`, which dispatches on the input's type. The `integer`
  method only enforces the scalar and positivity constraints, so integer inputs
  reach the C++ code with negligible R-level overhead. The `double` method
  checks for `Inf`, truncates, checks the 32-bit range on the truncated value
  (matching what `as.integer()` does), warns if truncation changed anything,
  and then hands the result to the `integer` method. Every other type,
  including `logical`, falls through to the `default` method and is an error.

* **Symmetric range.** The valid range is +/- 2,147,483,647, not the full
  32-bit range, because `-2147483648` is `NA_integer_` in R.

* **Exported functions are now thin R wrappers.** The compiled routines were
  renamed with an `_impl` suffix and are called from the R wrappers, which
  perform the validation. Roxygen documentation moved from the C++ sources to
  the R wrapper files accordingly.

* Vectorized binary operations in `gcd()` and `scm()` now share a common C++
  template (`recycle_binary_op`) with modulo-based index recycling, replacing
  duplicated loop code and the previous `Rcpp::rep_len` approach. It also
  handles `NA` propagation in one place.
