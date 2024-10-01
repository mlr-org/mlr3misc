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
  suggestions = find_suggestions(str, candidates, threshold = 0.2, max_candidates = 3L, ret_distances = FALSE)

  if (!length(suggestions)) {
    return("")
  }
  sprintf(" Did you mean %s?", str_collapse(suggestions, quote = "'", sep = " / "))
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
  # No message if no dictionaries are given
  if (is.null(dicts)) {
    return("")
  }

  suggestions = character(length(dicts))
  min_distance_per_dict = numeric(length(dicts))

  for (i in seq_along(dicts)) {
    # Get distances and the corresponding entries for the current dictionary
    distances = find_suggestions(key, dicts[[i]]$keys(), ret_distances = TRUE)
    entries = names(distances)

    # Handle the case of no matches: skip the dictionary
    if (!length(entries)) {
      min_distance_per_dict[[i]] = NA
      next
    }
    # Record the closest distance
    min_distance_per_dict[[i]] = min(distances)

    # Create a suggestion message for the current dictionary
    suggestions[[i]] = sprintf("%s: %s", names(dicts)[[i]],
                               str_collapse(entries, quote = "'", sep = " / "))
  }

  # Order the suggestions by their closest match
  suggestions = suggestions[order(min_distance_per_dict)]
  # Remove empty suggestions (i.e., dictionaries with no close matches)
  valid_suggestions = suggestions[nchar(suggestions) > 0L]
  # Only show the 3 dictionaries with the best matches
  valid_suggestions = head(valid_suggestions, 3L)

  # If no valid suggestions, return an empty string
  if (!length(valid_suggestions)) {
    return("")
  }

  sprintf("\nSimilar entries in other dictionaries, %s.", str_collapse(valid_suggestions, sep = ", or "))
}

#' @title Find Suggestions
#'
#' @param str (`character(1)`)\cr
#'   String.
#' @param candidates (`character()`)\cr
#'   Candidate strings.
#' @param threshold (`numeric(1)`)\cr
#'   Percentage value of characters when sorting `candidates` by distance
#' @param max_candidates (`integer(1)`)\cr
#'   Maximum number of candidates to return.
#' @param ret_similarity (`logical(1)`)\cr
#'   Return similarity values instead of names.
#' @return (`character(1)`). Either suggested candidates from `candidates` or an empty string if no close match is found.
find_suggestions = function(str, candidates, threshold = 0.2, max_candidates = 3L, ret_distances = FALSE) {
  candidates = unique(candidates)
  D = set_names(adist(str, candidates, ignore.case = TRUE, partial = TRUE)[1L, ], candidates)
  sorted = head(sort(D[D <= ceiling(threshold * nchar(str))]), max_candidates)
  if (ret_distances) {
    sorted
  } else {
    names(sorted)
  }
}
