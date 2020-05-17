#' @title Execture code with a modified search path
#'
#' @description
#' Attaches a package to the search path (if not already attached), executes code and
#' eventually removes the package from the search path again, restoring the previous state.
#'
#' Note that this function is deprecated in favor of the (now fixed) version in \CRANpkg{withr}.
#'
#' @param package (`character(1)`)\cr
#'   Name of the package to attach.
#' @param code (`expression`)\cr
#'   Code to run.
#' @param ... (`any`)\cr
#'   Additional arguments passed to [library()].
#' @return Result of the evaluation of `code`.
#' @seealso \CRANpkg{withr} package.
#' @export
with_package = function(package, code, ...) {
  is_attached = package %in% .packages()
  if (!is_attached) {
    suppressPackageStartupMessages({
      get("library")(package, warn.conflicts = FALSE, character.only = TRUE, quietly = TRUE, ...)
    })
    on.exit(detach(paste0("package:", package), character.only = TRUE))
  }
  force(code)
}
