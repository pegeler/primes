context("Undefined behavior at C++ boundaries")

# NOTE: Each case runs code that once had undefined behavior, so that a
# sanitizer build (see Dockerfile.ubsan) keeps covering it. Many only need to
# run, hence expect_true(TRUE); do not remove them as redundant. Several call
# the `*_impl` routines directly, because the C++ interface is exported for
# LinkingTo and skips the R-level validation.

INT_MAX <- .Machine$integer.max

test_that("prime_count_impl does not convert Inf or NaN to int", {
  # n / log(n) is Inf at n = 1 and NaN for n < 0
  for (upper_bound in c(TRUE, FALSE)) {
    for (n in c(-INT_MAX, -1L, 0L, 1L)) {
      expect_identical(prime_count_impl(n, upper_bound), 0L)
    }
  }
})

test_that("nth_prime_estimate_impl stays within int range", {
  # log(1 * log(1)) is -Inf, and the estimate exceeds INT_MAX near INT_MAX
  for (upper_bound in c(TRUE, FALSE)) {
    expect_identical(nth_prime_estimate_impl(1L, upper_bound), 2L)
    expect_identical(nth_prime_estimate_impl(INT_MAX, upper_bound), NA_integer_)
  }
})

test_that("generate_primes_ accepts min at or below 1", {
  # The output-size estimate subtracted INT_MIN, and (min - 2) overflowed
  for (min in c(-INT_MAX, -10L, -1L, 0L, 1L)) {
    generate_primes_(min, 100L)
  }
  generate_primes_(-INT_MAX, 3L)
  sexy_prime_triplets_impl(-INT_MAX, 3L)
  generate_primes(1L, 100L)
  twin_primes(1, 100)
  k_tuple(-10L, 100L, c(0L, 2L))
  expect_true(TRUE)
})

test_that("sexy_prime_triplets_impl at INT_MAX", {
  # max + 6 overflowed
  sexy_prime_triplets_impl(INT_MAX - 20L, INT_MAX)
  expect_true(TRUE)
})

test_that("scm_impl does not overflow int", {
  # m / gcd(m, n) * n overflowed
  scm_impl(-INT_MAX, 2L)
  scm_impl(2L, -INT_MAX)
  scm_impl(INT_MAX, 2L)
  expect_true(TRUE)
})

test_that("next_prime_impl at INT_MAX", {
  # ++n overflowed and wrapped to INT_MIN
  expect_identical(next_prime_impl(INT_MAX), NA_integer_)
})

test_that("generate_primes_ at INT_MAX", {
  # (max + 1) overflowed, and so could p += inc in the sieve loop.
  # Allocates a ~128 MB bit vector.
  skip_unless_heavy()
  expect_identical(generate_primes_(INT_MAX, INT_MAX), INT_MAX)
})
