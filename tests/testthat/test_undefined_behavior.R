context("Undefined behavior at C++ boundaries")

# NOTE: These call the compiled `*_impl` routines directly. The exported R
# functions validate their inputs, but the C++ interface is also exported for
# use via LinkingTo, where nothing validates. Each block records a finding from
# running every export against edge values under clang UBSan. There are no
# real assertions on purpose: the only goal is for a sanitizer build to execute
# the offending expression, and the closing expect_true(TRUE) just keeps
# testthat from flagging the test as empty. See Dockerfile.ubsan.

INT_MAX <- .Machine$integer.max

# Slow or memory-hungry cases are opt-in: PRIMES_TEST_HEAVY=true, with
# NOT_CRAN=true so skip_on_cran() lets them through.
skip_unless_heavy <- function() {
  skip_on_cran()
  skip_if_not(
    nzchar(Sys.getenv("PRIMES_TEST_HEAVY")),
    "set PRIMES_TEST_HEAVY to run slow or memory-hungry tests"
  )
}

test_that("prime_count_impl does not convert Inf or NaN to int", {
  # prime_count.cpp: n / log(n) is Inf at n = 1 and NaN for n < 0. Zero is a
  # control: 0 / log(0) is -0, which converts safely.
  for (upper_bound in c(TRUE, FALSE)) {
    for (n in c(-INT_MAX, -1L, 0L, 1L)) {
      prime_count_impl(n, upper_bound)
    }
  }
  expect_true(TRUE)
})

test_that("nth_prime_estimate_impl stays within int range", {
  # prime_count.cpp: log(1 * log(1)) is -Inf at n = 1, and the estimate exceeds
  # INT_MAX for n near INT_MAX.
  for (upper_bound in c(TRUE, FALSE)) {
    nth_prime_estimate_impl(1L, upper_bound)
    nth_prime_estimate_impl(INT_MAX, upper_bound)
  }
  expect_true(TRUE)
})

test_that("generate_primes_ accepts min at or below 1", {
  # sieve.cpp: estimate_output_size() subtracts prime_count_impl(min, FALSE),
  # which is INT_MIN (cast from Inf or NaN) for min <= -1 or min == 1, and
  # X - INT_MIN overflows. Separately, (min - 2) overflows near -INT_MAX.
  for (min in c(-INT_MAX, -10L, -1L, 0L, 1L)) {
    generate_primes_(min, 100L)
  }
  generate_primes_(-INT_MAX, 3L)
  sexy_prime_triplets_impl(-INT_MAX, 3L)
  expect_true(TRUE)
})

test_that("exported wrappers survive min at or below 1", {
  # Natural calls that reach the same code through validated inputs
  generate_primes(1L, 100L)
  twin_primes(1, 100)
  k_tuple(-10L, 100L, c(0L, 2L))
  for (upper_bound in c(TRUE, FALSE)) {
    prime_count(1L, upper_bound)
    nth_prime_estimate(1L, upper_bound)
    nth_prime_estimate(INT_MAX, upper_bound)
  }
  expect_true(TRUE)
})

test_that("scm_impl does not overflow int", {
  # gcd.cpp: m / gcd(m, n) * n exceeds INT_MAX when the least common multiple
  # is out of range
  scm_impl(-INT_MAX, 2L)
  scm_impl(2L, -INT_MAX)
  scm_impl(INT_MAX, 2L)
  expect_true(TRUE)
})

test_that("next_prime_impl at INT_MAX", {
  # next_prime.cpp: ++n overflows, wrapping to INT_MIN and scanning ~2^31
  # candidates. No larger prime is representable as an int.
  skip_unless_heavy()
  next_prime_impl(INT_MAX)
  expect_true(TRUE)
})

test_that("generate_primes_ at INT_MAX", {
  # sieve.cpp: (max + 1) overflows, and p += inc in the sieve loop can pass
  # INT_MAX. Allocates a ~128 MB bit vector and takes a while.
  skip_unless_heavy()
  generate_primes_(INT_MAX, INT_MAX)
  expect_true(TRUE)
})
