

repr = function(x, ...) {
  UseMethod("repr")
}

#' Representation for something that may or may not have a `"repr"` attribute.
#' If it is not, we just use deparse(), otherwise we use the repr as
#' reported by that selector.
#' @export
repr.default = function(x, ...) {
  if (test_string(attr(x, "repr"))) {
    attr(x, "repr")
  } else {
    # TODO: need to set options explicitly because systems may have different default settings
    # TODO2: multi line deparsing is a problem.
    str_collapse(deparse(x), sep = "\n")
  }
}

repr.R6 = function(x, ...) {
  stop("Not representable.")
}

repr.Representable = function(x, ...) {
  x$repr(...)
}

Representable = R6Class("Representable",
  public = list(
    repr = function(...) {
      stop("repr() not implemented")
    }
  )
)

Representable_In_Dict = R6Class("Representable_In_Dict",
  inherit = "Representable",
  public = list(
    initialize = function() {
      level = 0
      while (is.null(private$.repr_dictkey)) {
        level = level - 1
        initfun = sys.function(level)
        if ("new" %in% names(environment(initfun))) {
          stop("Representable_In_Dict has uninitialized .repr_dictkey that could not be inferred.")
        }
        possible_id = names(formals(initfun))
        if (test_string(possible_id)) {
          private$.repr_dictkey = possible_id
        }
      }
    },
    repr = function(...) {
      sprintf("%s(\"%s\")", self$repr_dictionary, self$repr_dictkey)
    }
  ),
  active = list(
    repr_dictionary = function(val) {
      if (!missing(val)) {
        stop("repr_dictionary is read-only.")
      }
      private$.repr_dictionary
    },
    repr_dictkey = function(val) {
      if (!missing(val)) {
        stop("repr_dictkey is read-only.")
      }
      private$.repr_dictkey
    }
  ),
  private = list(
    .repr_dictionary = NULL,
    .repr_dictkey = NULL
  )
)

