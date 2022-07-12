#' @title Callback
#'
#' @description
#' Generic implementation of a callback mechanism.
#' Callbacks allow to give more user control to customize the behaviour of mlr3 processes.
#' To make use of this mechanism, three elements are required:
#'
#'   * A function that accepts a list of callbacks and executes them using the function
#'   `call_back()`.
#'   * A context that defines which information of the function can be accessed from the callback.
#'     If the callback is allowed to modify this information the context can be an environment
#'     or R6Class itself. Read-only access can be implemented using active bindings.
#'   * One or more callback functions.
#'
#' Use the `as_callback()` function to create a [Callback].
#'
#' @examples
#' MyCallback = R6Class("MyCallback",
#'   inherit = Callback,
#'   lock_objects = FALSE,
#'   public = list(
#'     initialize = function(id = "mycallback", a, b) {
#'       self$id = id
#'       self$a = a
#'       self$b = b
#'     },
#'     step1 = function(context) {
#'       catf("This is step1 calling!")
#'       context$info = "New value"
#'       self$x = runif(1, min = self$a, max = self$b)
#'     },
#'     step2 = function(context) {
#'       catf("This is step2 calling!")
#'       catf("The value 'info' of context is now: %s", context$info)
#'       catf("The randomly generated number of step1 was: %.2f", self$x)
#'     }
#'   )
#' )
#' mycb = MyCallback$new(a = -1, b = 1)
#' callbacks = list(mycb)
#' f = function(callbacks) {
#'   context = new.env()
#'   context$info = "Some Information"
#'
#'   call_back("step1", callbacks, context)
#'   catf("foo")
#'   call_back("step2", callbacks, context)
#'   return(NULL)
#' }
#' f(callbacks)
#' @export
Callback = R6Class("Callback",
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
        self[[step]](context)
      }
    }
  )
)

#' @title Call Callbacks
#'
#' @description
#' Call list of callbacks with context at specific step.
#'
#' @keywords internal
#' @export
call_back = function(step, callbacks, context) {
  walk(callbacks, function(callback) callback$call(step, context))
  return(invisible(NULL))
}

assert_callback = function(callback) {
  assert_class(callback, "Callback")
  invisible(callback)
}
