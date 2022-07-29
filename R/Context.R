#' @title Context
#'
#' @description
#' This is the abstract base class for context objects.
#' Context objects provide modifiable data to [Callback] objects.
#'
#' @export
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
       catn("Modifiable objects:")
       catn(paste("-", names(self$.__enclos_env__$.__active__)))
    }
  )
)
