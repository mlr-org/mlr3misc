#' @title Loads and Returns a Single Data Set
#'
#' @description
#' Loads a data set with name `id` from package `package` and returns it.
#'
#' @param id (`character(1)`): Name of the data set.
#' @param package (`character(1)`): Package to load the data set from.
#' @param keep_rownames (`logical(1)`): Keep possible row names (default: `FALSE`).
#'
#' @export
#' @examples
#' load_dataset("iris", "datasets")
load_dataset = function(id, package, keep_rownames = FALSE) {
  assert_string(id)
  assert_string(package)
  assert_flag(keep_rownames)

  if (!length(find.package(package, quiet = TRUE)))
    stopf("Please install package '%s' for data set '%s'", package, id)

  ee = new.env(parent = emptyenv())
  data(list = id, package = package, envir = ee)
  data = ee[[id]]
  if ((is.data.frame(data) || is.matrix(data)) && !keep_rownames)
    rownames(data) = NULL
  data
}
