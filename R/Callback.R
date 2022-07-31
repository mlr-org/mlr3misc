#' @title Callback
#'
#' @description
#' This is the abstract base class for callbacks.
#' Callbacks allow to give more user control to customize the behaviour of mlr3 processes.
#' To make use of this mechanism, three elements are required:
#'
#' * A function that executes a list of callbacks using the function [call_back()].
#' * A [Context] that defines which information of the function can be accessed from the callback.
#' * One or more callback objects.
#'
#' Use the [as_callback()] function to create a Callback.
#'
#' @examples
#' # callback increases a counter
#' callback_counter = as_callback("mlr3misc.counter",
#'   class = "CallbackCounter",
#'   on_stage = function(callback, context) {
#'     context$i = context$i %??% 0 + 1
#'   }
#' )
#'
#' # context with the count variable
#' ContextTest = R6::R6Class("ContextTest", inherit = Context, public = list(i = NULL))
#' context = ContextTest$new(id = "test")
#'
#' # callback is called with context and stage
#' call_back("on_stage", list(callback_counter), context)
#' @export
Callback = R6Class("Callback",
  lock_objects = FALSE,
  public = list(
    #' @field id (`character(1)`)\cr
    #'   Identifier of the callback.
    id = NULL,

    #' @field label (`character(1)`)\cr
    #' Label for this object.
    #' Can be used in tables, plot and text output instead of the ID.
    label = NULL,

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    #'
    #' @param id (`character(1)`)\cr
    #'   Identifier for the new instance.
    #' @param label (`character(1)`)\cr
    #'   Label for the new instance.
    initialize = function(id, label) {
      self$id = assert_string(id)
      self$label = assert_string(label, na.ok = TRUE)
    },

    #' @description
    #' Helper for print outputs.
    format = function() {
      sprintf("<%s:%s>", class(self)[1L], self$id)
    },

    #' @description
    #' Printer.
    #' @param ... (ignored).
    print = function(...) {
      catn(format(self), if (is.null(self$label) || is.na(self$label)) "" else paste0(": ", self$label))
      catn(c("* Stages:", grep("^on_.*", names(self), value = TRUE)))

    },

    #' @description
    #' Call the specific stage for a given context.
    #'
    #' @param stage (`character(1)`)\cr
    #'   stage.
    #' @param context (`Context`)\cr
    #'   Context.
    call = function(stage, context) {
      if (exists(stage, envir = self)) {
        self[[stage]](self, context)
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
#'   Identifier for the new [Callback].
#'
#' @param label (`character(1)`)\cr
#'   Label for the new [Callback].
#'
#' @param ... (Named list of `function()`s)
#'   Public methods of the [Callback].
#'   The functions must have two arguments named `callback` and `context`.
#'   The argument names indicate the stage in which the method is called.
#'
#' @export
as_callback = function(id, label = NA_character_, ...) {
  public = list(...)
  walk(public, function(method) assert_names(formalArgs(method), identical.to = c("callback", "context")))
  callback = R6Class("Callback",
    inherit = Callback,
    public = public,
    lock_objects = FALSE
  )
  callback$new(id = id, label = label)
}

#' @title Call Callbacks
#'
#' @description
#' Call list of callbacks with context at specific stage.
#'
#' @keywords internal
#' @export
call_back = function(stage, callbacks, context) {
  if (!length(callbacks)) return(invisible(NULL))
  assert_class(context, "Context")
  walk(callbacks, function(callback) callback$call(stage, context))
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
