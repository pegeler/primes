context("Prime-counting funcs")

test_that("Number of primes <= n", {
  expect_gte(prime_count(100, TRUE),  length(generate_primes(max = 100)))
  expect_lte(prime_count(100, FALSE), length(generate_primes(max = 100)))
})

test_that("Value of nth prime", {
  expect_gte(nth_prime_estimate(100, TRUE),  generate_n_primes(100)[100])
  expect_lte(nth_prime_estimate(100, FALSE), generate_n_primes(100)[100])
})

test_that("The first five primes are exact, since the bounds need n >= 6", {
  first <- c(2L, 3L, 5L, 7L, 11L)
  for (upper_bound in c(TRUE, FALSE)) {
    estimates <- vapply(1:5, nth_prime_estimate, 1L, upper_bound = upper_bound)
    expect_identical(estimates, first)
  }
})

test_that("There are no primes at or below 1", {
  expect_identical(prime_count(1L, TRUE), 0L)
  expect_identical(prime_count(1L, FALSE), 0L)
})

test_that("The estimate is capped at INT_MAX rather than overflowing", {
  expect_identical(
    nth_prime_estimate(.Machine$integer.max, TRUE),
    .Machine$integer.max
  )
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

test_that("upper_bound must be TRUE or FALSE", {
  for (bad in list(NA, "a", 1L, c(TRUE, FALSE), NULL)) {
    expect_error(prime_count(100L, bad), "must be TRUE or FALSE")
    expect_error(nth_prime_estimate(100L, bad), "must be TRUE or FALSE")
  }
})
