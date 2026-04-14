context("Prime-counting funcs")

test_that("Number of primes <= n", {
  expect_gte(prime_count(100, TRUE),  length(generate_primes(max = 100)))
  expect_lte(prime_count(100, FALSE), length(generate_primes(max = 100)))
})

test_that("Value of nth prime", {
  expect_gte(nth_prime_estimate(100, TRUE),  generate_n_primes(100)[100])
  expect_lte(nth_prime_estimate(100, FALSE), generate_n_primes(100)[100])
})

test_that("double input is validated", {
  expect_gte(prime_count(100.0, TRUE), length(generate_primes(max = 100)))
  expect_error(prime_count(3e9, TRUE))
  expect_error(nth_prime_estimate(3e9, TRUE))
  expect_error(prime_count(NA, TRUE))
})

test_that("negative input is rejected", {
  expect_error(prime_count(-5L, TRUE), "must be positive")
  expect_error(prime_count(0L, TRUE), "must be positive")
  expect_error(nth_prime_estimate(-5L, TRUE), "must be positive")
  expect_error(nth_prime_estimate(0L, TRUE), "must be positive")
})
