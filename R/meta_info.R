format_range = function(r) {
  l = r[1L]
  u = r[2L]

  str = sprintf("%s%s, %s%s",
    if (is.finite(l)) "[" else "(",
    if (is.finite(l)) c(l, l) else c("-\\infty", "-Inf"),
    if (is.finite(u)) c(u, u) else c("\\infty", "Inf"),
    if (is.finite(u)) "]" else ")")
  paste0("\\eqn{", str[1L], "}{", str[2L], "}")
}


#' @title Creates Markdown Code for Manual Pages
#'
#' @description
#' Internal function to generate the "Meta Information" section of for
#' \CRANpkg{mlr3} tasks, learners or measures.
#'
#'
#' @param obj (`any`)\cr
#'   Object of the respective class.
#'
#' @return `character()` with markdown code.
#' @keywords Internal
#' @export
meta_info_task = function(obj) {
  tab = obj$feature_types
  id = type = NULL
  tab = tab[, .(Name = id, Type = type)]

  c("",
    sprintf("* Default ID: \"%s\"", obj$id),
    sprintf("* Task type: \"%s\"", obj$task_type),
    sprintf("* Dimensions: %ix%i", obj$nrow, obj$ncol),
    sprintf("* Properties: %s", str_collapse(obj$properties, quote = "\"")),
    sprintf("* Has missings: `%s`", any(obj$missings() > 0L)),
    "",
    "Features:",
    "",
    knitr::kable(tab)
  )
}


#' @rdname meta_info_task
#' @keywords Internal
#' @export
meta_info_learner = function(obj) {
  params = as.data.table(obj$param_set)
  params$default = replace(params$default, map_lgl(params$default, inherits, "NoDefault"), list("-"))
  id = storage_type = default = lower = upper = levels = NULL
  params = params[, .(Id = id, Type = storage_type, Default = default, Lower = lower, Upper = upper, Levels = levels)]

  c("",
    sprintf("* Default ID: \"%s\"", obj$id),
    sprintf("* Task type: \"%s\"", obj$task_type),
    sprintf("* Required Packages: %s", str_collapse(obj$packages, quote = "\"")),
    sprintf("* Supported Predict Types: %s", str_collapse(obj$predict_types, quote = "\"")),
    sprintf("* Supported Features: %s", str_collapse(obj$feature_types, quote = "\"")),
    "",
    "Param Set:",
    "",
    knitr::kable(params)
  )
}


#' @rdname meta_info_task
#' @keywords Internal
#' @export
meta_info_measure = function(obj) {
  c("",
    sprintf("* Default ID: \"%s\"", obj$id),
    sprintf("* Task type: \"%s\"", obj$task_type),
    sprintf("* Required packages: %s", str_collapse(obj$packages, quote = "\"")),
    sprintf("* Task Properties: %s", str_collapse(obj$task_properties, quote = "\"")),
    sprintf("* Range: %s", format_range(obj$range)),
    sprintf("* Minimize: %s", obj$minimize),
    sprintf("* Properties: %s", str_collapse(obj$properties, quote = "\"")),
    sprintf("* Required Predict Type: %s", str_collapse(obj$predict_type, quote = "\""))
  )
}


