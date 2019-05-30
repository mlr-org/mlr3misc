#' @title Suggest Alternatives
#'
#' @description
#' Helps to suggest something from a list of names, if the user mistyped in an argument check.
#'
#' @param str :: `character(1)`\cr
#'   String.
#' @param candidates :: `character`\cr
#'   Candidate strings.
#' @return (`character(1)`). Either a phrase suggesting one or more candidates from `candidates`,
#'   or an empty string if no close match is found.
#' @export
#' @examples
#' did_you_mean("yep", c("yes", "no"))
did_you_mean = function(str, candidates) {
  candidates = unique(candidates)
  D = set_names(adist(str, candidates, ignore.case = TRUE, partial = TRUE)[1L, ], candidates)
  suggested = names(head(sort(D[D <= ceiling(0.2 * nchar(str))]), 3L))

  if (!length(suggested)) {
    return("")
  }
  sprintf(" Did you mean %s?", str_collapse(suggested, quote = "'", sep = " / "))
}
