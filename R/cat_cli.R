#' @title Function to transform message to output
#'
#' @description
#' Wrapper around [cli::cli_format_method()].
#' Uses [base::cat()] to transform the printout from a message to an output with a line break.
#'
#' @param expr (`any`)\cr
#'   Expression that calls `cli_*` methods, [base::cat()] or[base::print()] to format an object's printout.
#'
#' @export
#' @examples
#' cat_cli({
#'   cli::cli_h1("Heading")
#'   cli::cli_li(c("x", "y"))
#' })
cat_cli = function(expr) {
  cat(cli::cli_format_method(expr), sep = "\n")
}
