context("Primality tests")

test_that("actual prime numbers are determined to be prime",{
  expect_true(is_prime(5))
  expect_true(is_prime(9587))
  expect_true(is_prime(1299827))
})

test_that("Non-primes are determined to be not-prime", {
  expect_false(is_prime(4))
  expect_false(is_prime(9586))
  expect_false(is_prime(1299824))
})

test_that("NAs are NAs", {
  expect_equal(is_prime(c(4L, NA, 5L)), c(FALSE, NA, TRUE))
})

test_that("non-natural numbers return NA", {
  expect_equal(is_prime(c(-5L, 0L, 1L, 2L)), c(NA, NA, FALSE, TRUE))
})

test_that("values exceeding integer range are rejected", {
  expect_error(is_prime(10 ^ 10 + 19))
})

test_that("double input with whole values works", {
  expect_equal(is_prime(c(4.0, 5.0)), c(FALSE, TRUE))
})

test_that("non-integer doubles warn about truncation", {
  expect_warning(is_prime(5.7))
})
