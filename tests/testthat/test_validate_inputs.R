context("Input validation")

test_that("non-numeric input is rejected", {
  expect_error(validate_inputs("abc"), "input must be numeric")
  expect_error(validate_inputs(TRUE), "input must be numeric")
  expect_error(validate_inputs(list(1, 2)), "input must be numeric")
})

test_that("scalar enforcement works", {
  expect_error(validate_inputs(1:3, scalar = TRUE), "input must be a single value")
  expect_error(validate_inputs(NA_real_, scalar = TRUE), "input must not be NA")
  expect_error(validate_inputs(NA_integer_, scalar = TRUE), "input must not be NA")
  expect_equal(validate_inputs(5, scalar = TRUE), 5L)
})

test_that("values exceeding integer range are rejected", {
  expect_error(validate_inputs(3e9), "32-bit integers")
  expect_error(validate_inputs(-3e9), "32-bit integers")
  expect_error(validate_inputs(c(1, .Machine$integer.max + 1)), "32-bit integers")
})

test_that("infinite values are rejected", {
  expect_error(validate_inputs(Inf), "infinite values")
  expect_error(validate_inputs(-Inf), "infinite values")
  expect_error(validate_inputs(c(1, Inf)), "infinite values")
})

test_that("non-whole numbers produce a warning", {
  expect_warning(validate_inputs(5.5), "truncated")
  expect_warning(validate_inputs(c(1.1, 2.2)), "truncated")
})

test_that("whole doubles are converted without warning", {
  expect_equal(validate_inputs(5.0), 5L)
  expect_equal(validate_inputs(c(2.0, 3.0)), c(2L, 3L))
})

test_that("integer input passes through unchanged", {
  expect_equal(validate_inputs(5L), 5L)
  expect_equal(validate_inputs(c(1L, NA, 3L)), c(1L, NA, 3L))
})

test_that("NAs pass through in vector mode", {
  expect_equal(validate_inputs(c(1, NA, 3)), c(1L, NA, 3L))
  expect_equal(validate_inputs(c(NA_real_, 5)), c(NA_integer_, 5L))
})

test_that("positive enforcement works for integers", {
  expect_error(validate_inputs(-1L, positive = TRUE), "must be positive")
  expect_error(validate_inputs(0L, positive = TRUE), "must be positive")
  expect_error(validate_inputs(c(5L, -1L), positive = TRUE), "must be positive")
  expect_equal(validate_inputs(1L, positive = TRUE), 1L)
  # NAs are allowed in vector mode with positive
  expect_equal(validate_inputs(c(1L, NA, 3L), positive = TRUE), c(1L, NA, 3L))
})

test_that("positive enforcement works for doubles", {
  expect_error(validate_inputs(-1.0, positive = TRUE), "must be positive")
  expect_error(validate_inputs(0.0, positive = TRUE), "must be positive")
  expect_equal(validate_inputs(1.0, positive = TRUE), 1L)
})

test_that("validation can be disabled via option", {
  withr::with_options(
    list(primes.validate_inputs = FALSE),
    {
      # non-whole values silently truncated (no warning)
      expect_silent(validate_inputs(5.5))
      expect_identical(validate_inputs(5.5), 5L)
      # large values become NA with warning
      expect_warning(validate_inputs(3e9), "NAs introduced by coercion")
      expect_identical(suppressWarnings(validate_inputs(3e9)), NA_integer_)
    }
  )
})

test_that("positive check still applies when validation is disabled", {
  withr::with_options(
    list(primes.validate_inputs = FALSE),
    {
      expect_error(validate_inputs(-1.0, positive = TRUE), "must be positive")
    }
  )
})
