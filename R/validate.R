validate_inputs <- function(x, ...) UseMethod("validate_inputs")

#' @exportS3Method
validate_inputs.integer <- function(x, scalar = FALSE, positive = FALSE, ...) {
  if (scalar) {
    if (length(x) != 1L)
      stop("input must be a single value")
    if (is.na(x))
      stop("input must not be NA")
  }

  if (positive && length(non_na <- x[!is.na(x)]) && any(non_na < 1L))
    stop("all values must be positive")

  x
}

#' @exportS3Method
validate_inputs.double <- function(x, scalar = FALSE, positive = FALSE, ...) {
  if (getOption("primes.validate_inputs", TRUE)) {
    non_na <- x[!is.na(x)]

    if (any(is.infinite(non_na)))
      stop("infinite values are not allowed")

    finite <- non_na[is.finite(non_na)]

    if (length(finite) && any(abs(finite) > .Machine$integer.max))
      stop("values must be representable as 32-bit integers (max: +/- 2147483647)")

    if (length(finite) && any(finite != trunc(finite)))
      warning("non-integer values will be truncated to integers")
  }

  validate_inputs(as.integer(x), scalar, positive, ...)
}

#' @exportS3Method
validate_inputs.default <- function(x, ...) {
  stop("input must be numeric")
}
