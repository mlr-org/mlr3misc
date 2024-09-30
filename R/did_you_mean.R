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
  suggested = find_suggested(str, candidates, threshold = 0.2)

  if (!length(suggested)) {
    return("")
  }
  sprintf(" Did you mean %s?", str_collapse(suggested, quote = "'", sep = " / "))
}

#' @title Suggest Alternatives from Given Dictionaries
#'
#' @description
#' Helps to suggest alternatives for a given key based on the keys of given dictionaries.
#'
#' @param key (`character(1)`) \cr
#'   Key to look for in `dicts`.
#' @param dicts (named list)\cr
#'   Named list of [dictionaries][Dictionary].
#' @return (`character(1)`). Either a phrase suggesting one or more keys based on the dictionaries in `dicts`,
#'   or an empty string if no close match is found.
did_you_mean_dicts = function(key, dicts) {
  if (is.null(dicts)) {
    return("")
  }
  # Iterate through dicts, get suggestions, paste as messages
  suggested = character(length(dicts))
  for (i in seq_along(dicts)) {
    entries = find_suggested(key, dicts[[i]]$keys())

    if (length(entries)) {
      suggested[[i]] = sprintf("%s: %s", names(dicts)[[i]],
                               str_collapse(entries, quote = "'", sep = " / "))
    }
  }
  # Drop elements for dicts for which no suggestions could be made
  suggested = suggested[nchar(suggested) > 0L]

  if (!length(suggested)) {
    return("")
  }
  sprintf(" Similar entries in other dictionaries, %s?", str_collapse(suggested, sep = " or "))

  # TODO: handle ordering for exact hits (order dicts approriately?)
  # TODO: maximum number of suggestions (within dict is handled by find_suggested, but not if we are looking at many dicts)
  # TODO: Tests
}

#' @title Find Suggestions
#'
#' @param str (`character(1)`)\cr
#'   String.
#' @param candidates (`character()`)\cr
#'   Candidate strings.
#' @param threshold (`numeric(1)`)\cr
#'   Percentage value of characters when sorting `candidates` by distance
#' @return (`character(1)`). Either suggested candidates from `candidates` or an empty string if no close match is found.
find_suggested = function(str, candidates, threshold = 0.2) {
  candidates = unique(candidates)
  D = set_names(adist(str, candidates, ignore.case = TRUE, partial = TRUE)[1L, ], candidates)
  names(head(sort(D[D <= ceiling(threshold * nchar(str))]), 3L))
}
