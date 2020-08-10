
# Moves a method of an R6Class Generator to the package namespace. The R6Class's
# method is reduced to a stum method that calls the moved function.
#
# This creates a function named `.__<CLASSNAME>__<FUNCTIONNAME>` inside `env`.
#
# leanificate_method is called by leanify_r6 for each function of an R6 class.
# @param cls (`R6ClassGenerator`): R6Class object (i.e. R6 object generator) to modify
# @param name (`character(1)`): name of the function
# @param env (`environment`): the target environment where the function should
#   be stored. Should be either `cls$parent_env` or one of its parent environments,
#   otherwise the stump function will not find the moved (original code) function.
# @return NULL
leanificate_method = function(cls, fname, env = cls$parent_env) {
  cname = cls$classname

  # find out where the function is stored: public, private, active. This is also
  # relevant for the `cls$set()` call at the end: we need to set the function to
  # the right protection kind as it was before.
  for (function_kind_container in c("public_methods", "private_methods", "active")) {
    fn = cls[[function_kind_container]][[fname]]
    if (!is.null(fn)) break
  }
  if (is.null(fn)) {
    stop(sprintf("Could not find function %s in class %s", fname, cname))
  }

  exportfname = sprintf(".__%s__%s", cname, fname)
  origformals = formals(fn)
  formals(fn) = c(pairlist(self = substitute(), private = substitute(), super = substitute()), formals(fn))
  assign(exportfname, fn, env)
  replacingfn = eval(call("function", origformals,
    as.call(c(list(as.symbol(exportfname)), sapply(names(formals(fn)), as.symbol, simplify = FALSE)))))
  environment(replacingfn) = environment(fn)

  function_kind = switch(function_kind_container, public_methods = "public", private_methods = "private", active = "active")
  cls$set(function_kind, fname, replacingfn, overwrite = TRUE)
}

#' @title Move all methods of an R6 Class to an environment
#'
#' @description
#' `leanify_r6` Moves the content of all of an [`R6::R6Class`]'s functions to an environment,
#' preferably a package's namespace, to save space. This is useful
#' because of \url{https://github.com/mlr-org/mlr3/issues/482}.
#'
#' The function in the class (i.e. the object generator) is replaced by a stump
#' function that does nothing except call the original function that now resides
#' somewhere else.
#'
#' It is possible to call this function after the definition of an [`R6::R6`]
#' class inside a package, but it is preferred to use [leanify_package()]
#' to just leanify all [`R6::R6`] classes inside a package.
#'
#' @param cls :: [`R6::R6Class`]\cr
#'   Class generator to modify.
#' @param env :: `environment`\cr
#'   The target environment where the function should
#'   be stored. This should be either `cls$parent_env` (default) or one of its
#'   parent environments, otherwise the stump function will not find the moved
#'   (original code) function.
#' @return `NULL`.
#' @export
leanify_r6 = function(cls, env = cls$parent_env) {
  assert_class(cls, "R6ClassGenerator")
  assert_environment(env)
  for (assignwhich in c("public_methods", "private_methods", "active")) {
    for (fname in names(cls[[assignwhich]])) {
      leanificate_method(cls, fname, env = env)
    }
  }
}

#' @describeIn leanify_r6 Move all methods of all R6 Classes to ban environment
#'
#' @param `pkg.env` :: `environment`\cr
#'   The namespace from which to leanify all R6 classes. Does not have to be a
#'   package namespace, but this is the intended usecase.
#' @param `skip_if` :: `function`\cr
#'   Function with one argument: Is called for each individual [`R6::R6Class`].
#'   If it returns `TRUE`, the class is skipped. Default function evaluating to `FALSE`
#'   always (i.e. skipping no classes).
#' @export
leanify_package = function(pkg.env = parent.frame(), skip_if = function(x) FALSE) {
  assert_environment(pkg.env)
  assert_function(skip_if)
  for (varname in names(pkg.env)) {
    content = get(varname, envir = pkg.env)
    if (!R6::is.R6Class(content)) next
    if (isTRUE(skip_if(content))) next
    leanify_r6(content)
  }
}
