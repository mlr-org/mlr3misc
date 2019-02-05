#' @title Selects closest suggestion from a set of strings
#'
#' @description
#' Helps to suggest something from a list of names, if the user mistyped in an argcheck.
#'
#' @param str Given string
#' @param candidates (`character`)
#' @return (`character(1)`). Either an element from `candidates` or the empty string if no close match is found.
#' @export
did_you_mean = function(str, candidates) {
  candidates = unique(candidates)
  D = set_names(adist(str, candidates, ignore.case = TRUE, partial = TRUE)[1L, ], candidates)
  suggested = names(head(sort(D[D <= ceiling(0.2 * nchar(str))]), 3L))

  if (!length(suggested))
    return("")
  sprintf(" Did you mean %s?", str_collapse(suggested, quote = "'", sep = " / "))
}

