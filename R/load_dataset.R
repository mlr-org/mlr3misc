#' @title Retrieve a Single Data Set
#'
#' @description
#' Loads a data set with name `id` from package `package` and returns it.
#' If the package is not installed, an error with condition "packageNotFoundError" is raised.
#' The name of the missing packages is stored in the condition as `packages`.
#'
#' @param id :: `character(1)`\cr
#'   Name of the data set.
#' @param package :: `character(1)`\cr
#'   Package to load the data set from.
#' @param keep_rownames :: `logical(1)`\cr
#'   Keep possible row names (default: `FALSE`).
#'
#' @export
#' @examples
#' head(load_dataset("iris", "datasets"))
load_dataset = function(id, package, keep_rownames = FALSE) {

  assert_string(id)
  assert_string(package)
  assert_flag(keep_rownames)

  if (!length(find.package(package, quiet = TRUE))) {
    msg = sprintf("Please install package '%s' for data set '%s'", package, id)
    stop(errorCondition(msg, packages = package, class = "packageNotFoundError"))
  }

  ee = new.env(parent = emptyenv(), hash = FALSE)
  data(list = id, package = package, envir = ee)
  data = ee[[id]]
  if (!keep_rownames && (is.data.frame(data) || is.matrix(data))) {
    rownames(data) = NULL
  }
  data
}
