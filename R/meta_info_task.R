#' @title Creates Markdown Code for Manual Pages Of Tasks
#'
#' @description
#' Internal function to generate the "Meta Information" section of tasks.
#'
#' @param id (`character(1)`)\cr
#'   Id of the tasks.
#'
#' @return `character()` with markdown code.
#' @keywords Internal
#' @export
meta_info_task = function(id) {
  obj = mlr3::tsk(id)

  tab = obj$feature_types
  id = type = NULL
  tab = tab[, .(Name = id, Type = type)]

  c("",
    sprintf("* Default ID: %s", str_collapse(obj$id, quote = "\"")),
    sprintf("* Task type: %s", str_collapse(obj$task_type, quote = "\"")),
    sprintf("* Dimensions: %ix%i", obj$nrow, obj$ncol),
    sprintf("* Properties: %s", str_collapse(obj$properties, quote = "\"")),
    "",
    "Features:",
    "",
    knitr::kable(tab)
  )
}
