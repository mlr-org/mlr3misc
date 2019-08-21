#' @title Key-Value Storage
#'
#' @usage NULL
#' @name Dictionary
#' @format [R6::R6Class] object.
#'
#' @description
#' A key-value store for [R6::R6] objects.
#' On retrieval of an object, the following applies:
#'
#' * If the object is a `R6ClassGenerator`, it is initialized with `new()`.
#' * If the object is a function, it is called and must return an instance of a [R6::R6] object.
#' * If the object is an instance of a R6 class, it is returned as-is.
#'
#' Default argument required for construction can be stored alongside their constructors by passing them to `$add()`.
#'
#' @section Construction:
#' ```
#' d = Dictionary$new()
#' ```
#'
#' @section Methods:
#' * `get(key, ...)`\cr
#'   (`character(1)`, ...) -> `any`\cr
#'   Retrieves object with key `key` from the dictionary.
#'   Additional arguments must be named and are passed to the constructor of the stored object.
#'
#' * `mget(keys, ...)`\cr
#'   (`character()`, ...) -> named `list()`\cr
#'   Returns objects with keys `keys` in a list named with `keys`.
#'   Additional arguments must be named and are passed to the constructors of the stored objects.
#'
#' * `has(keys)`\cr
#'   `character()` -> `logical()`\cr
#'   Returns a logical vector with `TRUE` at its i-th position if the i-th key exists.
#'
#' * `keys(pattern = NULL)`\cr
#'   `character(1)` -> `character()`\cr
#'   Returns all keys which comply to the regular expression `pattern`.
#'   If `pattern` is `NULL` (default), all keys are returned.
#'
#' * `add(key, value, ..., required_args = character())`\cr
#'   (`character(1)`, `any`, ..., `character()`) -> `self`\cr
#'   Adds object `value` to the dictionary with key `key`, potentially overwriting a previously stored item.
#'   Additional arguments in `...` must be named and are passed as default arguments to `value` during construction.
#'   The names of all additional arguments which are mandatory for construction and missing in `...` should be listed in `required_args`.
#'
#' * `remove(keys)`\cr
#'   `character()` -> `self`\cr
#'   Removes objects with keys `keys` from the dictionary.
#'
#' * `required_args(key)`\cr
#'   (`character(1)`) -> `character()`\cr
#'   Returns the names of arguments required to construct the object.
#'
#' @section S3 methods:
#' * `as.data.table(d)`\cr
#'   [Dictionary] -> [data.table::data.table()]\cr
#'   Converts the dictionary to a [data.table::data.table()].
#'
#' @family Dictionary
#' @export
#' @examples
#' library(R6)
#' item1 = R6Class("Item", public = list(x = 1))
#' item2 = R6Class("Item", public = list(x = 2))
#' d = Dictionary$new()
#' d$add("a", item1)
#' d$add("b", item2)
#' d$add("c", item1$new())
#' d$keys()
#' d$get("a")
#' d$mget(c("a", "b"))
Dictionary = R6::R6Class("Dictionary",
  public = list(
    items = NULL,

    # construct, set container type (string)
    initialize = function() {
      self$items = new.env(parent = emptyenv())
    },

    format = function() {
      sprintf("<%s>", class(self)[1L])
    },

    print = function() {
      keys = self$keys()
      catf(sprintf("%s with %i stored values", format(self), length(keys)))
      catf(str_indent("Keys:", keys))
    },

    keys = function(pattern = NULL) {
      keys = ls(self$items, all.names = TRUE)
      if (!is.null(pattern)) {
        assert_string(pattern)
        keys = keys[grepl(pattern, keys)]
      }
      keys
    },

    has = function(keys) {
      assert_character(keys, min.chars = 1L, any.missing = FALSE)
      set_names(map_lgl(keys, exists, envir = self$items, inherits = FALSE), keys)
    },

    get = function(key, ...) {
      assert_string(key, min.chars = 1L)
      dictionary_get(self, key, ...)
    },

    mget = function(keys, ...) {
      assert_character(keys, min.chars = 1L, any.missing = FALSE)
      set_names(lapply(keys, self$get, ...), keys)
    },

    add = function(key, value, ..., required_args = character()) {
      assert_string(key, min.chars = 1L)
      assert(check_class(value, "R6ClassGenerator"), check_r6(value), check_function(value))
      assert_character(required_args, any.missing = FALSE)

      dots = assert_list(list(...), names = "unique", .var.name = "additional arguments passed to Dictionary")
      assign(x = key, value = list(value = value, pars = dots, required_args = required_args), envir = self$items)
      invisible(self)
    },

    remove = function(keys) {
      i = wf(!self$has(keys))
      if (length(i)) {
        stopf("Element with key '%s' not found!%s", keys[i], did_you_mean(key, self$keys()))
      }
      rm(list = keys, envir = self$items)
      invisible(self)
    },

    required_args = function(key) {
      assert_string(key, min.chars = 1L)
      self$items[[key]][["required_args"]]
    }
  )
)

dictionary_get = function(self, key, ...) {
  obj = dictionary_retrieve_item(self, key)
  dots = assert_list(list(...), names = "unique", .var.name = "arguments passed to Dictionary")
  dictionary_initialize_item(key, obj, dots)
}

dictionary_retrieve_item = function(self, key) {
  obj = get0(key, envir = self$items, inherits = FALSE, ifnotfound = NULL)
  if (is.null(obj)) {
    stopf("Element with key '%s' not found in %s!%s", key, class(self)[1L], did_you_mean(key, self$keys()))
  }
  obj
}

dictionary_initialize_item = function(key, obj, cargs = list()) {
  cargs = c(cargs[is.na(names2(cargs))],
    insert_named(obj$pars, cargs[!is.na(names2(cargs))]))
  ii = wf(obj$required_args %nin% names(cargs))
  if (length(ii)) {
    stopf("Need argument '%s' to construct '%s'", obj$required_args[ii], key)
  }

  constructor = obj$value
  if (inherits(constructor, "R6ClassGenerator")) {
    do.call(constructor$new, cargs)
  } else if (is.function(constructor)) {
    do.call(constructor, cargs)
  } else {
    constructor
  }
}


#' @export
as.data.table.Dictionary = function(x, ...) {
  setkeyv(as.data.table(list(key = x$keys())), "key")[]
}
