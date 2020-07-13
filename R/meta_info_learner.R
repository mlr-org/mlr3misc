#' @title Creates Markdown Code for Manual Pages Of Learners
#'
#' @description
#' Internal function to generate the "Meta Information" section of learners.
#'
#' @param id (`character(1)`)\cr
#'   Id of the learner.
#'
#' @return `character()` with markdown code.
#' @keywords Internal
#' @export
meta_info_learner = function(id) {
  obj = lrn(id)
  params = as.data.table(obj$param_set)
  params$default = replace(params$default, map_lgl(params$default, inherits, "NoDefault"), list("-"))
  id = storage_type = default = lower = upper = levels = NULL
  params = params[, .(Id = id, Type = storage_type, Default = default, Lower = lower, Upper = upper, Levels = levels)]

  c("",
    sprintf("* Default ID: %s", str_collapse(obj$id, quote = "\"")),
    sprintf("* Supported task type: %s", str_collapse(obj$task_type, quote = "\"")),
    sprintf("* Required packages: %s", str_collapse(obj$packages, quote = "\"")),
    sprintf("* Supported predict types: %s", str_collapse(obj$predict_types, quote = "\"")),
    sprintf("* Supported Features: %s", str_collapse(obj$feature_types, quote = "\"")),
    "",
    "Param Set:",
    "",
    knitr::kable(params)
  )
}
