.onLoad <- function(libname, pkgname) {
  op <- options()
  op.primes <- list(
    primes.validate_inputs = TRUE
  )
  toset <- !(names(op.primes) %in% names(op))
  if (any(toset)) options(op.primes[toset])

  invisible()
}
