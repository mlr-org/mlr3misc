#' @title Splits a list based on names
#'
#' @description
#' Named lists can be split into multiple lists by applying regexes to its names.
#'
#' @param x (named `list()`)\cr
#'   The list that will be split.
#' @param patterns (`list()`)\cr
#'   A list containing various regex patterns. If it is named, the output inherits those names.
#' @param ... (any)\cr
#'   Additional arguments to `grepl()`.
#'
#'@return
#' A (possibly named) `list()` of subsets of x.
#'
#' @export
split_list = function(x, patterns, ...) {
  assert_list(x)
  nms = names(x) %??% ""
  out = map(
    patterns,
    function(pattern) {
      x[grepl(pattern, nms, ...)]
    }
  )
  set_names(out, names(patterns))

  out
}
