# Slow or memory-hungry cases are opt-in: PRIMES_TEST_HEAVY=true, with
# NOT_CRAN=true so skip_on_cran() lets them through.
skip_unless_heavy <- function() {
  skip_on_cran()
  skip_if_not(
    nzchar(Sys.getenv("PRIMES_TEST_HEAVY")),
    "set PRIMES_TEST_HEAVY to run slow or memory-hungry tests"
  )
}
