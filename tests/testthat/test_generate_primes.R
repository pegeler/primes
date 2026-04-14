context("Prime generators")

test_that("Prime numbers can be generated, full stop", {
  expect_equal(generate_primes(max=12), c(2,3,5,7,11))
})

test_that("'min' is respected", {
  expect_equal(generate_primes(4, 12), c(5,7,11))
  expect_equal(generate_primes(5, 12), c(5,7,11))
})

test_that("Can generate up to the nth prime", {
  expect_equal(generate_n_primes(5), c(2,3,5,7,11))
  expect_equal(generate_n_primes(0), integer(0))
  expect_equal(generate_n_primes(-1), integer(0))
})

test_that("double input is validated for generators", {
  expect_equal(generate_primes(max = 12.0), c(2,3,5,7,11))
  expect_equal(generate_n_primes(5.0), c(2,3,5,7,11))
  expect_error(generate_primes(max = 3e9))
  expect_error(generate_n_primes(3e9))
  expect_error(generate_n_primes(NA))
})
