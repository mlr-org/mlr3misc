#' @title Callback
#'
#' @include named_list.R
#'
#' @description
#' Callbacks allow to customize the behavior of processes in mlr3 packages.
#' The following packages implement callbacks:
#'
#'   * `CallbackOptimization` in \CRANpkg{bbotk}.
#'   * `CallbackTuning` in \CRANpkg{mlr3tuning}.
#'   * `CallbackTorch` in [`mlr3torch`](https://github.com/mlr-org/mlr3torch)
#'
#' @details
#' [Callback] is an abstract base class.
#' A subclass inherits from [Callback] and adds stages as public members.
#' Names of stages should start with `"on_"`.
#' For each subclass a function should be implemented to create the callback.
#' For an example on how to implement such a function see `callback_optimization()` in \CRANpkg{bbotk}.
#' Callbacks are executed at stages using the function [call_back()].
#' A [Context] defines which information can be accessed from the callback.
#'
#' @examples
#' library(R6)
#'
#' # implement callback subclass
#' CallbackExample = R6Class("CallbackExample",
#'   inherit = mlr3misc::Callback,
#'   public = list(
#'     on_stage_a = NULL,
#'     on_stage_b = NULL,
#'     on_stage_c = NULL
#'   )
#' )
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
    #' @param ... (ignored).
    format = function(...) {
      sprintf("<%s:%s>", class(self)[1L], self$id)
    },

    #' @description
    #' Printer.
    #' @param ... (ignored).
    print = function(...) {
      catn(format(self), if (is.null(self$label) || is.na(self$label)) "" else paste0(": ", self$label))
      # get methods that start with "on_" and discard null
      catn(str_indent("* Active Stages:", names(discard(as.list(self)[grep("^on_.*", names(self), value = TRUE)], is.null))))

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
      if (!is.null(self[[stage]])) {
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
#' Functions to retrieve callbacks from [mlr_callbacks] and set parameters in one go.
#'
#' @param .key (`character(1)`)\cr
#'   Key of the object to construct.
#' @param ... (named `list()`)\cr
#'   Named arguments passed to the state of the callback.
#'
#' @seealso Callback call_back
#'
#' @export
clbk = function(.key, ...) {
  callback = dictionary_sugar_get(mlr_callbacks, .key)
  callback$state = list(...)
  callback
}

#' @rdname clbk
#'
#' @param .keys (`character()`)\cr
#'   Keys of the objects to construct.
#'
#' @export
clbks = function(.keys) {
  dictionary_sugar_mget(mlr_callbacks, .keys)
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
