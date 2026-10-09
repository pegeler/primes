context("Primorials")

test_that("n#",{
  expect_error(primorial_n(-1))
  expect_equal(primorial_n(0), 1)
  expect_equal(primorial_n(1), 1)
  expect_equal(primorial_n(2), 2)
  expect_equal(primorial_n(10), 210)
})

test_that("p_n#", {
  expect_error(primorial_p(-1))
  expect_equal(primorial_p(0), 1)
  expect_equal(primorial_p(1), 2)
  expect_equal(primorial_p(2), 6)
  expect_equal(primorial_p(10), 6469693230)
})

test_that("Primorials are NA where a double cannot hold them exactly", {
  # 43# is the largest exact primorial
  expect_identical(primorial_n(46), 13082761331670030)
  expect_identical(primorial_p(14), 13082761331670030)
  expect_warning(out <- primorial_n(47), "too large to represent exactly")
  expect_identical(out, NA_real_)
  expect_warning(out <- primorial_p(15), "too large to represent exactly")
  expect_identical(out, NA_real_)
  expect_warning(primorial_p(105097566L), "too large to represent exactly")
})
