context("nth prime")

test_that("The nth prime is correct", {
  expect_equal(nth_prime(5), 11L)
  expect_equal(nth_prime(0), NA_integer_)
})

test_that("Indices with no 32-bit answer are NA", {
  # 105097565 is the last index whose prime fits in an int
  expect_identical(nth_prime(c(1L, 105097566L, .Machine$integer.max)), c(2L, NA, NA))
})

test_that("The largest index with a 32-bit answer works", {
  skip_unless_heavy()
  expect_identical(nth_prime(105097565L), .Machine$integer.max)
})

test_that("NAs are handled", {
  expect_equal(nth_prime(c(1L, NA, 3L)), c(2L, NA, 5L))
})

test_that("double input is validated", {
  expect_equal(nth_prime(5.0), 11L)
  expect_error(nth_prime(3e9))
})
