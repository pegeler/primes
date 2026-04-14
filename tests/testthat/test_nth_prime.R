context("nth prime")

test_that("The nth prime is correct", {
  expect_equal(nth_prime(5), 11L)
  expect_equal(nth_prime(0), NA_integer_)
})

test_that("NAs are handled", {
  expect_equal(nth_prime(c(1L, NA, 3L)), c(2L, NA, 5L))
})

test_that("double input is validated", {
  expect_equal(nth_prime(5.0), 11L)
  expect_error(nth_prime(3e9))
})
