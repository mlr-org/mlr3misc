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
#' @param x The object.
#' @param trunc_width (`integer(1)`): Truncate strings to width `trunc_width`.
#'   Default is 15.
#' @param num_format (`character(1)`):
#'   Used to format numerical scalars via [base::sprintf()].
#'   Default is "\%.4g".
#' @return (`character(1)`).
#' @export
#' @examples
#' as_short_string(list(a = 1, b = NULL, "foo", c = 1:10))
as_short_string = function(x, trunc_width = 30L, num_format = "%.4g") {
  # convert non-list object to string
  convert = function(x) {
    if (is.atomic(x) && !is.null(x) && length(x) == 0L) {
      string = sprintf("%s(0)", cl)
    } else {
      cl = class(x)[1L]
      string = switch(cl,
        "numeric" = paste(sprintf(num_format, x), collapse=","),
        "integer" = paste(as.character(x), collapse = ","),
        "logical" = paste(as.character(x), collapse = ","),
        "character" = paste0(x, collapse = ","),
        "expression" = as.character(x),
        sprintf("<%s>", cl)
      )
    }
    str_trunc(string, trunc_width)
  }

  trunc_width = assert_int(trunc_width, coerce = TRUE)

  # handle only lists and not any derived data types
  if (class(x)[1L] == "list") {
    if (length(x) == 0L)
      return("list()")
    ns = names2(x, missing_val = "<unnamed>")
    ss = lapply(x, convert)
    paste0(paste0(ns, "=", ss), collapse = ", ")
  } else {
    convert(x)
  }
}