#' Format Bibentries in Roxygen
#'
#' @description
#' Operates on a named list of [bibentry()] entries and formats them nicely for
#' documentation with \CRANpkg{roxygen2}.
#'
#' * `format_bib()` is intended to be called in the `@references` section and
#'   prints the complete entry using [toRd()].
#' * `cite_bib()` returns the family name of the first author (if available, falling back
#'   to the complete author name if not applicable) and the year in format
#'   `"[LastName] (YYYY)"`.
#'
#' @param ... (`character()`)\cr
#'   One or more names of bibentries.
#' @param bibentries (named `list()`)\cr
#'   Named list of bibentries.
#' @param envir (`environment`)\cr
#'   Environment to lookup `bibentries` if not provided.
#'
#' @return (`character(1)`).
#'
#' @export
#' @examples
#' bibentries = list(checkmate = citation("checkmate"), R = citation())
#' format_bib("checkmate")
#' format_bib("R")
#' cite_bib("checkmate")
#' cite_bib("checkmate", "R")
format_bib = function(..., bibentries = NULL, envir = parent.frame()) {
  if (is.null(bibentries)) {
    bibentries = get("bibentries", envir = envir)
  }
  assert_list(bibentries, "bibentry", names = "unique")
  str = map_chr(list(...), function(entry) tools::toRd(bibentries[[entry]]))
  paste0(str, collapse = "\n\n")
}

#' @export
#' @rdname format_bib
cite_bib = function(..., bibentries = NULL, envir = parent.frame()) {
  if (is.null(bibentries)) {
    bibentries = get("bibentries", envir = envir)
  }
  assert_list(bibentries, "bibentry", names = "unique")

  str = map_chr(list(...), function(entry) {
    x = bibentries[[entry]]
    sprintf("%s (%s)", x$author[[1L]]$family %??% x$author[[1L]], x$year)
  })

  if (length(str) >= 3L) {
    str = c(toString(head(str, -1L)), tail(str, 1L))
  }

  paste0(str, collapse = " and ")
}
