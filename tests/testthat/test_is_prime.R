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
  expect_equal(is_prime(c(4L, NA, 5L, bigz)), c(FALSE, NA, TRUE, TRUE))
})

test_that("bigz are not silently coerced", {
  bigz <- 10 ^ 10 + 19
  expect_error(is_prime(bigz))
})
