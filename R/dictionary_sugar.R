#' @title A Quick Way to Initialize Objects from Dictionaries
#'
#' @description
#' Given a [Dictionary], retrieves the object with key `key`.
#' Arguments in `...` must be named and are consumed in the following order:
#'
#' 1. All arguments whose names match the name of an argument of the constructor
#'   are passed to the `$get()` method of the [Dictionary] for construction.
#' 2. All arguments whose names match the name of a parameter of the [paradox::ParamSet] of the
#'   constructed object are set as parameters. If there is no [paradox::ParamSet] in `obj$param_set`, this
#'   step is skipped.
#' 3. All remaining arguments are assumed to be regular fields of the constructed R6 instance, and
#'   are assigned via [`<-`].
#'
#' @param dict :: [Dictionary].
#' @param .key :: `character(1)`\cr
#'   Key of the object to construct.
#' @param ... :: `any`\cr
#'   See description.
#' @return [R6::R6Class()]
#' @export
#' @examples
#' library(R6)
#' item = R6Class("Item", public = list(x = 0))
#' d = Dictionary$new()
#' d$add("key", item)
#' dictionary_sugar(d, "key", x = 2)
dictionary_sugar = function(dict, .key, ...) {
  assert_class(dict, "Dictionary")
  if (...length() == 0L) {
    return(dictionary_get(dict, .key))
  }
  dots = assert_list(list(...), .var.name = "additional arguments passed to Dictionary")
  assert_list(dots[!is.na(names2(dots))], names = "unique", .var.name = "named arguments passed to Dictionary")

  obj = dictionary_retrieve_item(dict, .key)
  if (length(dots) == 0L) {
    return(assert_r6(dictionary_initialize_item(.key, obj)))
  }

  # pass args to constructor and remove them
  cargs = get_constructor_formals(obj$value)
  ii = is.na(names2(dots)) | names2(dots) %in% cargs
  instance = assert_r6(dictionary_initialize_item(.key, obj, dots[ii]))
  dots = dots[!ii]


  # set params in ParamSet
  if (length(dots) && exists("param_set", envir = instance, inherits = FALSE)) {
    ii = names(dots) %in% instance$param_set$ids()
    if (any(ii)) {
      instance$param_set$values = insert_named(instance$param_set$values, dots[ii])
      dots = dots[!ii]
    }
  }

  # remaining args go into fields
  if (length(dots)) {
    ndots = names(dots)
    for (i in seq_along(dots)) {
      instance[[ndots[i]]] = dots[[i]]
    }
  }

  return(instance)
}

get_constructor_formals = function(x) {
  if (inherits(x, "R6ClassGenerator")) {
    # recursively search for class constructor
    while (is.null(x$public_methods$initialize)) {
      x = x$get_inherit()
      if (is.null(x)) {
        return(character())
      }
    }
    return(names2(formals(x$public_methods$initialize)))
  }

  if (is.function(x)) {
    return(names2(formals(x)))
  }

  return(character())
}
