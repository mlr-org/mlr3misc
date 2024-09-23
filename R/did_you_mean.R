#' @title Suggest Alternatives
#'
#' @description
#' Helps to suggest alternatives from a list of strings, based on the string similarity in [utils::adist()].
#'
#' @param str (`character(1)`)\cr
#'   String.
#' @param candidates (`character()`)\cr
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

# write new function: did_you_mean_dicts
# extracts keys from dicts
# passes this to same logic as did_you_mean (can't call directioly, bc of the "Did you mean?" everytime)
# Wraps results according to the dictionary, i.e. "po(%s)" or some such
# Returns string with full message
did_you_mean_dicts = function(key, dicts) {
  # ASSERTIONS
  # maybe not necessary; did_you_mean doesn't and should be checked higher up anyway?


}
