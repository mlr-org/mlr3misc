format_range = function(lower, upper) {
  str = sprintf("%s%s, %s%s",
    if (is.finite(lower)) "[" else "(",
    if (is.finite(lower)) c(lower, lower) else c("-\\infty", "-Inf"),
    if (is.finite(upper)) c(upper, upper) else c("\\infty", "Inf"),
    if (is.finite(upper)) "]" else ")")
  paste0("\\eqn{", str[1L], "}{", str[2L], "}")
}

format_string = function(s, quote = c("\\dQuote{", "}")) {
  if (length(s) == 0L)
    return("-")
  str_collapse(s, quote = quote)
}

#' @title Creates Markdown Code for Manual Pages
#'
#' @description
#' Internal function to generate the "Meta Information" section of for
#' \CRANpkg{mlr3} tasks, learners or measures.
#'
#' @param obj (`any`)\cr
#'   Object of the respective class.
#'
#' @return `character()` with markdown code.
#' @keywords Internal
#' @export
meta_info_task = function(obj) {
  c("",
    sprintf("* Task type: %s", format_string(obj$task_type)),
    sprintf("* Dimensions: %ix%i", obj$nrow, obj$ncol),
    sprintf("* Properties: %s", format_string(obj$properties)),
    sprintf("* Has Missings: %s", any(obj$missings() > 0L)),
    sprintf("* Target: %s", format_string(obj$target_names)),
    sprintf("* Features: %s", format_string(obj$feature_names))
  )
}


#' @rdname meta_info_task
#' @keywords Internal
#' @export
meta_info_learner = function(obj) {
  c("",
    sprintf("* Task type: %s", format_string(obj$task_type)),
    sprintf("* Required Packages: %s", format_string(obj$packages, quote = c("\\CRANpkg{", "}"))),
    sprintf("* Supported Predict Types: %s", format_string(obj$predict_types)),
    sprintf("* Supported Features: %s", format_string(obj$feature_types))
  )
}

#' @rdname meta_info_task
#' @keywords Internal
#' @export
meta_info_param_set = function(obj) {
  params = as.data.table(obj$param_set)
  params$default = replace(params$default, map_lgl(params$default, inherits, "NoDefault"), list("-"))
  params$levels = replace(params$levels, lengths(params$levels) == 0L, list("-"))
  params$range = pmap_chr(params[, c("lower", "upper"), with = FALSE], format_range)
  params = params[, c("id", "storage_type", "default", "range", "levels")]
  setnames(params, c("Id", "Type", "Default", "Range", "Levels"))
  c(
    "",
    knitr::kable(params)
  )
}
