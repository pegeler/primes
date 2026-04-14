context("Next and previous primes")

test_that("Search for next prime works", {
  expect_equal(next_prime(-1:7), c(2L, 2L, 2L, 3L, 5L, 5L, 7L, 7L, 11L))
})

test_that("Search for previous also works", {
  expect_equal(prev_prime(-1:7), c(NA, NA, NA, NA, 2L, 3L, 3L, 5L, 5L))
})

test_that("NAs propagate in next_prime", {
  expect_equal(next_prime(c(5L, NA, 7L)), c(7L, NA, 11L))
})

test_that("NAs propagate in prev_prime", {
  expect_equal(prev_prime(c(5L, NA, 7L)), c(3L, NA, 5L))
})

test_that("double input is validated", {
  expect_equal(next_prime(5.0), 7L)
  expect_error(next_prime(3e9))
  expect_warning(next_prime(5.5))
})
