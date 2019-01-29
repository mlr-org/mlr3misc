#' @title Add slots for id and hash to an R6 class generator
#'
#' @description
#' Takes an \pkg{R6} class generator (created with [R6::R6Class])
#' and adds two active bindings (`id` and `hash`),  two
#' private fields (`.id` and `.hash`) and a private method (`.calculate_hash()`).
#'
#' If `obj$id` is called, the value of `private$.id` (`character(1)`) is returned.
#' If the id is set via assignment, `private$.hash` is invalidated by setting it to `NA_character_`.
#'
#' If `obj$hash` is called, the value of `private$.hash` (`character(1)`) is returned.
#' If the hash is `NA_character_`, the private method `private$.calculate_hash()` is called first
#' to (re-) calculate the hash. This function has to implemented manually.
#' The calculated value is stored in `private$.hash`.
#' It is possible to manually set the hash via assignment.
#'
#' @param generator (`R6ClassGenerator`).
#'   \pkg{R6} Class Generator.
#'
#' @return (`R6ClassGenerator`) with added active bindings and private fields.
#' @export
add_id_hash = function(generator) {
  assert_class(generator, "R6ClassGenerator")

  generator$set("private", ".id", NULL)

  generator$set("active", "id",
    function(rhs) {
      if (missing(rhs))
        return(private$.id)
      private$.hash = NA_character_
      private$.id = assert_string(rhs, min.chars = 1L)
    }
  )

  generator$set("private", ".hash", NA_character_)

  generator$set("active", "hash",
    function(rhs) {
      if (missing(rhs)) {
        if (is.na(private$.hash))
          private$.hash = private$.calculate_hash()
        private$.hash
      } else {
        private$.hash = assert_string(rhs, na.ok = TRUE)
      }
    }
  )

  # if (".calculate_hash" %nin% names(generator$private_methods)) {
  #   generator$set("private", ".calculate_hash",
  #     function() basename(tempfile(""))
  #   )
  # }

  generator
}
