#' @title Modify Values of a Parameter Set
#'
#' @description Convenience function to modfiy (or overwrite) the values of a [paradox::ParamSet].
#'
#' @param .ps ([paradox::ParamSet])\cr
#'   The parameter set whose values are changed.
#' @param ... (`any`)
#'   Named parameter values.
#' @param .values (`list()`)
#'   Named list with parameter values.
#' @param .insert (`logical(1)`)\cr
#'  Whether to insert the values (old values are being kept, if not overwritten), or to discard the
#'  old values. Is TRUE by default.
#'
#' @export
#' @examples
#' if (requireNamespace("paradox")) {
#'   param_set = paradox::ps(a = paradox::p_dbl(), b = paradox::p_dbl())
#'   param_set$values$a = 0
#'   set_params(param_set, a = 1, .values = list(b = 2), .insert = TRUE)
#'   set_params(param_set, a = 3, .insert = FALSE)
#'   set_params(param_set, b = 4, .insert = TRUE)
#' }
set_params = function(.ps, ..., .values = list(), .insert = TRUE) {
  dots = list(...)
  assert_list(dots, names = "unique")
  assert_list(.values, names = "unique")
  assert_disjunct(names(dots), names(.values))
  new_values = c(dots, .values)
  if (.insert) {
    .ps$values = insert_named(.ps$values, new_values)
  } else {
    .ps$values = new_values
  }
  return(.ps)
}
