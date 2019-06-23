#' @title Transpose lists of lists
#'
#' @description
#' Transposes a list of list, and turns it inside out, similar to the
#' function `transpose()` in package \CRANpkg{purrr}.
#'
#' @param .l (`list()` of `list()`).
#'
#' @return `list()`.
#' @export
#' @examples
#' x = list(list(a = 2, b = 3), list(a = 5, b = 10))
#' str(x)
#' str(transpose_list(x))
#'
#' # list of data frame rows:
#' transpose_list(iris[1:2, ])
transpose_list = function(.l) {
  assert(check_list(.l), check_data_frame(.l))
  if (length(.l) == 0L) {
    return(list())
  }
  res = .mapply(list, .l, list())
  if (length(res) == length(.l[[1L]])) {
    names(res) = names(.l[[1L]])
  }
  res
}
