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
    # NOTE: NA and NaN propagate; na.rm = TRUE skips them. Order matters: after
    # the Inf check every remaining value is finite, so no filtering is needed.
    if (any(is.infinite(x)))
      stop("infinite values are not allowed")

    # Range is checked after truncation so it matches what as.integer() does.
    # NOTE: The bounds are symmetric because -2^31 is NA_integer_ in R, so it
    # is not a valid value even though it fits in 32 bits.
    whole <- trunc(x)

    if (any(abs(whole) > .Machine$integer.max, na.rm = TRUE))
      stop("values must be representable as 32-bit integers (max: +/- 2147483647)")

    if (any(x != whole, na.rm = TRUE))
      warning("non-integer values will be truncated to integers")
  }

  validate_inputs(as.integer(x), scalar, positive, ...)
}

#' @exportS3Method
validate_inputs.default <- function(x, ...) {
  # NOTE: S3 dispatch only falls back to the implicit class (integer/double)
  # when there is no class attribute, so a classed numeric lands here.
  # is.numeric() is FALSE for factor, Date, difftime, and POSIXct, which are
  # not meaningful inputs, so they are still rejected.
  if (!is.numeric(x))
    stop("input must be numeric")

  validate_inputs(unclass(x), ...)
}

validate_flag <- function(x, name) {
  if (!is.logical(x) || length(x) != 1L || is.na(x))
    stop(sprintf("'%s' must be TRUE or FALSE", name))

  x
}
