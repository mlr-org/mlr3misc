#' @title Context
#'
#' @description
#' Context objects allow [Callback] objects to access and modify data.
#' The following packages implement context subclasses:
#'
#'   * `ContextOptimization` in \CRANpkg{bbotk}.
#'   * `ContextEval` in \CRANpkg{mlr3tuning}.
#'   * `ContextTorch` in [`mlr3torch`](https://github.com/mlr-org/mlr3torch)
#'
#' @details
#' [Context] is an abstract base class.
#' A subclass inherits from [Context].
#' Data is stored in public fields.
#' Access to the data can be restricted with active bindings (see example).
#'
#' @export
#' @examples
#' library(data.table)
#' library(R6)
#'
#' # data table with column x an y
#' data = data.table(x = runif(10), y = sample(c("A", "B"), 10, replace = TRUE))
#'
#' # context only allows to access column y
#' ContextExample = R6Class("ContextExample",
#'   inherit = Context,
#'   public = list(
#'     data = NULL,
#'
#'     initialize = function(data) {
#'         self$data = data
#'     }
#'   ),
#'
#'   active = list(
#'     y = function(rhs) {
#'       if (missing(rhs)) return(self$data$y)
#'       self$data$y = rhs
#'     }
#'   )
#' )
#'
#' context = ContextExample$new(data)
#'
#' # retrieve content of column y
#' context$y
#'
#' # change content of column y to "C"
#' context$y = "C"
Context = R6::R6Class("Context",
  public = list(

    #' @field id (`character(1)`)\cr
    #' Identifier of the object.
    #' Used in tables, plot and text output.
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
    initialize = function(id, label = NA_character_) {
      self$id = assert_string(id, min.chars = 1L)
      self$label = assert_string(label, na.ok = TRUE)
    },

    #' @description
    #' Format object as simple string.
    format = function() {
      sprintf("<%s>", class(self)[1L])
    },

    #' @description
    #' Print object.
    print = function() {
       catn(format(self), if (is.null(self$label) || is.na(self$label)) "" else paste0(": ", self$label))
       catn(str_indent("* Modifiable objects:", setdiff(names(self), c(".__enclos_env__", "label", "id", "clone", "initialize", "print", "format"))))
    }
  )
)
