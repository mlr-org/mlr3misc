#' @title Convert R Object to a Descriptive String
#'
#' @description
#' This function is intended to be convert any R object to a short descriptive string,
#' e.g. in [base::print()] functions.
#'
#' The following rules apply:
#'
#' * if `x` is `atomic()` with length 0 or 1: printed as-is.
#' * if `x` is `atomic()` with length greater than 1, `x` is collapsed with `","`,
#'   and the resulting string is truncated to `trunc_width` characters.
#' * if `x` is an expression: converted to character.
#' * Otherwise: the class is printed.
#'
#' If `x` is a list, the above rules are applied (non-recursively) to its elements.
#'
#' @param x :: `any`\cr
#'   Arbitrary object.
#' @param width :: `integer(1)`\cr
#'   Truncate strings to width `width`.
#' @param num_format :: `character(1)`\cr
#'   Used to format numerical scalars via [base::sprintf()].
#' @return (`character(1)`).
#' @export
#' @examples
#' as_short_string(list(a = 1, b = NULL, "foo", c = 1:10))
as_short_string = function(x, width = 30L, num_format = "%.4g") {
  # convert non-list object to string
  convert = function(x) {
    if (is.atomic(x) && !is.null(x) && length(x) == 0L) {
      string = sprintf("%s(0)", cl)
    } else {
      cl = class(x)[1L]
      string = switch(cl,
        "numeric" = paste0(sprintf(num_format, x), collapse = ","),
        "integer" = paste0(as.character(x), collapse = ","),
        "logical" = paste0(as.character(x), collapse = ","),
        "character" = paste0(x, collapse = ","),
        "expression" = as.character(x),
        sprintf("<%s>", cl)
      )
    }
    str_trunc(string, width = width)
  }

  width = assert_int(width, coerce = TRUE)

  # handle only lists and not any derived data types
  if (class(x)[1L] == "list") {
    if (length(x) == 0L) {
      return("list()")
    }
    ns = names2(x, missing_val = "<unnamed>")
    ss = lapply(x, convert)
    paste0(paste0(ns, "=", ss), collapse = ", ")
  } else {
    convert(x)
  }
}
