#' @title Callback
#'
#' @description
#' This is the abstract base class for callbacks.
#' Callbacks allow to give more user control to customize the behaviour of mlr3 processes.
#' To make use of this mechanism, three elements are required:
#'
#' * A function that executes a list of callbacks using the function [call_back()].
#' * A [Context] that defines which information of the function can be accessed from the callback.
#' * One or more callback functions.
#'
#' Use the [as_callback()] function to create a Callback.
#'
#' @examples
#' # write callback
#' callback_counter = as_callback("counter",
#'   step_1 = function(callback, context) {
#'     context$i = context$i %??% 0 + 1
#'   }
#' )
#'
#' # define context
#' ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(i = NULL))
#' context = ContextTest$new(id = "test")
#'
#' # call list of callbacks at specific step
#' call_back("step_1", list(callback_counter), context)
#' @export
Callback = R6Class("Callback",
  lock_objects = FALSE,
  public = list(
    #' @field id (`character(1)`)\cr
    #'   Identifier of the callback.
    id = NULL,

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    #'
    #' @param id (`character(1)`)\cr
    #'   Identifier for the new callback.
    initialize = function(id) {
      self$id = assert_character(id)
    },

    #' @description
    #' Call the specific step for a given context.
    #'
    #' @param step (`character(1)`)\cr
    #'   Step.
    #' @param context (`Context`)\cr
    #'   Context.
    call = function(step, context) {
      if (!is.null(self[[step]])) {
        self[[step]](self, context)
      }
    }
  )
)

#' @title Create a Callback
#'
#' @description
#' Create a [Callback] from a list of functions.
#'
#' @param id (`character(1)`)\cr
#'   Identifier for the new callback.
#'
#' @param ... (Named list of `function()`s)
#'   Public methods of the [Callback].
#'   The functions must have two arguments named `callback` and `context`.
#'   The argument names indicate the step in which the method is called.
#'
#' @export
as_callback = function(id, ...) {
  public = list(...)
  walk(public, function(method) assert_names(formalArgs(method), identical.to = c("callback", "context")))
  callback = R6Class(paste0("Callback", capitalize(id)),
    inherit = Callback,
    public = public
  )
  callback$new(id = id)
}

#' @title Call Callbacks
#'
#' @description
#' Call list of callbacks with context at specific step.
#'
#' @keywords internal
#' @export
call_back = function(step, callbacks, context) {
  if (!length(callbacks)) return(invisible(NULL))
  assert_class(context, "Context")
  walk(callbacks, function(callback) callback$call(step, context))
  return(invisible(NULL))
}

#' @title Dictionary of Callbacks
#'
#' @include Dictionary.R
#'
#' @description
#' A simple [mlr3misc::Dictionary] storing objects of class [Callback].
#' Each callback has an associated help page, see `mlr_callbacks_[id]`.
#'
#' This dictionary can get populated with additional callbacks by add-on packages.
#' As a convention, the key should start with the name of the package, i.e. `package.callback`.
#'
#' For a more convenient way to retrieve and construct learners, see [cllb()]/[cllbs()].
#'
#' @export
mlr_callbacks = R6Class("DictionaryCallbacks",
  inherit = Dictionary,
  cloneable = FALSE
)$new()

#' @title Syntactic Sugar for Callback Construction
#'
#' @name cllb
#'
#' @description
#' Retrieve a callback from [mlr_callbacks].
#'
#' @param .key (`character(1)`)\cr
#'   Key of the object to construct.
#' @param ... (ignored).
#'
#' @seealso Callback call_back
#'
#' @export
cllb = function(.key, ...) {
  dictionary_sugar_get(mlr_callbacks, .key, ...)
}

#' @rdname cllb
#'
#' @param .keys (`character()`)\cr
#'   Keys of the objects to construct.
#'
#' @export
cllbs = function(.keys, ...) {
  dictionary_sugar_mget(mlr_callbacks, .keys, ...)
}

assert_callback = function(callback) {
  assert_class(callback, "Callback")
  invisible(callback)
}
