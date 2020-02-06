#' @title Opens a Manual Page
#'
#' @description
#' Simply opens a manual page specified in "package::topic" syntax.
#'
#' @param man (`character(1)`)\cr
#'   Manual page to open in "package::topic" syntax.
#' @return Nothing.
#' @export
open_help = function(man) {
  if (!test_string(man)) {
    message("No help available")
    return(invisible())
  }

  parts = strsplit(man, split = "::", fixed = TRUE)[[1L]]
  match.fun("help")(parts[2L], parts[1L])
}
