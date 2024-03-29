#' @title Helpers to Create Manual Pages
#'
#' @description
#' `rd_info()` is an internal generic to generate Rd or markdown code to be used in manual pages.
#' `rd_format_string()` and `rd_format_range()` are string functions to assist generating
#' proper Rd code.
#'
#' @param obj (`any`)\cr
#'   Object of the respective class.
#' @param ... (`any)`)\cr
#'   Additional arguments.
#'
#' @return `character()`, possibly with markdown code.
#' @keywords Internal
#' @export
rd_info = function(obj, ...) {
  UseMethod("rd_info")
}

#' @rdname rd_info
#' @param lower (`numeric(1)`)\cr
#'   Lower bound.
#' @param upper (`numeric(1)`)\cr
#'   Upper bound.
#' @export
rd_format_range = function(lower, upper) {
  if (is.na(lower) || is.na(upper)) return("-")

  str = sprintf("%s%s, %s%s",
    if (is.finite(lower)) "[" else "(",
    if (is.finite(lower)) c(lower, lower) else c("-\\infty", "-Inf"),
    if (is.finite(upper)) c(upper, upper) else c("\\infty", "Inf"),
    if (is.finite(upper)) "]" else ")")
  paste0("\\eqn{", str[1L], "}{", str[2L], "}")
}

#' @rdname rd_info
#' @inheritParams str_collapse
#' @export
rd_format_string = function(str, quote = c("\\dQuote{", "}")) {
  if (length(str) == 0L) {
    return("-")
  }
  str_collapse(str, quote = quote)
}


#' @rdname rd_info
#' @param packages (`character()`)\cr
#'   Vector of package names.
#' @export
rd_format_packages = function(packages) {
  if (length(packages) == 0L) {
    return("-")
  }
  base_pkgs = c("base", "compiler", "datasets", "graphics", "grDevices", "grid", "methods",
    "parallel", "splines", "stats", "stats4", "tcltk", "tools", "translations", "utils"
  )
  link = packages %nin% base_pkgs
  str_collapse(sprintf("%s%s%s",
    ifelse(link, "\\CRANpkg{", "'"),
    packages,
    ifelse(link, "}", "'")
  ))
}
