# primes 2.0.0

This release makes invalid input an error (or a warning) instead of a silently
wrong answer. Code that passes valid, whole-number input is unaffected. The
changes below describe what happens to code that was relying on the old
behavior, and how to update it.

## Breaking changes

### Most likely to affect existing code

* `sum(is_prime(x))` with any `x <= 0`
    - 1.x: counts the primes.
    - 2.0: returns `NA`.
    - Fix: `sum(is_prime(x), na.rm = TRUE)`.
* `x[is_prime(x)]` with any `x <= 0`
    - 1.x: returns only the primes.
    - 2.0: includes an `NA` row for each non-natural number.
    - Fix: `x[which(is_prime(x))]`.
* `if (is_prime(x))` or `&&` with `x <= 0`
    - 1.x: `FALSE`.
    - 2.0: error, because the condition is `NA`.
    - Fix: guard with `x >= 1`, or use `is_prime(x) %in% TRUE`.
* Fractional doubles, _e.g._, `is_prime(0.29 * 100)`
    - 1.x: silently truncates 28.999... to 28.
    - 2.0: same value, plus a warning.
    - Fix: `round()` before the call.
* Doubles above 2^31 - 1, or `Inf`
    - 1.x: `NA` or garbage, with a warning.
    - 2.0: error.
    - Fix: filter or rescale the inputs.
* `factor`, `Date`, `difftime`, or `POSIXct` input
    - 1.x: computed on the underlying number (for a factor, its integer codes).
    - 2.0: error.
    - Fix: `as.integer()`, if that is what was meant.
* `logical` input, including an all-`NA` column (_e.g._, from `read.csv()`)
    - 1.x: coerced to integer.
    - 2.0: error.
    - Fix: `as.integer()`.

`which(is_prime(x))` is unaffected. Only code that treated `FALSE` as a real
answer for non-natural numbers breaks, because primality is only defined for
natural numbers. The fractional-double case matters most under
`options(warn = 2)` or a strict CI, where the new warning becomes a failure.

A numeric vector that carries a class attribute (_e.g._, `haven_labelled`) is
handled by its underlying type and works as before.

### Less likely

* `phi(0)`, `phi(-6)`, and `prime_count(-5, ...)` now error. 1.x returned `0`,
  `-6`, and `NA`, respectively.
* `prime_count(100, 1)` and `prime_count(100, NA)` now error; `upper_bound` must
  be `TRUE` or `FALSE`. 1.x accepted both and treated them as `TRUE`. The same
  applies to `nth_prime_estimate()`.
* `generate_primes(NA, 10)` and `generate_n_primes(NA)` now error. 1.x returned
  the primes up to 10 and `integer(0)`, respectively.
* `k_tuple()` with an `NA` in `tuple` still errors, but with a clearer message.
* `scm()` and `Rscm()` return `NA` with a warning when the least common multiple
  is larger than 2,147,483,647. 1.x returned a wrong number without any
  warning.
* `prime_count(1, ...)` returns `0` (1.x returned `NA`), and
  `nth_prime_estimate()` returns the exact prime for `n` from 1 to 5, where its
  bounds do not hold. Its estimate is capped at 2,147,483,647.
* `next_prime(2147483647L)` returns `NA`, because 2^31 - 1 is prime and there
  is no larger 32-bit integer.
* `NA_integer_` is now the way to pass a missing value: a bare `NA` is
  `logical`, which is rejected (see above). _e.g._, `is_prime(NA_integer_)`.

### Unchanged

`nth_prime(0L)`, `nth_prime(-3L)`, and `prime_count(1, TRUE)` behave as they did
in 1.x. Matrices and named vectors still work. Functions where a negative input
is meaningful (`gcd()`, `scm()`, `coprime()`, `next_prime()`, `prev_prime()`)
still accept it.

### C++ interface

The C++ interface exported for use via `LinkingTo: primes` has been renamed.
The exported C++ functions now carry an `_impl` suffix (_e.g._,
`primes::gcd()` is now `primes::gcd_impl()`, `primes::is_prime()` is now
`primes::is_prime_impl()`). Packages that call these from C++ must update their
calls. Note that the `_impl` functions do no input validation.

## What 2.0 fixes

These 1.x results were silently wrong:

* `gcd(3e9, 12)` returned `4`.
* `next_prime(2^31)` returned `2`.
* `gcd(NA, 4)` returned `4`.
* `next_prime(c(7L, NA))` returned `c(11, 2)`.
* `Rgcd(12, 18, NA)` returned `-2`.
* `is_prime(factor(7))` returned `FALSE`, from the factor's integer code.
* `phi(-6)` returned `-6`.
* `scm(2147483647L, 2L)` returned `2`, and `Rscm(46341L, 46343L, 2L)` returned
  `194630`. The least common multiple overflowed a 32-bit integer.
* `generate_primes(2, .Machine$integer.max)` failed with `std::bad_alloc`. It
  now returns all 105,097,565 primes below 2^31.
* `nth_prime_estimate(2:5, TRUE)` returned `0 3 6 10`, below the true primes
  `3 5 7 11`, and `nth_prime_estimate(1, ...)` returned `NA`. So did estimates
  for `n` above about 1e8.
* `next_prime(2147483647L)` returned `2`.

## Upgrading from 1.x

`options(primes.validate_inputs = FALSE)` is not a compatibility switch. It
turns off only the checks on `double` values; it does not restore
`is_prime(-3)` returning `FALSE`, or logical input being accepted. Update the
calling code as described above.

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
  `prime_count()` and `nth_prime_estimate()`.

* Added package-level documentation (`?primes`) covering input handling, `NA`
  behavior, negative numbers, performance, and the validation option.

## Technical notes

* **Validation is an S3 generic.** Each exported R function calls
  `validate_inputs()`, which dispatches on the input's type. The `integer`
  method only enforces the scalar and positivity constraints, so integer inputs
  reach the C++ code with negligible R-level overhead. The `double` method
  checks for `Inf`, truncates, checks the 32-bit range on the truncated value
  (matching what `as.integer()` does), warns if truncation changed anything,
  and then hands the result to the `integer` method. Every other type falls
  through to the `default` method. S3 dispatch only falls back to the implicit
  class (`integer`, `double`) when an object has no class attribute, so the
  `default` method re-dispatches any classed object for which `is.numeric()` is
  `TRUE` after `unclass()`. Everything else, including `logical`, `factor`,
  `Date`, `difftime`, and `POSIXct`, is an error.

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

* **Undefined behavior.** Running every export against edge values under
  clang's UBSan found out-of-range `double` to `int` conversions in
  `prime_count()` and `nth_prime_estimate()`, and signed integer overflow in
  the sieve's output-size estimate, in `(min - 2)` and `(max + 1)`, in the
  sieve loop, in `scm()`, and in `next_prime()`. All are fixed. They were
  reachable by ordinary calls such as `generate_primes(1, 100)`, and, because
  the C++ interface is exported for `LinkingTo`, some can be reached without
  the R-level validation. `Dockerfile.ubsan` builds an image to reproduce the
  run, and `tests/testthat/test_undefined_behavior.R` keeps these cases
  covered.
