#' @title Callback
#'
#' @include named_list.R
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
#' Use the [custom_callback()] function to create a Callback.
#'
#' @examples
#' # callback increases a counter
#' callback_counter = custom_callback("mlr3misc.counter",
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
  public = list(
    #' @field id (`character(1)`)\cr
    #'   Identifier of the callback.
    id = NULL,

    #' @field label (`character(1)`)\cr
    #' Label for this object.
    #' Can be used in tables, plot and text output instead of the ID.
    label = NULL,

    #' @field man (`character(1)`)\cr
    #' String in the format `[pkg]::[topic]` pointing to a manual page for this object.
    #' Defaults to `NA`, but can be set by child classes.
    man = NULL,

    #' @field state (named `list()`)\cr
    #' A callback can write data into the state.
    state = named_list(),

    #' @description
    #' Creates a new instance of this [R6][R6::R6Class] class.
    #'
    #' @param id (`character(1)`)\cr
    #'   Identifier for the new instance.
    #' @param label (`character(1)`)\cr
    #'   Label for the new instance.
    #' @param man (`character(1)`)\cr
    #'   String in the format `[pkg]::[topic]` pointing to a manual page for this object.
    #'   The referenced help package can be opened via method `$help()`.
    initialize = function(id, label = NA_character_, man = NA_character_) {
      self$id = assert_string(id)
      self$label = assert_string(label, na.ok = TRUE)
      self$man = assert_string(man, na.ok = TRUE)
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
      catn(str_indent("* Stages:", grep("^on_.*", names(self), value = TRUE)))

    },

    #' @description
    #' Opens the corresponding help page referenced by field `$man`.
    help = function() {
      open_help(self$man)
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

#' @title Convert to a Callback
#'
#' @description
#' Convert object to a [Callback] or a list of [Callback].
#'
#' @param x (any)\cr
#'   Object to convert.
#' @param ... (any)\cr
#'   Additional arguments.
#'
#' @return [Callback].
#' @export
as_callback = function(x, ...) { # nolint
  UseMethod("as_callback")
}

#' @rdname as_callback
#' @param clone (`logical(1)`)\cr
#'   If `TRUE`, ensures that the returned object is not the same as the input `x`.
#' @export
as_callback.Callback = function(x, clone = FALSE, ...) { # nolint
  if (clone) x$clone(deep = TRUE) else x
}

#' @rdname as_callback
#' @export
as_callbacks = function(x, clone = FALSE, ...) { # nolint
  UseMethod("as_callbacks")
}

#' @rdname as_callback
#' @export
as_callbacks.list = function(x, clone = FALSE, ...) { # nolint
  lapply(x, as_callback, clone = clone, ...)
}

#' @rdname as_callback
#' @export
as_callbacks.Callback = function(x, clone = FALSE, ...) { # nolint
  list(if (clone) x$clone(deep = TRUE) else x)
}

#' @title Create Custom Callback
#'
#' @description
#' Create a [Callback] from a list of functions.
#'
#' @param id (`character(1)`)\cr
#'   Identifier for the new [Callback].
#' @param label (`character(1)`)\cr
#'   Label for the new [Callback].
#' @param man (`character(1)`)\cr
#'   String in the format `[pkg]::[topic]` pointing to a manual page for this object.
#'   The referenced help package can be opened via method `$help()`.
#' @param ... (Named list of `function()`s)
#'   Public methods and fields of the [Callback].
#'   The functions must have two arguments named `callback` and `context`.
#'   The argument names indicate the stage in which the method is called.
#'
#' @export
custom_callback = function(id, label = NA_character_, man = NA_character_, ...) {
  public = list(...)
  walk(keep(public, function(x) inherits(x, "function")), function(method) assert_names(formalArgs(method), identical.to = c("callback", "context")))
  callback = R6Class("Callback",
    inherit = Callback,
    public = public
  )
  callback$new(id = id, label = label, man = man)
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
#' For a more convenient way to retrieve and construct learners, see [clbk()]/[clbks()].
#'
#' @export
mlr_callbacks = R6Class("DictionaryCallbacks",
  inherit = Dictionary,
  cloneable = FALSE
)$new()

#' @title Syntactic Sugar for Callback Construction
#'
#' @name clbk
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
clbk = function(.key, ...) {
  dictionary_sugar_get(mlr_callbacks, .key, ...)
}

#' @rdname clbk
#'
#' @param .keys (`character()`)\cr
#'   Keys of the objects to construct.
#'
#' @export
clbks = function(.keys, ...) {
  dictionary_sugar_mget(mlr_callbacks, .keys, ...)
}

#' @title Assertions for Callbacks
#'
#' @description
#' Assertions for [Callback] class.
#'
#' @param callback ([Callback]).
#'
#' @return [Callback] | List of [Callback]s.
#' @export
assert_callback = function(callback) {
  assert_class(callback, "Callback")
  invisible(callback)
}

#' @export
#' @param callbacks (list of [Callback]).
#' @rdname assert_callback
assert_callbacks = function(callbacks) {
  assert_list(callbacks)
  if (length(callbacks)) invisible(lapply(callbacks, assert_callback)) else invisible(NULL)
}
