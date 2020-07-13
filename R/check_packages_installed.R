#' @title Check that packages are installed, without loading them
#'
#' @description
#' Calls [find.package()] to check if the all packages are installed.
#'
#' @param pkgs (`character()`)\cr
#'   Packages to check.
#' @param warn (`logical(1)`)\cr
#'   If `TRUE`, signals a warning of class `"packageNotFoundWarning"` about the missing packages.
#' @param msg (`character(1)`)\cr
#'   Format of the warning message. Use `"%s"` as placeholder for the list of packages.
#' @return (`logical()`) named with package names. `TRUE` if the respective package is installed, `FALSE` otherwise.
#' @export
#' @examples
#' check_packages_installed(c("mlr3misc", "foobar"), warn = FALSE)
#'
#' # catch warning
#' tryCatch(check_packages_installed(c("mlr3misc", "foobaaar")),
#'   packageNotFoundWarning = function(w) as.character(w))
check_packages_installed = function(pkgs, warn = TRUE, msg = "The following packages are required but not installed: %s") {
  pkgs = unique(assert_character(pkgs, any.missing = FALSE))
  assert_flag(warn)
  found = setNames(map_lgl(pkgs, function(pkg) length(find.package(pkg, quiet = TRUE)) > 0L), pkgs)

  if (warn && !all(found)) {
    assert_string(msg)
    miss = pkgs[!found]
    warning(warningCondition(sprintf(msg, paste0(miss, collapse = ",")), packages = miss, class = "packageNotFoundWarning"))
  }

  found
}
