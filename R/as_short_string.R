#' @title Converts any R object to a descriptive string
#'
#' @description
#' This function is intended to be convert any R object to a short descriptive string,
#' e.g. in [base::print()] functions.
#'
#' The following ruleset applies:
#'
#' * `x` is `atomic` with length 0 or 1: printed as-is.
#' * `x` is of length greater than 1, they are first collapsed with ",", and the resulting string.
#'   is then truncated to `trunc_width`.
#' * `x` is an expression: converted to character.
#' * Otherwise: print their class.
#'
#' If `x` is a list, the above rules are applied (non-recursively) to its elements.
#'
#' @param x [any]\cr
#'   The object.
#' @param num.format [\code{character(1)}]\cr
#'   Used to format numerical scalars via \code{\link{sprintf}}.
#'   Default is \dQuote{\%.4g}.
#' @param trunc_width [\code{integer(1)}]\cr
#'   Truncate strings to width `trunc_width`.
#'   Default is 15.
#' @return [\code{character(1)}].
#' @export
#' @examples
#' as_short_string(list(a = 1, b = NULL, "foo", c = 1:10))
as_short_string = function(x, num_format = "%.4g", trunc_width = 15L) {
  # convert non-list object to string
  convert = function(x) {
    if (is.atomic(x) && !is.null(x) && length(x) == 0L) {
      string = sprintf("%s(0)", cl)
    } else {
      string = switch(cl,
        "numeric" = paste(sprintf(num_format, x), collapse=","),
        "integer" = paste(as.character(x), collapse = ","),
        "logical" = paste(as.character(x), collapse = ","),
        "character" = paste0(x, collapse = ","),
        "expression" = as.character(x),
        sprintf("<%s>", cl)
      )
    }
    stri_trunc(string, trunc_width)
  }

  cl = class(x)[1L]
  trunc_width = assert_int(trunc_width, coerce = TRUE)

  # handle only lists and not any derived data types
  if (cl == "list") {
    if (length(x) == 0L)
      return("list()")
    ns = names2(x, missing_val = "<unnamed>")
    ss = lapply(x, convert)
    paste0(paste0(ns, "=", ss), collapse = ", ")
  } else {
    convert(x)
  }
}
