
#' @title Add Object to Dictionary at Runtime
#'
#' @description
#' `register_dictionary` registers that a dictionary entry
#' should be created using the given arguments. `publish_registered_dictionary`
#' executes these calls. `register_dictionary` can be used during build-time
#' (i.e. at the top-level of the package), while `publish_registered_dictionary`
#' should be called in `.onLoad()`.
#'
#' @param dict_name (`character(1)`)\cr
#'   Name of dictionary to register the call to. Must be identical between
#'   `register_dictionary` and `publish_registered_dictionary` calls.
#' @param ... (any)\cr
#'   Arguments of `dict_call` to use when creating dictionary entry.
#' @export
#' @examples
#' \dontrun{
#' # in package top level code:
#' register_dictionary("learner", "regr.rpart", LearnerRegrRpart)
#'
#' # .onLoad code:
#' .onLoad = function(libname, pkgname) {
#'   if (is.null(mlr_learners)) {
#'     mlr_learners <<- DictionaryLearner$new()
#'   }
#'   publish_registered_dictionary("learner", mlr_learners$add)
#' }
#' }
register_dictionary = function(dict_name, ...) {

  m = match.call()
  m[["dict_name"]] = NULL

  targetenv = parent.frame()

  registry_name = sprintf(".registry_%s", dict_name)

  registry = get0(registry_name, targetenv, inherits = FALSE)

  registry = c(registry, list(m))
  
  assign(registry_name, registry, targetenv)
}

#' @rdname register_dictionary
#' @param dict_call (`function`)\cr
#'   Function to call for each registered dictionary entry.
#' @param targetenv (`environment`)\cr
#'   Environment in which `register_dictionary` was executed, usually the
#'   package's namespace.
#' @export
publish_registered_dictionary = function(dict_name, dict_call, targetenv = parent.env(parent.frame())) {
  registry_name = sprintf(".registry_%s", dict_name)

  registry = get0(registry_name, targetenv, inherits = FALSE)

  protocall = substitute(dict_call)

  for (regcall in registry) {
    regcall[[1]] = protocall
    eval(regcall, envir = parent.frame())
  }
  rm(list = registry_name, envir = targetenv)
}
